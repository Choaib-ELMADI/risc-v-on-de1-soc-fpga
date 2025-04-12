module immediate_extend (ImmExt, Instr, ImmSrc);
    output reg [31:0] ImmExt;
    input      [31:7] Instr;
    input       [2:0] ImmSrc;

    always @(*)
        begin
            case (ImmSrc)
                // I-type
                2'b000   : ImmExt <= {{20 {Instr[31]}}, Instr[31:20]};
                // S-type
                2'b001   : ImmExt <= {{20 {Instr[31]}}, Instr[31:25], Instr[11:7]};
                // B-type
                2'b010   : ImmExt <= {{20 {Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
                // J-type
                2'b011   : ImmExt <= {{12 {Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
                // J-type
                2'b100   : ImmExt <= {instr[31:12], 12'b0};
                // others
                default : ImmExt <= 32'bx;
            endcase
        end

endmodule // immediate_extend
