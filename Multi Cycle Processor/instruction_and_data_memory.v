module instruction_and_data_memory
    #(parameter MEMORY_SIZE = 64)
    (ReadData, RESET, CLK, WriteEnable, Address, WriteData,size);

    output reg [31:0] ReadData;
    input             RESET, CLK, WriteEnable;
    input      [31:0] Address, WriteData;
    input      [2:0]  size;

    // 64 rows memory * 32 bits each
    reg        [31:0] MEMORY[MEMORY_SIZE-1:0];
    integer           i;

    always @(posedge RESET, posedge CLK)
        begin
            if (RESET) begin
                for (i=0; i<MEMORY_SIZE; i=i+1) begin
                    MEMORY[i] <= 32'b00;
                end
            end
            else begin
                if (WriteEnable) MEMORY[Address] <= WriteData;
                else             ReadData        <= MEMORY[Address];
            end
        end

endmodule // instruction_and_data_memory
