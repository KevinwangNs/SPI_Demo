`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/26 15:25:37
// Design Name: 
// Module Name: SPI_Master_TB
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


module SPI_Master_TB( );
  ///parameters
  parameter c_CLOCK_PERIOD_ns = 10;//100m input
    
    
    
   reg  r_Clock =0;   
   reg  i_SPI_Send_Sync=0;
   reg[31:0] i_SPI_Send_Data=0;
   
   wire w_SPI_Send_Over_ack_inst0;
   wire w_SPI_Receive_Sync_inst0;
   wire w_SPI_Receive_Data_inst0;
   wire w_SPI_Clk_inst0;
   wire w_SPI_SS_inst0;
   wire w_SPI_MOSI_inst0;
   
   wire w_SPI_Send_Over_ack_inst1;
   wire w_SPI_Receive_Sync_inst1;
   wire w_SPI_Receive_Data_inst1;
   wire w_SPI_Clk_inst1;
   wire w_SPI_SS_inst1;
   wire w_SPI_MOSI_inst1;
   
   
   SPI_Master #(
    .IDLE_VALUE_for_Clk(0),
    .IDLE_VALUE_for_MOSI(0),
    .DATA_VALID_at_FALLING(0),
    .Tran_width(32),
    .DE_GLITCH_Enable(0)
  ) inst0 (
    .c_clk_100m(r_Clock),
    .i_SPI_Send_Sync(i_SPI_Send_Sync),
    .i_SPI_Send_Data(i_SPI_Send_Data),
    .o_SPI_Send_Over_ack(w_SPI_Send_Over_ack_inst0),
    .o_SPI_Receive_Sync(w_SPI_Receive_Sync_inst0),
    .o_SPI_Receive_Data(w_SPI_Receive_Data_inst0),
    .o_SPI_Clk(w_SPI_Clk_inst0),
    .o_SPI_SS(w_SPI_SS_inst0),
    .o_SPI_MOSI(w_SPI_MOSI_inst0),
    .i_SPI_MISO()
  );
  
   SPI_Master #(
    .IDLE_VALUE_for_Clk(0),
    .IDLE_VALUE_for_MOSI(0),
    .DATA_VALID_at_FALLING(1),
    .Tran_width(24),
    .DE_GLITCH_Enable(0)
  ) inst1 (
    .c_clk_100m(r_Clock),
    .i_SPI_Send_Sync(i_SPI_Send_Sync),
    .i_SPI_Send_Data(i_SPI_Send_Data),
    .o_SPI_Send_Over_ack(w_SPI_Send_Over_ack_inst1),
    .o_SPI_Receive_Sync(w_SPI_Receive_Sync_inst1),
    .o_SPI_Receive_Data(w_SPI_Receive_Data_inst1),
    .o_SPI_Clk(w_SPI_Clk_inst1),
    .o_SPI_SS(w_SPI_SS_inst1),
    .o_SPI_MOSI(w_SPI_MOSI_inst1),
    .i_SPI_MISO()
  );
   
  always
    #(c_CLOCK_PERIOD_ns/2) r_Clock <= !r_Clock;
    
// Main Testing:
initial
    begin
        #100
        i_SPI_Send_Data=32'hffffa5a5;
        #100
        i_SPI_Send_Sync=1;
       
    end
    
    
endmodule
