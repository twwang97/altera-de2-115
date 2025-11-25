// Filename    : mealy_detect_01.v
// Author      : twwang97
// Date        : 2025-11-22
// Description : Mealy FSM that detects a 0 -> 1 bit sequence on data_in.
//               When a 0 is followed by a 1, `detect` is asserted for one clock.
// Notes       : Combinational next-state and output logic are separated from sequential
//               state register to improve readability and testability.

module mealy_detect_01 (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  detect  // Mealy: depends on state and input
);

    // State type and symbolic names
    typedef enum logic [1:0] { S0 = 2'b00, S1 = 2'b01 } state_t;
    state_t state;       // current state
    state_t next_state;  // next state computed combinationally

    // Combinational signal for the Mealy output; will be registered to `detect`
    logic detect_next;

    // ---------------------------------------------------------------------
    // Combinational block: next-state and Mealy output logic
    // - Defaults assigned to avoid latches
    // - Contains only combinational expressions (no clock edge)
    // ---------------------------------------------------------------------
    always @* begin
        // Default values
        next_state  = state;
        detect_next = 1'b0;

        case (state)
            S0: begin
                // S0: idle/waiting for a 0 to start the 0->1 detection
                if (data_in == 1'b0) begin
                    next_state = S1; // saw 0 -> transition to S1 to wait for 1
                end else begin
                    next_state = S0; // stay in S0 if input is 1
                end
            end

            S1: begin
                // S1: previously saw a 0; a 1 now produces a detection pulse
                if (data_in == 1'b1) begin
                    detect_next = 1'b1; // Mealy immediate output (one-cycle pulse)
                    next_state  = S0;   // go back to S0 after detection
                end else begin
                    next_state  = S1;   // remain in S1 while zeros persist
                end
            end

            default: begin
                // Safe recovery for X/unknown states during simulation
                next_state  = S0;
                detect_next = 1'b0;
            end
        endcase
    end

    // ---------------------------------------------------------------------
    // Sequential block: state register and registered output
    // - Asynchronous active-low reset (matches original style)
    // - Registers both state and output to meet original `output reg` port
    // ---------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state  <= S0;       // reset to idle state
            detect <= 1'b0;     // clear output on reset
        end else begin
            state  <= next_state;
            detect <= detect_next;
        end
    end

endmodule