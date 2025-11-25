// Top-level 8-bit unsigned magnitude comparator using two mag_cmp4 instances
// Module: mag_cmp8
// Inputs:  A[7:0], B[7:0]  (unsigned)
// Outputs: A_gt_B, A_lt_B, A_eq_B

module mag_cmp8 (
    input  [7:0] A,
    input  [7:0] B,
    output       A_gt_B,
    output       A_lt_B,
    output       A_eq_B
);

    // wires for the two 4-bit comparators
    wire hi_gt, hi_lt, hi_eq;
    wire lo_gt, lo_lt, lo_eq;

    // instantiate comparator for high nibble A[7:4] vs B[7:4]
    mag_cmp4 cmp_hi (
        .A      (A[7:4]),
        .B      (B[7:4]),
        .A_gt_B (hi_gt),
        .A_lt_B (hi_lt),
        .A_eq_B (hi_eq)
    );

    // instantiate comparator for low nibble A[3:0] vs B[3:0]
    mag_cmp4 cmp_lo (
        .A      (A[3:0]),
        .B      (B[3:0]),
        .A_gt_B (lo_gt),
        .A_lt_B (lo_lt),
        .A_eq_B (lo_eq)
    );

    // final outputs:
    // - If high nibbles differ, they determine the result.
    // - If high nibbles equal, low nibble result is used.
    assign A_gt_B = hi_gt | (hi_eq & lo_gt);
    assign A_lt_B = hi_lt | (hi_eq & lo_lt);
    assign A_eq_B = hi_eq & lo_eq;

endmodule

