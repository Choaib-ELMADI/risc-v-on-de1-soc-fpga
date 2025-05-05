module datapath (OP, funct3, funct7, ZeroE, CLK, RESET, ImmSrcD, PCSrcE, ALUSrcE, ALUControlE, MemWriteM, RegWriteW, ResultSrcW);
    /* ---- OUTPUT PORTS ---- */
    output wire   [6:0] OP;
    output wire [14:12] funct3;
    output wire         funct7;
    output              ZeroE;

    /* ---- INPUT PORTS ---- */
    input               CLK, RESET;
    input         [1:0] ImmSrcD;
    input               PCSrcE, ALUSrcE;
    input         [2:0] ALUControlE;
    input               MemWriteM;
    input               RegWriteW;
    input         [1:0] ResultSrcW;

    /* ---- DATA SIGNALS ---- */
    reg          [31:0] PCFPrime, PCTargetE;
    reg          [31:0] PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
    reg          [31:0] PCF, PCD, PCE;
    reg          [31:0] InstrF, InstrD;
    reg          [31:0] RD1D, RD2D;
    reg          [31:0] RD1E, RD2E;
    reg          [11:7] RdD, RdE, RdM, RdW;
    reg          [31:0] ResultW;
    reg          [31:0] ALUResultE, ALUResultM, ALUResultW;
    reg          [31:0] ImmExtD, ImmExtE;
    reg          [31:0] SrcBE;
    reg          [31:0] WriteDataM;
    reg          [31:0] ReadDataM, ReadDataW;

    /* ---- PARAMETERS ---- */
    parameter INSTR_MEMORY_SIZE = 128;
    parameter DATA_MEMORY_SIZE  = 128;

    /* ---- MODULES ---- */

    /* ---- START FETCH STAGE ---- */

    two_to_one_mux PCFPrimeMux (.out(PCFPrime), .selectBit(PCSrcE), .in1(PCPlus4F), .in2(PCTargetE));

    d_flip_flop PCFFlipFlop (.out(PCF), .CLK(CLK), .in(PCFPrime));

    instruction_memory #(.MEMORY_SIZE(INSTR_MEMORY_SIZE)) instructionMemory
        (
            .ReadData(InstrF),
            .RESET(RESET),
            .CLK(CLK),
            .Address(PCF)
        );

    adder add4ToPCF (.out(PCPlus4F), .in1(PCF), .in2(32'd4));

    /* ---- END FETCH STAGE ---- */

    d_flip_flop instrDFlipFlop   (.out(InstrD),   .CLK(CLK), .in(InstrF));
    d_flip_flop PCDFlipFlop      (.out(PCD),      .CLK(CLK), .in(PCF));
    d_flip_flop PCPlus4DFlipFlop (.out(PCPlus4D), .CLK(CLK), .in(PCPlus4F));

    /* ---- START DECODE STAGE ---- */

    register_file registers (
        .ReadData1(RD1D),
        .ReadData2(RD2D),
        .RESET(RESET),
        .CLK(CLK),
        .ReadRegister1(InstrD[19:15]),
        .ReadRegister2(InstrD[24:20]),
        .WriteEnable(RegWriteW),
        .WriteRegister(RdW),
        .WriteData(ResultW)
    );

    immediate_extend extend (.ImmExt(ImmExtD), .Instr(InstrD[31:7]), .ImmSrc(ImmSrcD));

    /* ---- END DECODE STAGE ---- */

    d_flip_flop RD1EFlipFlop     (.out(RD1E),     .CLK(CLK), .in(RD1D));
    d_flip_flop RD2ElipFlop      (.out(RD2E),     .CLK(CLK), .in(RD2D));
    d_flip_flop PCEFlipFlop      (.out(PCE),      .CLK(CLK), .in(PCD));
    d_flip_flop RdEFlipFlop      (.out(RdE),      .CLK(CLK), .in(RdD));
    d_flip_flop ImmExtEFlipFlop  (.out(ImmExtE),  .CLK(CLK), .in(ImmExtD));
    d_flip_flop PCPlus4EFlipFlop (.out(PCPlus4E), .CLK(CLK), .in(PCPlus4D));

    /* ---- START EXECUTE STAGE ---- */

    two_to_one_mux SrcBEMux (.out(SrcBE), .selectBit(ALUSrcE), .in1(RD2E), .in2(ImmExtE));

    adder PCTargetEAdder (.out(PCTargetE), .in1(PCE), .in2(ImmExtE));

    alu ALU (.ALUResult(ALUResultE), .Zero(ZeroE), .ALUControl(ALUControlE), .SrcA(RD1E), .SrcB(SrcBE));

    /* ---- END EXECUTE STAGE ---- */

    d_flip_flop ALUResultMFlipFlop (.out(ALUResultM), .CLK(CLK), .in(ALUResultE));
    d_flip_flop writeDataMFlipFlop (.out(WriteDataM), .CLK(CLK), .in(RD2E));
    d_flip_flop RdMFlipFlop        (.out(RdM),        .CLK(CLK), .in(RdE));
    d_flip_flop PCPlus4MFlipFlop   (.out(PCPlus4M),   .CLK(CLK), .in(PCPlus4E));

    /* ---- START MEMORY STAGE ---- */

    data_memory #(.MEMORY_SIZE(DATA_MEMORY_SIZE)) dataMemory
        (
            .ReadData(ReadDataM),
            .RESET(RESET),
            .CLK(CLK),
            .WriteEnable(MemWriteM),
            .Address(ALUResultM),
            .WriteData(WriteDataM)
        );

    /* ---- END MEMORY STAGE ---- */

    d_flip_flop ALUResultWFlipFlop (.out(ALUResultW), .CLK(CLK), .in(ALUResultM));
    d_flip_flop readDataWFlipFlop  (.out(ReadDataW),  .CLK(CLK), .in(ReadDataM));
    d_flip_flop RdMFlipFlop        (.out(RdW),        .CLK(CLK), .in(RdM));
    d_flip_flop PCPlus4MFlipFlop   (.out(PCPlus4W),   .CLK(CLK), .in(PCPlus4M));

    /* ---- START WRITE BACK STAGE ---- */

    three_to_one_mux ResultWMux (.out(ResultW), .selectBits(ResultSrcW), .in1(ALUResultW), .in2(ReadDataW), .in3(PCPlus4W));

    /* ---- END WRITE BACK STAGE ---- */

    /* ---- ASSIGNMENTS ---- */

    assign OP     = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct7 = InstrD[30];

endmodule // datapath
