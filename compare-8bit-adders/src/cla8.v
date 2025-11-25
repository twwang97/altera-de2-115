// file: cla8.v
`timescale 1ns/1ps
module cla8
#(
    parameter integer WIDTH = 8
)
(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             cin,
    output wire [WIDTH-1:0] sum,
    output wire             cout
);

    // internal signals
    // propagate p
    wire [WIDTH-1:0] p = a ^ b; // p[i] = 1 if bits will propagate carry
    // generate g
    wire [WIDTH-1:0] g = a & b; // g[i] = 1 if bit pair generates carry
    reg  [WIDTH:0]   c;         // carries
    reg  [WIDTH-1:0] sum_r;

    integer i, k, m;
    reg term;
    reg prod_p;
    reg prod_all_p;

    // combinational carry computation
    always @* begin
        c = { (WIDTH+1){1'b0} };
        c[0] = cin;
        for (i = 1; i <= WIDTH; i = i + 1) begin
            term = 1'b0;
            for (k = 0; k <= i-1; k = k + 1) begin
                prod_p = 1'b1;
                for (m = k+1; m <= i-1; m = m + 1)
                    prod_p = prod_p & p[m];
                term = term | (prod_p & g[k]);
            end
            prod_all_p = 1'b1;
            for (m = 0; m <= i-1; m = m + 1)
                prod_all_p = prod_all_p & p[m];
            term = term | (prod_all_p & c[0]);
            c[i] = term;
        end

        for (i = 0; i < WIDTH; i = i + 1)
            sum_r[i] = p[i] ^ c[i];
    end

    assign sum  = sum_r;
    assign cout = c[WIDTH];

endmodule
