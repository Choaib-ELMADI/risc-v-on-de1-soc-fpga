module instruction_memory
    #(parameter MEMORY_SIZE = 64)
    (ReadData, RESET, CLK, Address);

    output reg [31:0] ReadData;
    input             RESET, CLK;
    input      [31:0] Address;

    // 64 rows memory * 32 bits each
    reg        [31:0] INSTRUCTION_MEMORY[MEMORY_SIZE-1:0];
    integer           i;

    always @(posedge RESET, posedge CLK)
        begin
            if (RESET) begin
                for (i=0; i<MEMORY_SIZE; i=i+1) begin
                    INSTRUCTION_MEMORY[i] <= 32'b00;
                end
            end
            else
                ReadData <= INSTRUCTION_MEMORY[Address];
        end

endmodule // instruction_memory
