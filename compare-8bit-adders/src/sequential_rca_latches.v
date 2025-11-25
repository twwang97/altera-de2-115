// sequential_rca_latches: latches inputs, instantiates RCA
module sequential_rca_latches
#( parameter integer WIDTH = 8 )
(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 start,
    input  wire [WIDTH-1:0]     a,
    input  wire [WIDTH-1:0]     b,
    input  wire                 cin,
    output reg  [WIDTH-1:0]     a_lat,
    output reg  [WIDTH-1:0]     b_lat,
    output reg                  cin_lat,
    output wire [WIDTH-1:0]     sum_w,
    output wire                 cout_w
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_lat <= {WIDTH{1'b0}};
            b_lat <= {WIDTH{1'b0}};
            cin_lat <= 1'b0;
        end else if (start) begin
            a_lat <= a;
            b_lat <= b;
            cin_lat <= cin;
        end
    end

    wire [WIDTH:0]   carry_w; // carry_w[0] = cin_lat, carry_w[WIDTH] = final cout
    assign carry_w[0] = cin_lat;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_fa
            // instantiate the same full_adder module used previously
            full_adder fa_inst (
                .a   (a_lat[i]),
                .b   (b_lat[i]),
                .cin (carry_w[i]),
                .sum (sum_w[i]),
                .cout(carry_w[i+1])
            );
        end
    endgenerate
    assign cout_w = carry_w[WIDTH];
endmodule
