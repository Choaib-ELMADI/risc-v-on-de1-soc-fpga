module datapath (OP, funct3, funct7, Zero, RESET, CLK, EN, PCSrc, ResultSrc, ALUSrc, ImmSrc, MemWrite, RegWrite, ALUControl);
    /* ---- PORTS ---- */

    output wire   [6:0] OP;
    output wire [14:12] funct3;
    output wire         funct7;
    output              Zero;
    input               RESET, CLK, EN;
    input               PCSrc, ResultSrc, ALUSrc;
    input         [1:0] ImmSrc;
    input               MemWrite, RegWrite;
    input         [2:0] ALUControl;

    /* ---- DATA SIGNALS ---- */

    reg          [31:0] PCNext, PC, PCPlus4, PCTarget;
    reg          [31:0] Instr;
    reg          [31:0] SrcA, WriteData, SrcB;
    reg          [31:0] ALUResult, ReadData, Result;
    reg          [31:0] ImmExt;

    /* ---- PARAMETERS ---- */

    parameter           INSTRUCTION_MEMORY_SIZE = 64;
    parameter           DATA_MEMORY_SIZE        = 128;

    /* ---- MODULES ---- */

    program_counter programCounter (.PC(PC), .RESET(RESET), .CLK(CLK), .EN(EN), .PCNext(PCNext));

    adder add4ToPC (.out(PCPlus4),  .in1(PC), .in2(32'd4));
    adder PCTarget (.out(PCTarget), .in1(PC), .in2(ImmExt));

    instruction_memory #(.MEMORY_SIZE(INSTRUCTION_MEMORY_SIZE)) instr_memory
        (
            .ReadData(Instr),
            .RESET(RESET),
            .CLK(CLK),
            .Address(PC)
        );

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

    data_memory #(.MEMORY_SIZE(DATA_MEMORY_SIZE)) data_memory
        (
            .ReadData(ReadData),
            .RESET(RESET),
            .CLK(CLK),
            .WriteEnable(MemWrite),
            .Address(ALUResult),
            .WriteData(WriteData)
        );

    /* ---- ASSIGNMENTS ---- */

    assign OP     = Instr[6:0];
    assign funct3 = Instr[14:12];
    assign funct7 = Instr[30];

endmodule // datapath
