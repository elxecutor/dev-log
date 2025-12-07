/**
 * 16-bit multiplexor: 
 * for i = 0..15 out[i] = a[i] if sel == 0 
 *                        b[i] if sel == 1
 */

`default_nettype none
module Mux8Way16(
	input [15:0] a,
	input [15:0] b,
	input [15:0] c,
	input [15:0] d,
	input [15:0] e,
	input [15:0] f,
	input [15:0] g,
	input [15:0] h,
   	input [2:0] sel,
	output [15:0] out
);

	// Put your code here:
	assign out[0] = (sel == 3'b000) ? a[0] : (sel == 3'b001) ? b[0] : (sel == 3'b010) ? c[0] : (sel == 3'b011) ? d[0] : (sel == 3'b100) ? e[0] : (sel == 3'b101) ? f[0] : (sel == 3'b110) ? g[0] : h[0];
	assign out[1] = (sel == 3'b000) ? a[1] : (sel == 3'b001) ? b[1] : (sel == 3'b010) ? c[1] : (sel == 3'b011) ? d[1] : (sel == 3'b100) ? e[1] : (sel == 3'b101) ? f[1] : (sel == 3'b110) ? g[1] : h[1];
	assign out[2] = (sel == 3'b000) ? a[2] : (sel == 3'b001) ? b[2] : (sel == 3'b010) ? c[2] : (sel == 3'b011) ? d[2] : (sel == 3'b100) ? e[2] : (sel == 3'b101) ? f[2] : (sel == 3'b110) ? g[2] : h[2];
	assign out[3] = (sel == 3'b000) ? a[3] : (sel == 3'b001) ? b[3] : (sel == 3'b010) ? c[3] : (sel == 3'b011) ? d[3] : (sel == 3'b100) ? e[3] : (sel == 3'b101) ? f[3] : (sel == 3'b110) ? g[3] : h[3];
	assign out[4] = (sel == 3'b000) ? a[4] : (sel == 3'b001) ? b[4] : (sel == 3'b010) ? c[4] : (sel == 3'b011) ? d[4] : (sel == 3'b100) ? e[4] : (sel == 3'b101) ? f[4] : (sel == 3'b110) ? g[4] : h[4];
	assign out[5] = (sel == 3'b000) ? a[5] : (sel == 3'b001) ? b[5] : (sel == 3'b010) ? c[5] : (sel == 3'b011) ? d[5] : (sel == 3'b100) ? e[5] : (sel == 3'b101) ? f[5] : (sel == 3'b110) ? g[5] : h[5];
	assign out[6] = (sel == 3'b000) ? a[6] : (sel == 3'b001) ? b[6] : (sel == 3'b010) ? c[6] : (sel == 3'b011) ? d[6] : (sel == 3'b100) ? e[6] : (sel == 3'b101) ? f[6] : (sel == 3'b110) ? g[6] : h[6];
	assign out[7] = (sel == 3'b000) ? a[7] : (sel == 3'b001) ? b[7] : (sel == 3'b010) ? c[7] : (sel == 3'b011) ? d[7] : (sel == 3'b100) ? e[7] : (sel == 3'b101) ? f[7] : (sel == 3'b110) ? g[7] : h[7];
	assign out[8] = (sel == 3'b000) ? a[8] : (sel == 3'b001) ? b[8] : (sel == 3'b010) ? c[8] : (sel == 3'b011) ? d[8] : (sel == 3'b100) ? e[8] : (sel == 3'b101) ? f[8] : (sel == 3'b110) ? g[8] : h[8];
	assign out[9] = (sel == 3'b000) ? a[9] : (sel == 3'b001) ? b[9] : (sel == 3'b010) ? c[9] : (sel == 3'b011) ? d[9] : (sel == 3'b100) ? e[9] : (sel == 3'b101) ? f[9] : (sel == 3'b110) ? g[9] : h[9];
	assign out[10] = (sel == 3'b000) ? a[10] : (sel == 3'b001) ? b[10] : (sel == 3'b010) ? c[10] : (sel == 3'b011) ? d[10] : (sel == 3'b100) ? e[10] : (sel == 3'b101) ? f[10] : (sel == 3'b110) ? g[10] : h[10];
	assign out[11] = (sel == 3'b000) ? a[11] : (sel == 3'b001) ? b[11] : (sel == 3'b010) ? c[11] : (sel == 3'b011) ? d[11] : (sel == 3'b100) ? e[11] : (sel == 3'b101) ? f[11] : (sel == 3'b110) ? g[11] : h[11];
	assign out[12] = (sel == 3'b000) ? a[12] : (sel == 3'b001) ? b[12] : (sel == 3'b010) ? c[12] : (sel == 3'b011) ? d[12] : (sel == 3'b100) ? e[12] : (sel == 3'b101) ? f[12] : (sel == 3'b110) ? g[12] : h[12];
	assign out[13] = (sel == 3'b000) ? a[13] : (sel == 3'b001) ? b[13] : (sel == 3'b010) ? c[13] : (sel == 3'b011) ? d[13] : (sel == 3'b100) ? e[13] : (sel == 3'b101) ? f[13] : (sel == 3'b110) ? g[13] : h[13];
	assign out[14] = (sel == 3'b000) ? a[14] : (sel == 3'b001) ? b[14] : (sel == 3'b010) ? c[14] : (sel == 3'b011) ? d[14] : (sel == 3'b100) ? e[14] : (sel == 3'b101) ? f[14] : (sel == 3'b110) ? g[14] : h[14];
	assign out[15] = (sel == 3'b000) ? a[15] : (sel == 3'b001) ? b[15] : (sel == 3'b010) ? c[15] : (sel == 3'b011) ? d[15] : (sel == 3'b100) ? e[15] : (sel == 3'b101) ? f[15] : (sel == 3'b110) ? g[15] : h[15];

endmodule
