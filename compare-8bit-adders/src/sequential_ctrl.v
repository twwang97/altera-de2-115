// file: sequential_ctrl.v
// controller: FSM, done pulse, busy, cycle_count
module sequential_ctrl
#( parameter integer WIDTH = 8 )
(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 start,
    input  wire [WIDTH-1:0]     sum_w,
    input  wire                 cout_w,
    output reg  [WIDTH-1:0]     sum,
    output reg                  cout,
    output reg                  busy,
    output reg                  done,
    output reg  [31:0]          cycle_count
);
    localparam STATE_IDLE = 2'd0;
    localparam STATE_WAIT = 2'd1;
    localparam STATE_DONE = 2'd2;

    reg [1:0] state;
    reg prev_state_is_done;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= STATE_IDLE;
            prev_state_is_done <= 1'b0;
            busy <= 1'b0;
            sum <= {WIDTH{1'b0}};
            cout <= 1'b0;
            cycle_count <= 32'd0;
            done <= 1'b0;
        end else begin
            // default
            done <= 1'b0;

            case (state)
                STATE_IDLE: begin
                    busy <= 1'b0;
                    if (start) begin
                        cycle_count <= 32'd1;
                        busy <= 1'b1;
                        state <= STATE_WAIT;
                    end
                end

                STATE_WAIT: begin
                    sum <= sum_w;
                    cout <= cout_w;
                    cycle_count <= cycle_count + 1;
                    busy <= 1'b0;
                    state <= STATE_DONE;
                end

                STATE_DONE: begin
                    sum <= sum_w;
                    cout <= cout_w;
                    if (!prev_state_is_done) begin
                        done <= 1'b1; // register done here so it's visible same cycle
                    end
                    if (!start) state <= STATE_IDLE;
                end

                default: state <= STATE_IDLE;
            endcase

            prev_state_is_done <= (state == STATE_DONE);
        end
    end
endmodule
