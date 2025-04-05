module datapath ();
    reg        RESET, CLK;
    reg [31:0] PCPlus4, PC, Instr;
    reg [31:0] SrcA, WriteData, SrcB;
    reg        RegWrite;
    reg [31:0] Result;

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

endmodule // datapath
