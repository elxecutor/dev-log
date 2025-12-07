/**
 * 8-way Or: 
 * out = (in[0] or in[1] or ... or in[7])
 */

`default_nettype none
module Or8Way(
	input [7:0] in,
	output out
);

	// Put your code here:
	assign out = in[0] | in[1] | in[2] | in[3] | in[4] | in[5] | in[6] | in[7];

endmodule
