//-----------------------------------------------------------------------------
// File    : dual_detector_top.v
// Project : detection_examples
// Author  : twwang97
// Date    : 2025-11-22
// Version : 1.0
//-----------------------------------------------------------------------------
// Description:
//   Top-level wrapper that instantiates two sequence detectors:
//     - mealy_detect_01 : Mealy FSM
//     - moore_detect_01 : Moore FSM
//   The wrapper forwards clock, reset and serial data input to both detectors
//   and exposes each detector's detect output.
//
// Dependencies:
//   - mealy_detect_01.v
//   - moore_detect_01.v
//
// Usage:
//   Instantiate this wrapper in a higher-level module or testbench. Rename the
//   module if you need a more descriptive name for your system hierarchy.
//
// Notes:
//   - Active-low reset is rst_n.
//   - Consider adding parameters for data width or number of detectors.
//-----------------------------------------------------------------------------

module dual_detector_top (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire detect_mealy,
    output wire detect_moore
);

    mealy_detect_01 u_mealy_det (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .detect(detect_mealy)
    );

    moore_detect_01 u_moore_det (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .detect(detect_moore)
    );

endmodule
