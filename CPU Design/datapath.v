module datapath ();
    /* ---- DATA SIGNALS ---- */

    reg        RESET, CLK, EN;
    reg [31:0] PCNext, PC, PCPlus4, PCTarget;
    reg [31:0] Instr;
    reg [31:0] SrcA, WriteData, SrcB;
    reg [31:0] Result;
    reg [31:0] ImmExt;

    /* ---- CONTROL SIGNALS ---- */

    reg  [1:0] ImmSrc;
    reg        RegWrite, ALUSrc, PCSrc;

    /* ---- MODULES ---- */

    program_counter programCounter (.PC(PC), .RESET(RESET), .CLK(CLK), .EN(EN), .PCNext(PCNext));

    adder add4ToPC (.out(PCPlus4), .in1(PC), .in2(32'd4));

    instruction_memory memory (.ReadData(Instr), .RESET(RESET), .CLK(CLK), .Address(PC));

    register_file registers (
        .ReadData1(SrcA),
        .ReadData2(WriteData),
        .RESET(RESET),
        .CLK(CLK),
        .ReadRegister1(Instr[19:15]),
        .ReadRegister2(Instr[24:20]),
        .WriteEnable(RegWrite),
        .WriteRegister(Instr[11:7]),
        .WriteData(Result)
    );

    immediate_extend extend (.ImmExt(ImmExt), .Instr(Instr[31:7]), .ImmSrc(ImmSrc));

    src_b_mux srcBMux (.SrcB(SrcB), .ALUSrc(ALUSrc), .SrcB1(WriteData), .SrcB2(ImmExt));

    pc_next_mux PCNextMux (.PCNext(PCNext), .PCSrc(PCSrc), .PCNext1(PCPlus4), .PCNext2(PCTarget));

endmodule // datapath
