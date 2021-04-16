module mr_random_tb (
    input clk,
    output logic rst, txd,
    input logic cardet, valid, eof, error,
    input logic [7:0] data
    );


    timeunit 1ns / 100ps;

    parameter CLKPD_NS = 10;
    parameter BIT_RATE = 50_000;
    localparam BITPD_NS = 1_000_000_000 / BIT_RATE;  // bit period in ns
    parameter ERROR_RATE_PPM = 100;  // error rate per million clock cycles

    // tasks for common functions including checking



    int errcount = 0;

    //   task check( exp_v1 /* add expected values to test */ );
    //       if (v1 != exp_v1) begin
    //            $display("%t error: %0d expected v1=%h actual v1=%h",
    //                     $time, exp_v1, v1);
    //            errcount++;
//      end
// place additional tests here
//   endtask: check

task report_errors;
    if (errcount == 0) $display("Testbench PASSED");
    else $display("Testbench FAILED with %d errors", errcount);
endtask: report_errors

logic txd_clean;

// Noise injection for normal signal

logic noise_error;

assign txd = txd_clean ^ noise_error;


int r;
always @(posedge clk)
begin
    #1;
    r = $urandom_range(1_000_000,1);
    //$display("r=%d",r);
    if (r <= ERROR_RATE_PPM) begin
        noise_error = 1;
        //$display("%t error injected", $time);
    end
    else noise_error = 0;
end

// tasks to send data, eof, and noise to txd

task do_reset();
    rst = 1;
    @(posedge clk) #1;
    rst = 0;
    @(posedge clk) #1;
endtask

task send_bit(input logic d);
    txd_clean = d;
    #(BITPD_NS/2);
    txd_clean = !d;
    #(BITPD_NS/2);
endtask

task send_byte(input logic [7:0] data);
    //$display("send_byte: %h at time %t", data, $time);
    for (int i=0; i<=7; i++) begin
        send_bit(data[i]);  // send lsb first
    end
endtask

localparam PREAMBLE=8'b01010101;
localparam SFD=8'b11010000;

task send_preamble(input int len=1);
    for (int i=0; i<len; i++) send_byte(PREAMBLE);
endtask

task send_sfd;
    send_byte(SFD);
endtask

// send an EOF marker with length in bit periods
task send_eof(input int length);
    txd_clean = 1;
    #(BITPD_NS * length);
endtask

task send_noise(input int length);
    for (int i=0; i< (length*BITPD_NS/CLKPD_NS); i++) begin
        @(posedge clk) #1;
        txd_clean = $urandom() & 1;  // coin toss
    end
endtask

// send an EOF marker with length in bit periods
task send_error_low(input int length);
    txd_clean = 0;
    #(BITPD_NS * length);
endtask

