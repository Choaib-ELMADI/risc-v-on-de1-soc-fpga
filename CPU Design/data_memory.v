module data_memory (ReadData, RESET, CLK, WriteEnable, Address, WriteData);
    output reg [31:0] ReadData;
    input             RESET, CLK, WriteEnable;
    input      [31:0] Address, WriteData;

    // 64 rows memory * 32 bits each
    reg        [31:0] DATA_MEMORY[63:0];
    integer           i;

    always @(posedge RESET, posedge CLK)
        begin
            if (RESET) begin
                for (i=0; i<=63; i=i+1) begin
                    DATA_MEMORY[i] <= 32'b00;
                end
            end
            else begin
                if (WriteEnable) DATA_MEMORY[Address] <= WriteData;
                else             ReadData             <= DATA_MEMORY[Address];
            end
        end

endmodule // data_memory
