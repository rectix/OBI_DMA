`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2025 01:44:47 PM
// Design Name: 
// Module Name: fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_fifo_shares_0;

    parameter WIDTH = 32;
    parameter DEPTH = 4;

    // DUT Signals
    logic clk;
    logic rst_n;
    logic fifo_wr_en_i;
    logic fifo_rd_en_i;
    logic [WIDTH-1:0] input_share_0_xx;
    logic [WIDTH-1:0] output_share_0_xx;
    logic fifo_full_o;
    logic fifo_empty_o;

    // Instantiate DUT
    fifo_shares_0 #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) dut (
        .clk_i(clk),
        .nreset_i(rst_n),
        .fifo_wr_en_i(fifo_wr_en_i),
        .fifo_rd_en_i(fifo_rd_en_i),
        .input_share_0_xx(input_share_0_xx),
        .output_share_0_xx(output_share_0_xx),
        .fifo_full_o(fifo_full_o),
        .fifo_empty_o(fifo_empty_o)
    );
    
initial begin 
clk = 1'b0;
end     
    


always #5 clk = ~clk;




    initial begin


        rst_n = 1;
        fifo_wr_en_i = 0;
        fifo_rd_en_i = 0;
        input_share_0_xx = 0;

        // Reset sequence
        #10;
        rst_n = 0;
        #50;
        rst_n = 1;

        for (int i = 0; i < DEPTH; i++) begin
            @(posedge clk);
            if (!fifo_full_o) begin
                fifo_wr_en_i = 1;
                input_share_0_xx = i + 100;
            end
        end
        
        
        
        @(posedge clk);
        fifo_wr_en_i = 0;
        
       

        #50;

         

        for (int i = 0; i < DEPTH; i++) begin
            @(posedge clk);
            if (!fifo_empty_o) begin
                 fifo_rd_en_i = 1;

                
            end
        end
        @(posedge clk);
        fifo_rd_en_i = 0;
        
        


        #20;
        //$finish;
    end

endmodule
