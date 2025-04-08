module instruction_memory (ReadData, RESET, CLK, Address);
    output reg [31:0] ReadData;
    input             RESET, CLK;
    input      [31:0] Address;

    // 64 rows memory * 32 bits each
    reg        [31:0] INSTRUCTION_MEMORY[63:0];
    integer           i;

    always @(posedge RESET, posedge CLK)
        begin
            if (RESET) begin
                for (i=0; i<=63; i=i+1) begin
                    INSTRUCTION_MEMORY[i] <= 32'b00;
                end
            end
            else
                ReadData <= INSTRUCTION_MEMORY[Address];
        end

endmodule // instruction_memory
