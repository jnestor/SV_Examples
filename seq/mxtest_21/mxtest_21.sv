//-----------------------------------------------------------------------------
// Module Name   : mxtest_21 - test module for Manchester Tranmsmitter
// Project       : ECE 416 Advanced Digital Design & Verification
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : March 1 2021
//-----------------------------------------------------------------------------
// Description   : Feeds a frame of bytes of a specified length
// to a manchester transmitter.  The frame is retransmitted after
// a pause specified by parameter DELAY_MS as long as send is asserted.
// The contents of the frame can be changed by changing the initializer
// for the buffer array
//-----------------------------------------------------------------------------

module mxtest_21(
    input logic clk, rst, send, rdy,
    input logic [5:0] frame_len,
    output logic [7:0] data,
    output logic valid
    );

    parameter DELAY_MS = 1;  // delay between frames
    
    logic start_pause, end_pause;

    period_enb #(.PERIOD_MS(DELAY_MS)) U_WAIT (
        .clk, .rst, .clr(start_pause), .enb_out(end_pause)
    );

    localparam BUFLEN = 32;
    localparam BUFW = $clog2(BUFLEN);

    // Address counter
    logic [5:0] count, count_next;

    // Message buffer - characters in frame to be sent
    logic [0:BUFLEN-1][7:0] buffer  = {
        "Y","o","u","r"," ","m","e","s","s","a","g","e"," ","h","e","r",
        "e","@","@","@","@","@","@","@","@","@","@","@","@","E","N","D"
     };

    assign data = buffer[count];

    typedef enum logic [1:0] {WTSND, WTRDY, NEXTCH, PAUSE} states_t;

    states_t state, next;

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= WTSND;
            count <= 0;
        end
        else begin
            state <= next;
            count <= count_next;
        end
    end

    always_comb begin
        next = state;  // stay in current state as default
        valid = 0;
        start_pause = 0;
        count_next = count;
        case (state)
            WTSND : begin
                count_next = 0;
                if (send) next = WTRDY;
                else next = WTSND;
            end
            WTRDY : begin
                valid = 1;
                if (!rdy) next = WTRDY;
                else begin
                    count_next = count + 1;
                    next = NEXTCH;
                end
            end
            NEXTCH: begin
                if (count != frame_len) next = WTRDY;
                else if (!rdy) next = NEXTCH;
                else begin
                    start_pause = 1;
                    next = PAUSE;
                end
            end
            PAUSE: begin
                if (end_pause) next = WTSND;
                else next = PAUSE;
            end
        endcase
    end
endmodule: mxtest_21
