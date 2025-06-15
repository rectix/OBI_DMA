`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 03:52:10 PM
// Design Name: 
// Module Name: master_v1_sim
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



module master_v1_tb;

  // Parameters
  parameter WIDTH       = 32;
  parameter N_SHARES    = 4;
  parameter memory_size = 32;

  // DUT Inputs
  logic                    clk_i;
  logic                    nreset_i;
  logic [WIDTH-1:0]   CFG_share_0_start_raddr_i;
  logic [WIDTH-1:0]   CFG_share_1_start_raddr_i;
  logic [WIDTH-1:0]   CFG_share_0_start_waddr_i;
  logic [WIDTH-1:0]   CFG_share_1_start_waddr_i;
  logic                    STATUS_busy_i;

  // Clock generation
  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD/2) clk_i = ~clk_i;

  // DUT Instantiation
  master_v1 #(
    .WIDTH(WIDTH),
    .N_SHARES(N_SHARES),
    .memory_size(memory_size)
  ) dut (
    .clk_i                       (clk_i),
    .nreset_i                    (nreset_i),
    .CFG_share_0_start_raddr_i   (CFG_share_0_start_raddr_i),
    .CFG_share_1_start_raddr_i   (CFG_share_1_start_raddr_i),
    .CFG_share_0_start_waddr_i   (CFG_share_0_start_waddr_i),
    .CFG_share_1_start_waddr_i   (CFG_share_1_start_waddr_i),
    .STATUS_busy_i               (STATUS_busy_i)
  );

  // Testbench Initialization
  initial begin
 

   
    clk_i = 0;
    nreset_i = 1;
    CFG_share_0_start_raddr_i =  32'd0;
    CFG_share_1_start_raddr_i =  32'd16;
    CFG_share_0_start_waddr_i =  32'd24;
    CFG_share_1_start_waddr_i =  32'd24;
    STATUS_busy_i = 1'b1;

    // Reset sequence
    #20;
    nreset_i = 0;
    #50;
    
   
    nreset_i = 1;



    #30;
    STATUS_busy_i = 1;

    #50;
    STATUS_busy_i = 0;


    #100;

  end

endmodule

