module datapath (OP, funct3, funct7, Zero, RESET, CLK, ALUSrcA, ALUSrcB, ImmSrc, ResultSrc, ALUControl, AdrSrc, PCWrite, MemWrite, RegWrite, IRWrite);
    /* ---- PORTS ---- */

    output wire   [6:0] OP;
    output wire [14:12] funct3;
    output wire         funct7;
    output              Zero;
    input               RESET, CLK;
    input         [1:0] ALUSrcA, ALUSrcB, ImmSrc, ResultSrc;
    input         [2:0] ALUControl;
    input               AdrSrc;
    input               PCWrite, MemWrite, RegWrite, IRWrite;

    /* ---- DATA SIGNALS ---- */

    reg          [31:0] PC, PCNext, OldPC;
    reg          [31:0] Address, Instr;
    reg          [31:0] SrcA, SrcB, A;
    reg          [31:0] RD1, RD2, WriteData;
    reg          [31:0] ALUResult, Result, ALUOut;
    reg          [31:0] ImmExt;
    reg          [31:0] ReadData, Data;

    /* ---- PARAMETERS ---- */

    parameter           MEMORY_SIZE = 128;

    /* ---- MODULES ---- */

    d_flip_flop_with_enable PCFlipFlop (.out(PC), .CLK(CLK), .EN(PCWrite), .in(PCNext));

    two_to_one_mux addressMux (.out(Address), .selectBit(AdrSrc), .in1(PC), .in2(Result));

    instruction_and_data_memory #(.MEMORY_SIZE(MEMORY_SIZE)) memory
        (
            .ReadData(ReadData),
            .RESET(RESET),
            .CLK(CLK),
            .WriteEnable(MemWrite),
            .Address(Address),
            .WriteData(WriteData)
        );

    d_flip_flop             oldPCFlipFlop (.out(OldPC), .CLK(CLK),               .in(PC));
    d_flip_flop_with_enable instrFlipFlop (.out(Instr), .CLK(CLK), .EN(IRWrite), .in(ReadData));
    d_flip_flop             dataFlipFlop  (.out(Data),  .CLK(CLK),               .in(ReadData));

    register_file registers (
        .ReadData1(RD1),
        .ReadData2(RD2),
        .RESET(RESET),
        .CLK(CLK),
        .ReadRegister1(Instr[19:15]),
        .ReadRegister2(Instr[24:20]),
        .WriteEnable(RegWrite),
        .WriteRegister(Instr[11:7]),
        .WriteData(Result)
    );

    d_flip_flop AFlipFlop         (.out(A),         .CLK(CLK), .in(RD1));
    d_flip_flop writeDataFlipFlop (.out(WriteData), .CLK(CLK), .in(RD2));

    immediate_extend extend (.ImmExt(ImmExt), .Instr(Instr[31:7]), .ImmSrc(ImmSrc));

    three_to_one_mux srcAMux   (.out(SrcA),   .selectBits(ALUSrcA),   .in1(PC),        .in2(OldPC),  .in3(A));
    three_to_one_mux srcBMux   (.out(SrcB),   .selectBits(ALUSrcB),   .in1(WriteData), .in2(ImmExt), .in3(32'd4));
    three_to_one_mux resultMux (.out(Result), .selectBits(ResultSrc), .in1(ALUOut),    .in2(Data),   .in3(ALUResult));

    alu ALU (.ALUResult(ALUResult), .Zero(Zero), .ALUControl(ALUControl), .SrcA(SrcA), .SrcB(SrcB));

    d_flip_flop ALUFlipFlop (.out(ALUOut), .CLK(CLK), .in(ALUResult));

    /* ---- ASSIGNMENTS ---- */

    assign OP     = Instr[6:0];
    assign funct3 = Instr[14:12];
    assign funct7 = Instr[30];

endmodule // datapath
