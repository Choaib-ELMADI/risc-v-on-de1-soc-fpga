module immediate_extend (ImmExt, Instr, ImmSrc);
    output reg [31:0] ImmExt;
    input      [31:7] Instr;
    input       [1:0] ImmSrc;

    always @(*)
        begin
            case (ImmSrc)
                // I-type
                2'b00   : ImmExt <= {{20 {Instr[31]}}, Instr[31:20]};
                // S-type
                2'b01   : ImmExt <= {{20 {Instr[31]}}, Instr[31:25], Instr[11:7]};
                // B-type
                2'b10   : ImmExt <= {{20 {Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
                // J-type
                2'b11   : ImmExt <= {{12 {Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
                // others
                default : ImmExt <= 32'bx;
            endcase
        end

endmodule // immediate_extend
