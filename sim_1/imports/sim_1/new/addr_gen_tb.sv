`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 08:59:26 AM
// Design Name: 
// Module Name: addr_gen_tb
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





module address_gen_tb();

  // Parameters
  localparam ADDR_WIDTH = 32;
  localparam SUB_SHARES = 4;
  localparam CLK_PERIOD = 10;

  // Inputs
  logic clk_i;
  logic nreset_i;
  logic STATUS_done_i;
  logic [ADDR_WIDTH-1:0] CFG_share_0_start_raddr_i;
  logic [ADDR_WIDTH-1:0] CFG_share_1_start_raddr_i;
  logic [ADDR_WIDTH-1:0] CFG_share_0_start_waddr_i;
  logic [ADDR_WIDTH-1:0] CFG_share_1_start_waddr_i;
  logic master_rready_i;
  logic mem_rvalid_i;
  logic load_store_i;
  

  // Outputs
  logic [ADDR_WIDTH-1:0] master_addr_o;
  logic addr_valid_o;

  // Instantiate the DUT
  address_gen #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .SUB_SHARES(SUB_SHARES)
  ) uut (
    .clk_i(clk_i),
    .nreset_i(nreset_i),
    //.STATUS_done_i(STATUS_done_i),
    .CFG_share_0_start_raddr_i(CFG_share_0_start_raddr_i),
    .CFG_share_1_start_raddr_i(CFG_share_1_start_raddr_i),
    .CFG_share_0_start_waddr_i(CFG_share_0_start_waddr_i),
    .CFG_share_1_start_waddr_i(CFG_share_1_start_waddr_i),
    .master_rready_i(master_rready_i),
    .mem_rvalid_i(mem_rvalid_i),
    .master_addr_o(master_addr_o),
    .addr_valid_o(addr_valid_o),
    .load_store_i(load_store_i)
  );


  always #(CLK_PERIOD/2) clk_i = ~clk_i;

  initial begin

    clk_i = 0;
    nreset_i = 1;
    STATUS_done_i = 0;
    master_rready_i = 0;
    mem_rvalid_i = 0;
    load_store_i = 1'b0;
    
    
    CFG_share_0_start_raddr_i = 32'h0000_1000;
    CFG_share_1_start_raddr_i = 32'h0000_2000;
    CFG_share_0_start_waddr_i = 32'h0000_3000;
    CFG_share_1_start_waddr_i = 32'h0000_4000;


    #5;
    nreset_i = 0;
    #50;
        

    
//==============================================================================================  
  //                     READ TEST
//==============================================================================================    
    nreset_i = 1;
    STATUS_done_i = 1;
    load_store_i = 1'b0;
    
    #5;
     repeat (4) begin

      @(posedge clk_i);
      master_rready_i = 1;
      mem_rvalid_i    = 1;


      @(posedge clk_i);
      master_rready_i = 0;
      mem_rvalid_i    = 0;


      repeat (3) @(posedge clk_i);
    end
    #100;
    
    
        load_store_i = 1'b0;
        #5;
    
    
    
 repeat (4) begin

      @(posedge clk_i);
      master_rready_i = 1;
      mem_rvalid_i    = 1;
    
    
      @(posedge clk_i);
      master_rready_i = 0;
      mem_rvalid_i    = 0;


      repeat (3) @(posedge clk_i);
    end
    #100;

//==============================================================================================  


 end

endmodule
