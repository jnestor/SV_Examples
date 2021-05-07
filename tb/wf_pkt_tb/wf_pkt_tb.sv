//-----------------------------------------------------------------------------
// Module Name   : wimpfi_rcvr_tb - testbench for wimpfi receiver
// Project       : ECE 416 - Advanced Digital System Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : May 2021
//-----------------------------------------------------------------------------
// Description   : Generate packets of varying length and use to test
//                 WimpFi receiver
//-----------------------------------------------------------------------------

module wf_pkt_tb (
    input clk,
    output logic rst, txd,
    output logic [7:0] mac,
    input logic rdata, rvalid, cardet,
    output logic rrdy,
    input logic [7:0] rerrcnt
    );


    timeunit 1ns / 100ps;

    parameter CLKPD_NS = 10;
    parameter BIT_RATE = 50_000;
    localparam BITPD_NS = 1_000_000_000 / BIT_RATE;  // bit period in ns

    parameter MAC = "N";
    assign mac = MAC;

    // lookup table for byte-level CRC - from Maxim app note
    byte unsigned crc_array[256] = {
    	8'h00, 8'h5e, 8'hbc, 8'he2, 8'h61, 8'h3f, 8'hdd, 8'h83,
    	8'hc2, 8'h9c, 8'h7e, 8'h20, 8'ha3, 8'hfd, 8'h1f, 8'h41,
    	8'h9d, 8'hc3, 8'h21, 8'h7f, 8'hfc, 8'ha2, 8'h40, 8'h1e,
    	8'h5f, 8'h01, 8'he3, 8'hbd, 8'h3e, 8'h60, 8'h82, 8'hdc,
    	8'h23, 8'h7d, 8'h9f, 8'hc1, 8'h42, 8'h1c, 8'hfe, 8'ha0,
    	8'he1, 8'hbf, 8'h5d, 8'h03, 8'h80, 8'hde, 8'h3c, 8'h62,
    	8'hbe, 8'he0, 8'h02, 8'h5c, 8'hdf, 8'h81, 8'h63, 8'h3d,
    	8'h7c, 8'h22, 8'hc0, 8'h9e, 8'h1d, 8'h43, 8'ha1, 8'hff,
    	8'h46, 8'h18, 8'hfa, 8'ha4, 8'h27, 8'h79, 8'h9b, 8'hc5,
    	8'h84, 8'hda, 8'h38, 8'h66, 8'he5, 8'hbb, 8'h59, 8'h07,
    	8'hdb, 8'h85, 8'h67, 8'h39, 8'hba, 8'he4, 8'h06, 8'h58,
    	8'h19, 8'h47, 8'ha5, 8'hfb, 8'h78, 8'h26, 8'hc4, 8'h9a,
    	8'h65, 8'h3b, 8'hd9, 8'h87, 8'h04, 8'h5a, 8'hb8, 8'he6,
    	8'ha7, 8'hf9, 8'h1b, 8'h45, 8'hc6, 8'h98, 8'h7a, 8'h24,
    	8'hf8, 8'ha6, 8'h44, 8'h1a, 8'h99, 8'hc7, 8'h25, 8'h7b,
    	8'h3a, 8'h64, 8'h86, 8'hd8, 8'h5b, 8'h05, 8'he7, 8'hb9,
    	8'h8c, 8'hd2, 8'h30, 8'h6e, 8'hed, 8'hb3, 8'h51, 8'h0f,
    	8'h4e, 8'h10, 8'hf2, 8'hac, 8'h2f, 8'h71, 8'h93, 8'hcd,
    	8'h11, 8'h4f, 8'had, 8'hf3, 8'h70, 8'h2e, 8'hcc, 8'h92,
    	8'hd3, 8'h8d, 8'h6f, 8'h31, 8'hb2, 8'hec, 8'h0e, 8'h50,
    	8'haf, 8'hf1, 8'h13, 8'h4d, 8'hce, 8'h90, 8'h72, 8'h2c,
    	8'h6d, 8'h33, 8'hd1, 8'h8f, 8'h0c, 8'h52, 8'hb0, 8'hee,
    	8'h32, 8'h6c, 8'h8e, 8'hd0, 8'h53, 8'h0d, 8'hef, 8'hb1,
    	8'hf0, 8'hae, 8'h4c, 8'h12, 8'h91, 8'hcf, 8'h2d, 8'h73,
    	8'hca, 8'h94, 8'h76, 8'h28, 8'hab, 8'hf5, 8'h17, 8'h49,
    	8'h08, 8'h56, 8'hb4, 8'hea, 8'h69, 8'h37, 8'hd5, 8'h8b,
    	8'h57, 8'h09, 8'heb, 8'hb5, 8'h36, 8'h68, 8'h8a, 8'hd4,
    	8'h95, 8'hcb, 8'h29, 8'h77, 8'hf4, 8'haa, 8'h48, 8'h16,
    	8'he9, 8'hb7, 8'h55, 8'h0b, 8'h88, 8'hd6, 8'h34, 8'h6a,
    	8'h2b, 8'h75, 8'h97, 8'hc9, 8'h4a, 8'h14, 8'hf6, 8'ha8,
    	8'h74, 8'h2a, 8'hc8, 8'h96, 8'h15, 8'h4b, 8'ha9, 8'hf7,
    	8'hb6, 8'he8, 8'h0a, 8'h54, 8'hd7, 8'h89, 8'h6b, 8'h35
    };

    function logic [7:0] update_crc(input logic [7:0] crc, new_byte);
        return crc_array[crc ^ new_byte];
    endfunction

    int errcount = 0;

    task report_errors;
        if (errcount == 0) $display("Testbench PASSED");
        else $display("Testbench FAILED with %d errors", errcount);
    endtask: report_errors


    // tasks to send Manchester data, eof, and noise to txd

    task do_reset();
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        @(posedge clk) #1;
    endtask

    task send_bit(input logic d);
        txd = d;
        #(BITPD_NS/2);
        txd = !d;
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
        txd = 1;
        #(BITPD_NS * length);
    endtask

    task send_noise(input int length);
        for (int i=0; i< (length*BITPD_NS/CLKPD_NS); i++) begin
            @(posedge clk) #1;
            txd = $urandom() & 1;  // coin toss
        end
    endtask

    // receive a byte on the wimpfi recevier's rdy-valid interface
    // - should be called in after receiver has processed an incoming packet
    // (not necessarily in a separate thread)
    task receive_byte(output logic [7:0] b, output logic new_err);

    endtask

    class wf_pkt;
        int unsigned pkt_num = 0;
        rand enum {NO_ERROR, CRC_ERROR} err_type;
        rand logic [7:0] dst;
        logic [7:0] src = mac;
        rand logic [7:0] pkt_type;
        rand int unsigned data_len;
        logic [7:0] data [];
        logic [7:0] crc;
        rand int unsigned noise_len;
        logic [7:0] old_rerrcnt;

        constraint c_err_type { err_type dist { NO_ERROR:=90, CRC_ERROR:=10}; }

        // only try type 0 and 1 packets for now
        constraint c_pkt_type { pkt_type inside { ["0":"1"] }; }

        constraint c_data_len { data_len dist { 1:=10, [2:10]:= 89, [11:251]:=1 }; }

        constraint c_noise_len { noise_len inside{[30:40]}; }

        // randomize and set up a new packet for transmission
        function void new_pkt;
            pkt_num++;
            if (!this.randomize()) begin
                $fatal(1, "mxframe: randomize failed!");
            end
            crc = 0;
            crc = update_crc(crc, dst);
            crc = update_crc(crc, src);
            crc = update_crc(crc, pkt_type);
            data = new[data_len];
            for (int i=0; i<data_len; i++) begin
                data[i] = $urandom;
                crc = update_crc(crc, data[i]);
            end
            if (err_type == CRC_ERROR) begin  // inject error - flip some bits
                crc = crc ^ ($urandom_range(255,1));
            end
            old_rerrcnt = 0;
        endfunction

        // method to encapsulate packet in a Manchester frame & transmit
        // just basic type 0 and 1 for now
        task send_pkt_mx;
            byte crc;
            send_preamble(2);
            send_sfd();
            send_byte(dst);
            send_byte(src);
            send_byte(pkt_type);
            for (int i=0; i < data.size()-1; i++) begin  // send all but the last byte
                send_byte(data[i]);
            end
            if (pkt_type inside {["1":"3"]}) send_byte(crc);
            send_eof(2);
            send_noise(noise_len);
        endtask: send_pkt_mx

        // receive and check a packet from a WimpFi rcvr
        task check_rcvr_pkt;
            logic [7:0] rdata;
            // check if packet is actually received or if an error is reported
            // dont we need some kind of timeout here, also?
            //for (int i=0; i<= data.size(); i++) begin

            //end

        endtask: check_rcvr_pkt

        function void print(input bit verbose);
            $display("===============================");
            $display("pkt_num=%2d", pkt_num);
            $display("dst=%2h(%s)", dst, dst);
            $display("src=%2h(%s)", src, src);
            $display("pkt_type=%2h(%s)", pkt_type, pkt_type);
            $display("err_type=%s", err_type.name());
            $display("data size=%0d",data.size());
            if (verbose) begin
                for(int i=0; i<data.size; i++) $display("  data[%0d]=%3d", i, data[i]);
            end
            if (pkt_type inside {[1:3]}) $display("crc=%2h", crc);
            $display("===============================");
        endfunction


    endclass: wf_pkt

    wf_pkt p;

    covergroup wf_pkt_cover;
        coverpoint p.pkt_type {
            bins type0 = {8'h30};
            bins type1 = {8'h31};
            bins type2 = {8'h32};
            bins type3 = {8'h33};
            illegal_bins bad_type = {[0:8'h2f], [8'h34:$]};
        }
        coverpoint p.data.size() {
            bins emptypkt = { 0 };
            bins single = { 1 };
            bins short = { [2:10]};
            bins med = { [11:100]};
            bins long = { [101:252]};
            illegal_bins bad_len = { [253:$]};  // error if occurs
        }
    endgroup

    parameter NUM_PACKETS = 5;

    initial begin
        wf_pkt_cover wv_cv;
        wv_cv = new;

        p = new();
        $timeformat(-9, 0, "ns", 6);
        do_reset;
        send_noise(3);
        for (int j=1; j<=NUM_PACKETS; j++) begin
            p.new_pkt();
            wv_cv.sample();
            p.print(0);
            p.send_pkt_mx();
            // add code to check received frame here
        end
        send_noise(10);
        report_errors();
        $stop;  // remove to enable functional coverage reporting
        $finish;
    end

endmodule
