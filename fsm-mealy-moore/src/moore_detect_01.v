// Filename    : moore_detect_01.v
// Author      : twwang97
// Date        : 2025-11-22
// Description : Moore FSM to detect sequence 0 -> 1 on data_in.
//               detect is asserted in state M_DET for one clock.
// Notes       : Overlapping detections allowed: after M_DET the next state
//               is chosen based on current data_in.

module moore_detect_01 (
    input  wire clk,     // clock, active on rising edge
    input  wire rst_n,   // asynchronous active-low reset
    input  wire data_in, // serial input stream to be monitored
    output reg  detect   // Moore output: asserted based only on current state
);

    // State type and encoding
    typedef enum logic [1:0] {
        M0      = 2'b00, // idle/expecting 0
        M1      = 2'b01, // saw 0, now expecting 1
        M_DET   = 2'b10  // detection state: assert detect = 1
    } mstate_t;

    // Current and next state signals
    mstate_t mstate;
    mstate_t next_state;
	 
    // combinational next-state and output
    logic detect_combinational;
    always @(*) begin
        next_state = mstate;
        detect_combinational = 1'b0;
        case (mstate)
            M0:    next_state = (data_in==1'b0) ? M1 : M0;
            M1:    next_state = (data_in==1'b1) ? M_DET : M1;
            M_DET: next_state = (data_in==1'b0) ? M1 : M0;
            default: next_state = M0;
        endcase
        detect_combinational = (mstate == M_DET);
    end

    // registered state and output
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mstate <= M0;
            detect  <= 1'b0;
        end else begin
            mstate <= next_state;
            detect  <= detect_combinational; // keeps detect synchronous
        end
    end
endmodule