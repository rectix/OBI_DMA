`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 11:52:28 AM
// Design Name: 
// Module Name: master_v1
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


module master_v1#(parameter WIDTH       = 32,
                  parameter N_SHARES    = 4 ,
                  parameter memory_size = 32  )   // the logic behind the write enable    
                                             // write some dat ain the memory to red        
(
    input logic                    clk_i,
    input logic                    nreset_i,
    input logic [WIDTH-1 : 0] CFG_share_0_start_raddr_i,
    input logic [WIDTH-1 : 0] CFG_share_1_start_raddr_i,
    input logic [WIDTH-1 : 0] CFG_share_0_start_waddr_i, 
    input logic [WIDTH-1 : 0] CFG_share_1_start_waddr_i,
    input logic                    STATUS_busy_i            
   
   
   
   







    );
    
//=====================================================================

//    it has to be implimented at various lavels of busy   _ in such a way that high level busy will keep you inside the write  to memeory  operation 

//    decide about which data   you will intentiall push in 

//    test the write in the fifo and generate thse control signal that     
    

//=====================================================================


logic                  master_req;
logic                  master_we;
logic                  mem_gnt;
logic                  master_rready;
logic                  mem_rvalid;
logic [WIDTH-1:0]      mem_rdata;
logic [WIDTH-1:0]      master_wdata;

logic [WIDTH-1:0]      master_addr;




logic             addr_valid      ;
logic             op_done         ;  // a confirmer !!!

logic             wfifo_wr_en      ;
logic             wfifo_rd_en      ;

logic             load_store      ;
logic             fifo_full , fifo_empty ;
logic [3 : 0]     master_be;

logic             start_single_read, start_single_write;





//=====================================================================
//   control signal LOGIC
//=====================================================================

always @(posedge clk_i) 
begin
    if(!nreset_i) begin
    
        wfifo_wr_en  <=  1'b0 ;
        wfifo_rd_en  <=  1'b0 ;
        load_store   <=  1'b1 ;         // write in the fifo anyway  but iits noo the only trigger rvali/rready 
        start_single_read   <= 1'b0;
        start_single_write  <= 1'b0;
    end else begin 
     if(!STATUS_busy_i )  begin 
            wfifo_wr_en    <=   1'b1 ;
            wfifo_rd_en    <=   1'b0 ;
            load_store     <=   1'b1 ; 
            start_single_read   <= 1'b1;
            start_single_write  <= 1'b0;
     
     end else  begin 
            wfifo_wr_en    <=   1'b0 ;
            wfifo_rd_en    <=   1'b0 ;
            load_store     <=   1'b1 ;
            start_single_read   <= 1'b0;
            start_single_write  <= 1'b0;    
     end 
    
    
    end  



end 














//=====================================================================
    
    
    
    fifo_shares_0 #(
        .DEPTH(N_SHARES),
        .WIDTH(WIDTH)
    ) wfifo (
        .clk_i              (clk_i),
        .nreset_i           (nreset_i),
        .fifo_wr_en_i       (wfifo_wr_en),    // to generate 
        .fifo_rd_en_i       (wfifo_rd_en),
        
        .input_share_0_xx   (mem_rdata),
        .output_share_0_xx  (master_wdata),
        
        .fifo_full_o        (fifo_full),
        .fifo_empty_o       (fifo_empty)
    );
    
    
    
    
    
    OBI_MASTER_IF #(
        .WIDTH(WIDTH)
        
  ) obi_master (
    .clk_i                  (clk_i),
    .nreset_i               (nreset_i),
    .req_o                  (master_req),
    .we_o                   (master_we),
    .gnt_i                  (mem_gnt),
    .rready_o               (master_rready),
    .rvalid_i               (mem_rvalid),
    .rdata_i                (mem_rdata),
    .wdata_o                (master_wdata),
    .addr_o                 (master_addr),
    .be_o                   (master_be),
    
    
    .start_single_write_i   (start_single_write),  // to generat e
    .start_single_read_i    (start_single_read),


    .wfifo_wdata_i    (master_wdata),
    .wfifo_rdata_o    (mem_rdata),
    .generated_addr_i (master_addr),
    .addr_valid_i     (addr_valid)
    
    
    //.op_done          (op_done) // a confirmer !!!

  );
  

  
    
 OBI_SLAVE_IF #(
    .WIDTH(WIDTH),
    .DEPTH(memory_size)
) obi_slave(
    .clk_i                      (clk_i),
    .req_i                      (master_req),
    .we_i                       (master_we),
    .gnt_o                      (mem_gnt),
    .rready_i                   (master_rready),
    .rvalid_o                   (mem_rvalid),
    .rdata_o                    (mem_rdata),
    .wdata_i                    (master_wdata),
    .addr_i                     (master_addr) ,    // check the internal ones 
    .be_i                       (master_be)
);   
    
    


    address_gen #(
    .ADDR_WIDTH(WIDTH),
    .SUB_SHARES(N_SHARES)
  ) addr_generetor (
    .clk_i                      (clk_i),
    .nreset_i                   (nreset_i),
    //.STATUS_done_i              (STATUS_done_i),
    .CFG_share_0_start_raddr_i  (CFG_share_0_start_raddr_i),
    .CFG_share_1_start_raddr_i  (CFG_share_1_start_raddr_i),
    .CFG_share_0_start_waddr_i  (CFG_share_0_start_waddr_i),
    .CFG_share_1_start_waddr_i  (CFG_share_1_start_waddr_i),
    
    
    
    .master_rready_i            (master_rready),
    .mem_rvalid_i               (mem_rvalid),
    .master_addr_o              (master_addr),
    .addr_valid_o               (addr_valid),
    .load_store_i               (load_store)   /// to generate 
    
  );
        
    
    
    
    
    
endmodule
