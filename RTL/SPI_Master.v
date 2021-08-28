`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: nnggg
// 
// Create Date: 2021/08/26 08:38:52
// Design Name: 
// Module Name: SPI_Master
// Project Name: 
// Target Devices: 
// Tool Versions: Vivado 2020.1
// Description: 
// SPI Master 4-Pin
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//          0.10  - 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
 // IP Setting parameter  
// please set those to meet the requirment of Slave IC datasheet
module SPI_Master(


    input c_clk_100m,
    //////Send Inferface
    input i_SPI_Send_Sync,
    input [TRAN_WIDTH-1:0] i_SPI_Send_Data,
    output reg o_SPI_Send_Over_ack = 0,
    //////Receive Inferface
    output reg o_SPI_Receive_Sync = 0,
    output reg [TRAN_WIDTH-1:0]o_SPI_Receive_Data = 0,
    /////SPI Inferface
    output reg o_SPI_Clk = 1,
    output reg o_SPI_SS = 1,
    output reg o_SPI_MOSI = 0,
    input i_SPI_MISO
    
    
    );
parameter IDLE_VALUE_for_Clk = 0;
parameter IDLE_VALUE_for_MOSI = 0;
parameter DATA_VALID_at_FALLING = 1;//set 0 for RISING EDGE
parameter[5:0] TRAN_WIDTH = 24;//8~32

parameter Receive_VALID_at_FALLING = 0;
    
//Debug port
reg [31:0] r_Error_Count=0;

//////////////////clock part////////////////////
reg [1:0]r_Low_clock_count=0;
always@(posedge c_clk_100m)begin
    r_Low_clock_count <= r_Low_clock_count+1;
end
wire c_Clk_Low;//slow clock for SPI clock output,will be 2X of actual output clock;
assign c_Clk_Low=r_Low_clock_count[0];//25m SPI clock output
//assign c_Clk_Low=r_Low_clock_count[1];//12.5m SPI clock output



///////////////////Send part/////////////////////
//-----------FSM--for--SPI_Send-------    
parameter [4:0] 
    s_Sync_wait   = 5'b00001,
	s_Send_ss     = 5'b00010,
    s_Send_data   = 5'b00100,   
    s_Data_shift  = 5'b01000,
    s_Send_over   = 5'b10000;
reg [4:0]r_Send_SM = s_Sync_wait;

reg r_Send_Sync_last = 0;
reg [5:0]r_Bit_Index = 0;
reg [TRAN_WIDTH-1:0]r_Send_Data_l = 0;

reg r_Receive_Data_lock_sig = 0;

always@(posedge c_Clk_Low) begin
    case(r_Send_SM)
    s_Sync_wait:///wait for the Sync Reverse to begin sending
        begin
            o_SPI_Clk  <= IDLE_VALUE_for_Clk;
            o_SPI_SS   <= 1'b1;
            o_SPI_MOSI <= IDLE_VALUE_for_MOSI;
            
            r_Bit_Index <= 0;
            o_SPI_Receive_Sync <= o_SPI_Send_Over_ack;
            r_Receive_Data_lock_sig <= 0;
            
            if(i_SPI_Send_Sync == r_Send_Sync_last)
            begin
                r_Send_SM <= s_Sync_wait;
            end
            else begin
                r_Send_SM <= s_Send_ss;
            end
        end
        
    s_Send_ss://Send SS sample send data
        begin
            o_SPI_Clk  <= IDLE_VALUE_for_Clk;
            o_SPI_SS   <= 1'b0;
            o_SPI_MOSI <= IDLE_VALUE_for_MOSI;
            
            r_Send_Data_l <= i_SPI_Send_Data;
            r_Send_Sync_last <= ~r_Send_Sync_last;
           
            r_Send_SM <= s_Send_data;
        end
        
    s_Send_data://Send 1bit and half clock -- Add Bit Index
        begin
            o_SPI_Clk  <= DATA_VALID_at_FALLING;
            o_SPI_MOSI <= r_Send_Data_l[TRAN_WIDTH-1];
            
            r_Bit_Index <= r_Bit_Index+1;
            
            r_Send_SM <= s_Data_shift;
        end
        
    s_Data_shift://Send another half clock --Send data shift left
        begin
            o_SPI_Clk <= ~DATA_VALID_at_FALLING;
            r_Send_Data_l <= r_Send_Data_l<<1;           
           
             if(r_Bit_Index<TRAN_WIDTH)//check if all bits has been sent
            begin
                r_Send_SM <= s_Send_data;
            end
            else begin
                r_Receive_Data_lock_sig=1;
                
                r_Send_SM <= s_Send_over;
            end
            
        end
        
    s_Send_over:// Finish sending--Back to waiting
        begin
            o_SPI_Clk  <= IDLE_VALUE_for_Clk;
            o_SPI_SS   <= 1'b0;
            o_SPI_MOSI <= IDLE_VALUE_for_MOSI;
            
            r_Receive_Data_lock_sig = 0;
            o_SPI_Send_Over_ack <= ~o_SPI_Send_Over_ack;
            
            r_Send_SM <= s_Sync_wait;
        end
        
    default:// 
        begin 
            r_Send_SM <= s_Sync_wait;
            r_Error_Count<=r_Error_Count+1;//should always be 0
         end
    endcase
end

/////////////Receive Part//////////
reg [TRAN_WIDTH-1:0]r_SPI_Receive_Data_pre = 0;
wire w_SPI_Receive_Sample_Clk;

assign w_SPI_Receive_Sample_Clk = Receive_VALID_at_FALLING ? ~o_SPI_Clk : o_SPI_Clk ;

always@(posedge w_SPI_Receive_Sample_Clk)begin
	if( o_SPI_SS == 0 )begin
		r_SPI_Receive_Data_pre = i_SPI_MISO + ( r_SPI_Receive_Data_pre << 1 );
	end
end

always@(negedge r_Receive_Data_lock_sig)begin
    o_SPI_Receive_Data <= r_SPI_Receive_Data_pre;
end

 
    
    
    
    

endmodule
