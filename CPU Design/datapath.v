module datapath ();
    reg        RESET, CLK;
    reg [31:0] PCPlus4, PC, Instr;

    adder add4ToPC (.out(PCPlus4), .in1(PC), .in2(32'd4));

    instruction_memory memory (.ReadData(Instr), .RESET(RESET), .CLK(CLK), .Address(PC));

endmodule // datapath
