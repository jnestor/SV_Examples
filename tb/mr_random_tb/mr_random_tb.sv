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
    task receive_byte(output logic [7:0] b, output logic car_active, output logic rcv_err);
        wait(cardet);
        car_active = 1;
        rcv_err = 0;
        while(cardet) begin
            @(posedge clk) #1;
            if (valid) begin
                b = data;
                $display("receive_byte: t=%t val=%2d", $time, b);
            end
            // check for anticipated error here (later)
        end
        car_active = 0;  // no more bytes
        b = 'x;
        $display("receive_byte: cardet=0");
        if (error) begin
            rcv_err = 1;
            $display("receive_byte: error detected");
        end
    endtask

    class mx_frame_t;
        int unsigned frame_num = 0;
        rand int unsigned preamble_len;  // in bytes
        rand logic [7:0] payload [];
        rand  int unsigned eof_len; // in bit periods
        rand int unsigned noise_len;

        constraint c_pre_len { preamble_len >=2 ; preamble_len <= 4; }

        constraint c_payload_len { payload.size() inside{ [1:8]}; }

         constraint c_eof_len { eof_len dist {2:=60, [3:16]:=40}; }

         constraint c_noise_nlen { noise_len inside{[0:20]}; }

         function void fill_frame;
             frame_num++;
             if (!this.randomize()) begin
                 $fatal("mxframe: randomize failed!");
             end
         endfunction

        function void print;
            $display("===============================");
            $display("frame_num=%d2", frame_num);
            $display("preamble_len=%2d", preamble_len);
            $display("payload size=%0d",payload.size());
            for(int i=0; i<payload.size; i++) $display("payload[%0d]=%3d", i, payload[i]);
            $display("eof_len=%d", eof_len);
            $display("noise_len=%d", noise_len);
            $display("===============================");
        endfunction

        task send;
            send_preamble(preamble_len);
            send_sfd();
            for (int i=0; i < payload.size(); i++) send_byte(payload[i]);
            send_eof(eof_len);
            send_noise(noise_len);
        endtask

        task check_receive_frame;
            logic [7:0] b;
            logic car_active;
            logic err_det;
            int rxerror = 0;
            for (int i=0; i<payload.size(); i++) begin
                receive_byte(b, car_active, err_det);
                if (!car_active) begin
                    $display("receive_frame: t=%d premature end of frame %d at byte %d",
                            $time, frame_num, i);
                    errcount++;
                    return;
                end
                else if (b != payload[i]) begin
                    $display("receive_frame: time=%t frame %d byte %d expected %d received %d",
                    $time, frame_num, i, payload[i], b);
                    rxerror++;
                    errcount++;
                end
            end
            wait (!cardet);
            $display("receive frame: frame %d received with %d errors", frame_num, rxerror);
        endtask
    endclass

    parameter NUM_FRAMES = 5;

    initial begin
        mx_frame_t f;
        f = new;
        $timeformat(-9, 0, "ns", 6);
        do_reset;
        send_noise(3);
        for (int j=1; j<=NUM_FRAMES; j++) begin
            f.fill_frame();
            f.print();
            f.send();
        end
        $stop;
    end
    //fork
    //    f.send();
    //    f.receive_frame();
//join

endmodule
