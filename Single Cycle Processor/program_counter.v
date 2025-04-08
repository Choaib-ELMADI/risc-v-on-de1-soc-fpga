module program_counter (PC, RESET, CLK, EN, PCNext);
    output reg [31:0] PC;
    input             RESET, CLK, EN;
    input      [31:0] PCNext;

    // The 'RESET' signal is asynchronous
    // The 'EN' signal is synchronous

    always @(posedge RESET, posedge CLK)
        begin
            if (RESET)  PC <= 32'b00;
            else
                if (EN) PC <= PCNext;
        end

endmodule // program_counter
