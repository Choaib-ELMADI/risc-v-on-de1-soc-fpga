module data_memory
    #(parameter MEMORY_SIZE = 64)
    (ReadData, RESET, CLK, WriteEnable, Address, WriteData);

    output reg [31:0] ReadData;
    input             RESET, CLK, WriteEnable;
    input      [31:0] Address, WriteData;

    // 64 rows memory * 32 bits each
    reg        [31:0] DATA_MEMORY[MEMORY_SIZE-1:0];
    integer           i;

    always @(posedge RESET, posedge CLK)
        begin
            if (RESET) begin
                for (i=0; i<MEMORY_SIZE; i=i+1) begin
                    DATA_MEMORY[i] <= 32'b00;
                end
            end
            else begin
                if (WriteEnable) DATA_MEMORY[Address] <= WriteData;
                else             ReadData             <= DATA_MEMORY[Address];
            end
        end

endmodule // data_memory
