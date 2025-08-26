module mux2 #
    (parameter WIDTH=8)
    (input [WIDTH-1:0] a, b,
    input sel,
    output [WIDTH-1:0] out  
);
assign out = sel ? b : a;
endmodule