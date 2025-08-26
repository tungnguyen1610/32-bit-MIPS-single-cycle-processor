module regfile (input clk,
                input we3,  
input [4:0] ra1, ra2, wa3,
input [31:0] wd3,
output [31:0] rd1, rd2
);
reg [31:0] rf[31:0]; // 32 registers of 32 bits each
// three read ports and one write port
// read ports are combinational
// write third port on rising edge of clock
always @(posedge clk) begin
    if (we3) begin
        rf[wa3] <= wd3;
    end
end
assign rd1= (ra1 !=0) ? rf[ra1] : 32'b0; // if ra1 is not zero, read from rf[ra1], else return 0
assign rd2= (ra2 !=0) ? rf[ra2] : 32'b0; // if ra2 is not zero, read from rf[ra2], else return
endmodule
