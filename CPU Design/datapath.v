module datapath ();
    /* ---- DATA SIGNALS ---- */

    reg        RESET, CLK, EN;
    reg [31:0] PCNext, PC, PCPlus4, PCTarget;
    reg [31:0] Instr;
    reg [31:0] SrcA, WriteData, SrcB;
    reg [31:0] ALUResult, ReadData, Result;
    reg [31:0] ImmExt;
    reg        Zero;

    /* ---- CONTROL SIGNALS ---- */

    reg  [1:0] ImmSrc;
    reg        RegWrite, ALUSrc, PCSrc, MemWrite, ResultSrc;
    reg  [2:0] ALUControl;

    /* ---- MODULES ---- */

    program_counter programCounter (.PC(PC), .RESET(RESET), .CLK(CLK), .EN(EN), .PCNext(PCNext));

    adder add4ToPC (.out(PCPlus4),  .in1(PC), .in2(32'd4));
    adder PCTarget (.out(PCTarget), .in1(PC), .in2(ImmExt));

    instruction_memory instr_memory (.ReadData(Instr), .RESET(RESET), .CLK(CLK), .Address(PC));

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

    two_to_one_mux srcBMux   (.out(SrcB),   .selectBit(ALUSrc),    .in1(WriteData), .in2(ImmExt));
    two_to_one_mux PCNextMux (.out(PCNext), .selectBit(PCSrc),     .in1(PCPlus4),   .in2(PCTarget));
    two_to_one_mux resultMux (.out(Result), .selectBit(ResultSrc), .in1(ALUResult), .in2(ReadData));

    alu ALU (.ALUResult(ALUResult), .Zero(Zero), .ALUControl(ALUControl), .SrcA(SrcA), .SrcB(SrcB));

    data_memory data_memory (
        .ReadData(ReadData),
        .RESET(RESET),
        .CLK(CLK),
        .WriteEnable(MemWrite),
        .Address(ALUResult),
        .WriteData(WriteData)
    );

endmodule // datapath
