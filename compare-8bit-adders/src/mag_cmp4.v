// 4-bit unsigned magnitude comparator
// Module: mag_cmp4
// Inputs:  A[3:0], B[3:0]  (unsigned)
// Outputs: A_gt_B, A_lt_B, A_eq_B
// Combinational: outputs indicate A > B, A < B, A == B (unsigned)

module mag_cmp4 (
    input  [3:0] A,
    input  [3:0] B,
    output       A_gt_B,
    output       A_lt_B,
    output       A_eq_B
);

    // Per-bit equality: eq[i] == 1 when A[i] equals B[i]
    wire [3:0] eq;
    assign eq = ~(A ^ B);

    // A_eq_B is true when all per-bit equalities are true
    assign A_eq_B = &eq; // reduction AND

    // Propagate signals: prefix AND of higher significant eq bits
    // prop[i] == 1 means all bits more significant than i are equal
    wire prop3 = 1'b1;                    // no higher bits above MSB
    wire prop2 = eq[3];
    wire prop1 = eq[3] & eq[2];
    wire prop0 = eq[3] & eq[2] & eq[1];

    // Generate signals: g[i] is true if bit i determines A > B
    wire g3 = A[3] & ~B[3];
    wire g2 = A[2] & ~B[2] & prop2;
    wire g1 = A[1] & ~B[1] & prop1;
    wire g0 = A[0] & ~B[0] & prop0;
    assign A_gt_B = g3 | g2 | g1 | g0;

    // Similarly for A < B (l[i] true if bit i determines A < B)
    wire l3 = ~A[3] & B[3];
    wire l2 = ~A[2] & B[2] & prop2;
    wire l1 = ~A[1] & B[1] & prop1;
    wire l0 = ~A[0] & B[0] & prop0;
    assign A_lt_B = l3 | l2 | l1 | l0;

endmodule