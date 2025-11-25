// top wrapper: connects latch inputs and controller
module sequential_trigger_cla8
#( parameter integer WIDTH = 8 )
(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 start,
    input  wire [WIDTH-1:0]     a,
    input  wire [WIDTH-1:0]     b,
    input  wire                 cin,
    output wire [WIDTH-1:0]     sum,
    output wire                 cout,
    output wire                 busy,
    output wire                 done,
    output wire [31:0]          cycle_count
);
    wire [WIDTH-1:0] sum_w;
    wire cout_w;
    wire [WIDTH-1:0] a_lat, b_lat;
    wire cin_lat;

    sequential_cla_latches #(.WIDTH(WIDTH)) dp (
        .clk(clk), .rst_n(rst_n), .start(start),
        .a(a), .b(b), .cin(cin),
        .a_lat(a_lat), .b_lat(b_lat), .cin_lat(cin_lat),
        .sum_w(sum_w), .cout_w(cout_w)
    );

    sequential_ctrl #(.WIDTH(WIDTH)) ctrl (
        .clk(clk), .rst_n(rst_n), .start(start),
        .sum_w(sum_w), .cout_w(cout_w),
        .sum(sum), .cout(cout), .busy(busy), .done(done),
        .cycle_count(cycle_count)
    );
endmodule
