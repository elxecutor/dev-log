/**
 * 16-bit bitwise And:
 * for i = 0..15: assign out[i] = (a[i] and b[i])
 */

`default_nettype none
module And16(
	input [15:0] a,
	input [15:0] b,
	output [15:0] out
);

	// Put your code here:
	assign out[0] = a[0] & b[0];
	assign out[1] = a[1] & b[1];
	assign out[2] = a[2] & b[2];
	assign out[3] = a[3] & b[3];
	assign out[4] = a[4] & b[4];
	assign out[5] = a[5] & b[5];
	assign out[6] = a[6] & b[6];
	assign out[7] = a[7] & b[7];
	assign out[8] = a[8] & b[8];
	assign out[9] = a[9] & b[9];
	assign out[10] = a[10] & b[10];
	assign out[11] = a[11] & b[11];
	assign out[12] = a[12] & b[12];
	assign out[13] = a[13] & b[13];
	assign out[14] = a[14] & b[14];
	assign out[15] = a[15] & b[15];

endmodule
