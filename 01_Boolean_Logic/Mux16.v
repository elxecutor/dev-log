/**
 * 16-bit multiplexor: 
 * for i = 0..15 out[i] = a[i] if sel == 0 
 *                        b[i] if sel == 1
 */

`default_nettype none
module Mux16(
	input [15:0] a,
	input [15:0] b,
   	input sel,
	output [15:0] out
);

	// Put your code here:
	assign out[0] = (sel) ? b[0] : a[0];
	assign out[1] = (sel) ? b[1] : a[1];
	assign out[2] = (sel) ? b[2] : a[2];
	assign out[3] = (sel) ? b[3] : a[3];
	assign out[4] = (sel) ? b[4] : a[4];
	assign out[5] = (sel) ? b[5] : a[5];
	assign out[6] = (sel) ? b[6] : a[6];
	assign out[7] = (sel) ? b[7] : a[7];
	assign out[8] = (sel) ? b[8] : a[8];
	assign out[9] = (sel) ? b[9] : a[9];
	assign out[10] = (sel) ? b[10] : a[10];
	assign out[11] = (sel) ? b[11] : a[11];
	assign out[12] = (sel) ? b[12] : a[12];
	assign out[13] = (sel) ? b[13] : a[13];
	assign out[14] = (sel) ? b[14] : a[14];
	assign out[15] = (sel) ? b[15] : a[15];

endmodule
