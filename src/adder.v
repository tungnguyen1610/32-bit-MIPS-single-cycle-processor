module adder (
    input [31:0] a,b, 
    output [31:0] out
);
assign out= a+b ;// add two 32-bit numbers;
//assign overflow = (~a[31] & ~b[31] & out[31]) | (a[31] & b[31] & ~out[31]); (sign of inputs are different from output)
endmodule