task send_bad_sfd;
    send_byte(PREAMBLE);
    send_byte(PREAMBLE);
    send_byte(8'b11011001);
    send_noise(5);
endtask

// receive a byte on the rdy-valid interface - should be called in
// separate thread from stimulus
// wait for assertion of valid while cardet=1
// if cardet
task receive_byte(output logic [7:0] b, output logic car_active);
    wait(cardet);
    car_active = 1;
    while(cardet) begin
        @(posedge clk) #1;
        if (valid) begin
            b = data;
            //$display("receive_byte: t=%t val=%2d", $time, b);
            return;;
        end
        // check for anticipated error here (later)
    end
    car_active = 0;  // no more bytes
    b = 'x;
    $display("receive_byte: cardet=0");
endtask

class mx_frame_t;
    int unsigned frame_num = 0;
    rand enum {FRAME_GOOD, FRAME_NOEOF, FRAME_BITERR} ftype;
    rand int unsigned partial_bits;
    rand int unsigned preamble_len;  // in bytes
    rand logic [7:0] payload [];
    rand  int unsigned eof_len; // in bit periods
    rand int unsigned noise_len;

    constraint c_ftype { ftype dist { FRAME_GOOD:=5, FRAME_NOEOF:=5, FRAME_BITERR:=5}; }

    constraint c_pre_len { preamble_len >=2 ; preamble_len <= 4; }

    constraint c_partial_bits { partial_bits inside { [1:6] }; };

    constraint c_payload_len { payload.size() inside{ [1:20]}; }

    constraint c_eof_len { eof_len dist {2:=60, [3:16]:=40}; }

    constraint c_noise_nlen { noise_len inside{[30:40]}; }

    function void fill_frame;
        frame_num++;
        if (!this.randomize()) begin
            $fatal(1, "mxframe: randomize failed!");
        end
    endfunction

    function void print (input bit verbose);
        $display("===============================");
        $display("frame_num=%2d", frame_num);
        $display("ftype=%s", ftype.name());
        $display("preamble_len=%2d", preamble_len);
        $display("payload size=%0d",payload.size());
        if (verbose) begin
            for(int i=0; i<payload.size; i++) $display("payload[%0d]=%3d", i, payload[i]);
        end
        $display("eof_len=%d", eof_len);
        $display("noise_len=%d", noise_len);
        $display("partial_bits%d",partial_bits);
        $display("===============================");
    endfunction

    task send;
        //$display("starting send at t=%t", $time);
        send_preamble(preamble_len);
        send_sfd();
        for (int i=0; i < payload.size()-1; i++) begin  // send all but the last byte
            send_byte(payload[i]);
        end
        if (ftype==FRAME_BITERR) begin  // truncate last byte for biterr
            for (int j=0; j < partial_bits; j++)
                send_bit(payload[payload.size()-1][j]);
        end
        else send_byte(payload[payload.size()-1]);
        if (ftype !=FRAME_NOEOF) send_eof(eof_len);
        send_noise(noise_len);
    endtask

    task check_receive_frame;
        logic [7:0] b;
        logic car_active;
        logic err_det;
        int rxerror = 0;
        int expected_bytes;
        // FRAME_BITERR only sends partial last byte
        if (ftype == FRAME_BITERR) expected_bytes = payload.size() - 1;
        else expected_bytes = payload.size;
        //$display("starting check_receive_frame at t=%t", $time);
        wait(cardet==1);
        // check that we get all of the expected bytes
        for (int i=0; i<expected_bytes; i++) begin
            receive_byte(b, car_active);
            if (!car_active) begin
                $display("check_receive_frame: t=%d premature end of frame %d at byte %d", $time, frame_num, i);
                errcount++;
                return;
            end
            else if (b != payload[i]) begin
                $display("check_receive_frame: time=%t frame %d byte %d expected %d received %d", $time, frame_num, i, payload[i], b);
                rxerror++;
                errcount++;  // don't return here - keep looking for any more bytes
            end
        end // for
        while (cardet == 1) begin  // wait for cardet to fall and check for extra bytes
            @(posedge clk) #1;
            if (valid) begin
                $display("check_receive_frame: unexpected extra byte %d transferred at time=%t", data, $time);
                rxerror++;
                errcount++;
            end
        end
        // at this point the frame is done - check whether error matches expected value
        if (ftype == FRAME_GOOD) begin
            if (error) begin
                $display("check_receive_frame: unexpected error at end of frame %0d", frame_num);
                rxerror++;
                errcount++;
            end
        end
        else begin // error epected!
            if (!error) begin
                $display("check_receive_frame: expected error %s not reported at end of frame %0d", ftype.name(), frame_num);
                rxerror++;
                errcount++;
            end
        end
        $display("receive frame: frame %d received with %d errors", frame_num, rxerror);
    endtask
endclass

parameter NUM_FRAMES = 10;

mx_frame_t f;

covergroup CovFType;
    coverpoint f.payload.size() {
        bins single = { 1 };
        bins short = { [2:4]};
        bins med = { [5:10]};
        bins long = { [11:20]};
     }
    coverpoint f.ftype;
endgroup


initial begin
    CovFType cv;
    cv = new;

    f = new;
    $timeformat(-9, 0, "ns", 6);
    do_reset;
    send_noise(3);
    for (int j=1; j<=NUM_FRAMES; j++) begin
        f.fill_frame();
        cv.sample();
        f.print(0);
        fork
            f.send();
            f.check_receive_frame();
        join
    end
    send_noise(10);
    report_errors();
    $finish;
end

endmodule
