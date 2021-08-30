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
 
 
  //change the parameter for different Test!
   parameter DATA_VALID_at_FALLING_inst0 = 0;
   parameter DATA_VALID_at_FALLING_inst1 = 1;
   
   parameter IDLE_VALUE_for_Clk_inst0 = 1;
   parameter IDLE_VALUE_for_Clk_inst1 = 1;
   
   parameter TRAN_WIDTH_inst0 = 8;
   parameter TRAN_WIDTH_inst1 = 16;
   
   parameter IDLE_VALUE_for_MOSI_inst0 = 0;
   parameter IDLE_VALUE_for_MOSI_inst1 = 0;
   
   parameter Receive_VALID_at_FALLING_inst0 = 0;
   parameter Receive_VALID_at_FALLING_inst1 = 0;
    
   reg  r_Clock = 1'b1;   
   reg  i_SPI_Send_Sync = 1'b0;
   reg[31:0] i_SPI_Send_Data = 1'b0;
   wire w_SPI_MISO_inst0;
   wire w_SPI_MISO_inst1;
  
  
   
   wire w_SPI_Send_Over_ack_inst0;
   wire w_SPI_Receive_Sync_inst0;
   wire [TRAN_WIDTH_inst0 - 1 : 0 ]w_SPI_Receive_Data_inst0;
   wire w_SPI_Clk_inst0;
   wire w_SPI_SS_inst0;
   wire w_SPI_MOSI_inst0;
   
   wire w_SPI_Send_Over_ack_inst1;
   wire w_SPI_Receive_Sync_inst1;
   wire [TRAN_WIDTH_inst1 - 1 : 0 ]w_SPI_Receive_Data_inst1;
   wire w_SPI_Clk_inst1;
   wire w_SPI_SS_inst1;
   wire w_SPI_MOSI_inst1;
   reg r_SPI_MOSI_inst0=0;
   reg r_SPI_MOSI_inst1=0;
   
   assign w_SPI_MISO_inst0 = Receive_VALID_at_FALLING_inst0 ? r_SPI_MOSI_inst0 : w_SPI_MOSI_inst0;
   assign w_SPI_MISO_inst1 = Receive_VALID_at_FALLING_inst1 ? r_SPI_MOSI_inst1: w_SPI_MOSI_inst1;
   
   always@(w_SPI_MOSI_inst0)begin
         # (2 * c_CLOCK_PERIOD_ns)
         r_SPI_MOSI_inst0 =  w_SPI_MOSI_inst0;
   end
   always@(w_SPI_MOSI_inst1)begin
         # (2 * c_CLOCK_PERIOD_ns)
         r_SPI_MOSI_inst1 =  w_SPI_MOSI_inst1;
   end
   
   SPI_Master #(
    .IDLE_VALUE_for_Clk(IDLE_VALUE_for_Clk_inst0),
    .IDLE_VALUE_for_MOSI(IDLE_VALUE_for_MOSI_inst0),
    .DATA_VALID_at_FALLING(DATA_VALID_at_FALLING_inst0),
    .TRAN_WIDTH(TRAN_WIDTH_inst0),
    .Receive_VALID_at_FALLING(Receive_VALID_at_FALLING_inst0)
  ) inst0 (
    .c_Clk_High(r_Clock),
    .i_SPI_Send_Sync(i_SPI_Send_Sync),
    .i_SPI_Send_Data(i_SPI_Send_Data),
    .o_SPI_Send_Over_ack(w_SPI_Send_Over_ack_inst0),
    .o_SPI_Receive_Sync(w_SPI_Receive_Sync_inst0),
    .o_SPI_Receive_Data(w_SPI_Receive_Data_inst0),
    .o_SPI_Clk(w_SPI_Clk_inst0),
    .o_SPI_SS(w_SPI_SS_inst0),
    .o_SPI_MOSI(w_SPI_MOSI_inst0),
    .i_SPI_MISO(w_SPI_MISO_inst0)
  );
  
   SPI_Master #(
    .IDLE_VALUE_for_Clk(IDLE_VALUE_for_Clk_inst1),
    .IDLE_VALUE_for_MOSI(IDLE_VALUE_for_MOSI_inst1),
    .DATA_VALID_at_FALLING(DATA_VALID_at_FALLING_inst1),
    .TRAN_WIDTH(TRAN_WIDTH_inst1),
    .Receive_VALID_at_FALLING(Receive_VALID_at_FALLING_inst1)
  ) inst1 (
    .c_Clk_High(r_Clock),
    .i_SPI_Send_Sync(i_SPI_Send_Sync),
    .i_SPI_Send_Data(i_SPI_Send_Data),
    .o_SPI_Send_Over_ack(w_SPI_Send_Over_ack_inst1),
    .o_SPI_Receive_Sync(w_SPI_Receive_Sync_inst1),
    .o_SPI_Receive_Data(w_SPI_Receive_Data_inst1),
    .o_SPI_Clk(w_SPI_Clk_inst1),
    .o_SPI_SS(w_SPI_SS_inst1),
    .o_SPI_MOSI(w_SPI_MOSI_inst1),
    .i_SPI_MISO(w_SPI_MOSI_inst1)
  );
   
  always
    #(c_CLOCK_PERIOD_ns/2) r_Clock <= !r_Clock;
    
// Main Testing:
initial
    begin
        # 90
        i_SPI_Send_Data=32'h8080a5a5;
        # 10
        i_SPI_Send_Sync= 1'b1;       //make Send 
        # 1500
        i_SPI_Send_Sync=~i_SPI_Send_Sync;//make Send 
      
        
    end
    
    
endmodule
