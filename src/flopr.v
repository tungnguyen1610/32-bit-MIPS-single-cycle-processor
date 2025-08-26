module flopr # (parameter WIDTH=8)
(
    input clk, reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end
    else begin 
        q<= d;
    end
end
endmodule