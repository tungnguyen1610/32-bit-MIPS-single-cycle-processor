module alu (
    input [31:0] srca,srcb, 
    input [2:0] alucontrol,
    output reg [31:0] aluout,
    output zero
);

always @(* ) begin
    case (alucontrol)
        3'b000: aluout <= srca & srcb; // AND
        3'b001: aluout <= srca | srcb; // OR
        3'b010: aluout <= srca + srcb; // ADD
        3'b101: aluout <= srca & (~srcb); // 
        3'b110: aluout <= srca + ~srcb + 1 ; // SUBSTRACT
        3'b111: aluout <= ($signed(srca) < $signed(srcb)) ? 32'd1 : 32'd0; // SLT
        default: aluout <= 32'b0; // Default case
    endcase
end
assign zero = (aluout == 32'b0); // Set zero flag if output is zero
endmodule;

        