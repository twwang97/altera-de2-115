<p align="center">
<h1 align="center">
4-bit counter using J-K flip-flops
</h1>
<h3 align="center">
<a href="https://github.com/twwang97/altera-de2-115/tree/nycu2025/4bit-counter-jkff/ltspice"><strong> LTspice </strong></a>
|
<a href="https://github.com/twwang97/altera-de2-115/tree/nycu2025/4bit-counter-jkff/quartus"><strong> Quartus </strong></a>
|
<a href="https://github.com/twwang97/altera-de2-115/tree/nycu2025/4bit-counter-jkff/vivado"><strong> Vivado </strong></a>
|
<a href="https://youtu.be/lHUYbL7JJKo"><strong> Video </strong></a>
|
<a href="./report.pdf"><strong> Report </strong></a>
</h3>

</p>

* Program: Electronics and AI Training Program (3rd Session in 2025)
* Semester: Fall 2025
* Title: 4-bit Counter using J-K Flip-Flops
* Keywords: J-K Flip-Flops, R-2R DAC, Switch Debouncing, LTspice, ModelSim.
* Student: Tsung-Wun (David) Wang
* Instructors: Sun-Ting Lin, Ross Chen
* National Yang Ming Chiao Tung University

<!-- experiment Altera DE2 video (published shorter video): https://youtu.be/KPDtDhJqPgE -->
<!-- experiment Altera DE2 video (hidden but complete video): https://youtu.be/XKo9285kK94 -->
<!-- experiment Basys 3 video (published video): https://youtu.be/lHUYbL7JJKo -->

---

#### Objectives

* To distinguish multiple flip-flops from different latches.
* To simulate a 4-bit counter in LTspice with an R-2R digital-to-analog converter (DAC) considered.
* To write a VHDL program and run its testbench in ModelSim.
* To implement debounce to avoid switch bounce on the real FPGA board.
* To program the board (e.g., `DE2-115` and `Basys 3`) and compare the experimental results with simulation signals.

---

#### Tools

* LTspice Version: `24.1.10` for Windows.
* Vivado Version: `2025.2`.
* Quartus Prime Version: `24.1std.0 Lite Edition`.
* XSim (Vivado Simulator) Version: Same as Vivado.
* ModelSim Version: `Starter 2020.1`.
* Altera DE2-115: [User Manual](https://www.terasic.com.tw/attachment/archive/502/DE2_115_User_manual.pdf).
* Digilent Basys 3:  [Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual) | [PDF](https://digilent.com/reference/_media/basys3:%20basys3_rm.pdf) | [JTAG-HS2](https://digilent.com/reference/_media/jtag_hs2:jtag-hs2_rm.pdf) | [Schematic](https://digilent.com/reference/_media/reference/programmable-logic/basys-3/basys-3_sch.pdf) | [Pinouts](https://www.nhn.ou.edu/~bumm/ELAB/Labs/Basys3_FGPA_pin_outs.pdf) | [XDC](https://digilent.com/reference/_media/basys3/basys3_master.zip)
