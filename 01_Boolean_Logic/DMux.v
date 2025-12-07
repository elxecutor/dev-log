/**
 * Demultiplexor:
 * {a, b} = {in, 0} if sel == 0
 *          {0, in} if sel == 1
 */

`default_nettype none
module DMux(
	input in,
	input sel,
    output a,
	output b
);

	// Put your code here:
	assign a = (sel) ? 1'b0 : in;
	assign b = (sel) ? in : 1'b0;

endmodule
