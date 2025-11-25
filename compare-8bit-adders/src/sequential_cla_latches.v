// sequential_cla_latches: latches inputs, instantiates CLA
module sequential_cla_latches
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

    cla8 #(.WIDTH(WIDTH)) u_cla (
        .a(a_lat), .b(b_lat), .cin(cin_lat),
        .sum(sum_w), .cout(cout_w)
    );
endmodule
