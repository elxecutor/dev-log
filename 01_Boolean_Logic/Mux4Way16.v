/**
 * 16-bit multiplexor: 
 * for i = 0..15 out[i] = a[i] if sel == 0 
 *                        b[i] if sel == 1
 */

`default_nettype none
module Mux4Way16(
	input [15:0] a,
	input [15:0] b,
	input [15:0] c,
	input [15:0] d,
   	input [1:0] sel,
	output [15:0] out
);
	
	// Put your code here:
	assign out[0] = (sel == 2'b00) ? a[0] : (sel == 2'b01) ? b[0] : (sel == 2'b10) ? c[0] : d[0];
	assign out[1] = (sel == 2'b00) ? a[1] : (sel == 2'b01) ? b[1] : (sel == 2'b10) ? c[1] : d[1];
	assign out[2] = (sel == 2'b00) ? a[2] : (sel == 2'b01) ? b[2] : (sel == 2'b10) ? c[2] : d[2];
	assign out[3] = (sel == 2'b00) ? a[3] : (sel == 2'b01) ? b[3] : (sel == 2'b10) ? c[3] : d[3];
	assign out[4] = (sel == 2'b00) ? a[4] : (sel == 2'b01) ? b[4] : (sel == 2'b10) ? c[4] : d[4];
	assign out[5] = (sel == 2'b00) ? a[5] : (sel == 2'b01) ? b[5] : (sel == 2'b10) ? c[5] : d[5];
	assign out[6] = (sel == 2'b00) ? a[6] : (sel == 2'b01) ? b[6] : (sel == 2'b10) ? c[6] : d[6];
	assign out[7] = (sel == 2'b00) ? a[7] : (sel == 2'b01) ? b[7] : (sel == 2'b10) ? c[7] : d[7];
	assign out[8] = (sel == 2'b00) ? a[8] : (sel == 2'b01) ? b[8] : (sel == 2'b10) ? c[8] : d[8];
	assign out[9] = (sel == 2'b00) ? a[9] : (sel == 2'b01) ? b[9] : (sel == 2'b10) ? c[9] : d[9];
	assign out[10] = (sel == 2'b00) ? a[10] : (sel == 2'b01) ? b[10] : (sel == 2'b10) ? c[10] : d[10];
	assign out[11] = (sel == 2'b00) ? a[11] : (sel == 2'b01) ? b[11] : (sel == 2'b10) ? c[11] : d[11];
	assign out[12] = (sel == 2'b00) ? a[12] : (sel == 2'b01) ? b[12] : (sel == 2'b10) ? c[12] : d[12];
	assign out[13] = (sel == 2'b00) ? a[13] : (sel == 2'b01) ? b[13] : (sel == 2'b10) ? c[13] : d[13];
	assign out[14] = (sel == 2'b00) ? a[14] : (sel == 2'b01) ? b[14] : (sel == 2'b10) ? c[14] : d[14];
	assign out[15] = (sel == 2'b00) ? a[15] : (sel == 2'b01) ? b[15] : (sel == 2'b10) ? c[15] : d[15];

endmodule
