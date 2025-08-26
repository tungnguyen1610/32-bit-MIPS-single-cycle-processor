module signext (input [15:0] in,
                output [31:0] out
);
assign out= {{16{in[15]}}, in}; // sign-extend the 16-bit input to 32 bits
endmodule

