module datapath (OP, funct3, funct7, ZeroE, CLK, RESET, ImmSrcD, PCSrcE, ALUSrcE, ALUControlE, MemWriteM, RegWriteW, ResultSrcW);
    /* ---- OUTPUT PORTS ---- */
    output wire   [6:0] OP;
    output wire [14:12] funct3;
    output wire         funct7;
    output              ZeroE;

    /* ---- INPUT PORTS ---- */
    input               CLK, RESET;
    input               StallF, StallD;
    input               FlushD, FlushE;
    input         [1:0] ForwardAE, ForwardBE;
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
    reg         [19:15] Rs1D, Rs1E;
    reg         [24:20] Rs2D, Rs2E;
    reg          [31:0] ResultW;
    reg          [31:0] ALUResultE, ALUResultM, ALUResultW;
    reg          [31:0] ImmExtD, ImmExtE;
    reg          [31:0] SrcAE, SrcBE;
    reg          [31:0] WriteDataE, WriteDataM;
    reg          [31:0] ReadDataM, ReadDataW;

    /* ---- PARAMETERS ---- */
    parameter INSTR_MEMORY_SIZE = 128;
    parameter DATA_MEMORY_SIZE  = 128;

    /* ---- MODULES ---- */

    /* ---- START FETCH STAGE ---- */

    two_to_one_mux PCFPrimeMux (.out(PCFPrime), .selectBit(PCSrcE), .in1(PCPlus4F), .in2(PCTargetE));

    d_flip_flop_with_enable PCFFlipFlop (.out(PCF), .CLK(CLK), .EN(~StallF), .in(PCFPrime));

    instruction_memory #(.MEMORY_SIZE(INSTR_MEMORY_SIZE)) instructionMemory
        (
            .ReadData(InstrF),
            .RESET(RESET),
            .CLK(CLK),
            .Address(PCF)
        );

    adder add4ToPCF (.out(PCPlus4F), .in1(PCF), .in2(32'd4));

    /* ---- END FETCH STAGE ---- */

    d_flip_flop_with_enable instrDFlipFlop   (.out(InstrD),   .CLK(CLK), .CLR(FlushD), .EN(~StallD), .in(InstrF));
    d_flip_flop_with_enable PCDFlipFlop      (.out(PCD),      .CLK(CLK), .CLR(FlushD), .EN(~StallD), .in(PCF));
    d_flip_flop_with_enable PCPlus4DFlipFlop (.out(PCPlus4D), .CLK(CLK), .CLR(FlushD), .EN(~StallD), .in(PCPlus4F));

    /* ---- START DECODE STAGE ---- */

    register_file registers (
        .ReadData1(RD1D),
        .ReadData2(RD2D),
        .RESET(RESET),
        .CLK(~CLK),
        .ReadRegister1(InstrD[19:15]),
        .ReadRegister2(InstrD[24:20]),
        .WriteEnable(RegWriteW),
        .WriteRegister(RdW),
        .WriteData(ResultW)
    );

    immediate_extend extend (.ImmExt(ImmExtD), .Instr(InstrD[31:7]), .ImmSrc(ImmSrcD));

    /* ---- MAY GENERATE AN ERROR! ---- */
    assign RdD  = InstrD[11:7];
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];

    /* ---- END DECODE STAGE ---- */

    d_flip_flop RD1EFlipFlop     (.out(RD1E),     .CLK(CLK), .CLR(FlushE), .in(RD1D));
    d_flip_flop RD2ElipFlop      (.out(RD2E),     .CLK(CLK), .CLR(FlushE), .in(RD2D));
    d_flip_flop PCEFlipFlop      (.out(PCE),      .CLK(CLK), .CLR(FlushE), .in(PCD));
    d_flip_flop RdEFlipFlop      (.out(RdE),      .CLK(CLK), .CLR(FlushE), .in(RdD));
    d_flip_flop Rs1EFlipFlop     (.out(Rs1E),     .CLK(CLK), .CLR(FlushE), .in(Rs1D));
    d_flip_flop Rs2EFlipFlop     (.out(Rs2E),     .CLK(CLK), .CLR(FlushE), .in(Rs2D));
    d_flip_flop ImmExtEFlipFlop  (.out(ImmExtE),  .CLK(CLK), .CLR(FlushE), .in(ImmExtD));
    d_flip_flop PCPlus4EFlipFlop (.out(PCPlus4E), .CLK(CLK), .CLR(FlushE), .in(PCPlus4D));

    /* ---- START EXECUTE STAGE ---- */

    three_to_one_mux SrcAEMux (.out(SrcAE), .selectBits(ForwardAE), .in1(RD1E), .in2(ResultW), .in3(ALUResultM));

    three_to_one_mux writeDataEMux (.out(WriteDataE), .selectBits(ForwardBE), .in1(RD2E), .in2(ResultW), .in3(ALUResultM));

    two_to_one_mux SrcBEMux (.out(SrcBE), .selectBit(ALUSrcE), .in1(WriteDataE), .in2(ImmExtE));

    adder PCTargetEAdder (.out(PCTargetE), .in1(PCE), .in2(ImmExtE));

    alu ALU (.ALUResult(ALUResultE), .Zero(ZeroE), .ALUControl(ALUControlE), .SrcA(SrcAE), .SrcB(SrcBE));

    /* ---- END EXECUTE STAGE ---- */

    d_flip_flop ALUResultMFlipFlop (.out(ALUResultM), .CLK(CLK), .CLR(1'b0), .in(ALUResultE));
    d_flip_flop writeDataMFlipFlop (.out(WriteDataM), .CLK(CLK), .CLR(1'b0), .in(WriteDataE));
    d_flip_flop RdMFlipFlop        (.out(RdM),        .CLK(CLK), .CLR(1'b0), .in(RdE));
    d_flip_flop PCPlus4MFlipFlop   (.out(PCPlus4M),   .CLK(CLK), .CLR(1'b0), .in(PCPlus4E));

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

    d_flip_flop ALUResultWFlipFlop (.out(ALUResultW), .CLK(CLK), .CLR(1'b0), .in(ALUResultM));
    d_flip_flop readDataWFlipFlop  (.out(ReadDataW),  .CLK(CLK), .CLR(1'b0), .in(ReadDataM));
    d_flip_flop RdMFlipFlop        (.out(RdW),        .CLK(CLK), .CLR(1'b0), .in(RdM));
    d_flip_flop PCPlus4MFlipFlop   (.out(PCPlus4W),   .CLK(CLK), .CLR(1'b0), .in(PCPlus4M));

    /* ---- START WRITE BACK STAGE ---- */

    three_to_one_mux ResultWMux (.out(ResultW), .selectBits(ResultSrcW), .in1(ALUResultW), .in2(ReadDataW), .in3(PCPlus4W));

    /* ---- END WRITE BACK STAGE ---- */

    /* ---- ASSIGNMENTS ---- */

    assign OP     = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct7 = InstrD[30];

endmodule // datapath
