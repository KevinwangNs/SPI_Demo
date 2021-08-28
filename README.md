# SPI_Demo

 :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction: 
**************under construction not finished*************



### 1 Set the parameters
Set parameters as your IC's datasheets suggested!


**DATA_VALID_at_FALLING**

The edge of slave sampling.boolean value,**1 for ture,0 for false**. :point_down: 

![DATA_VALID_at_FALLING.png](https://github.com/KevinwangNs/SPI_Demo/blob/main/Image/DATA_VALID_at_FALLING.png)

**IDLE_VALUE_for_Clk**  and  **IDLE_VALUE_for_MOSI**   

 The value of SPI_CLk and SPI_MOSI when they are idle. :point_down: 
![IDLE_VALUE.png](https://github.com/KevinwangNs/SPI_Demo/blob/main/Image/IDLE_VALUE.png)

**TRAN_WIDTH**

The number of bits will be send in each SPI transaction,from 8bits to 32bits.  :point_down:  
![TRAN_WIDTH.png](https://github.com/KevinwangNs/SPI_Demo/blob/main/Image/TRAN_WIDTH.png)

### 2 Control the (Send/Receive)Interface
Send Interface

**i_SPI_Send_Sync** : control signal of each transaction.

SPI Mater will start transaction each time after detecting the level change of **i_SPI_Send_Sync**.

**[TRAN_WIDTH:0]i_SPI_Send_Data** :the data to send.

In order to avoid the problem that may be caused by crossing clock domains, please set the i_SPI_Send_Data **before** change the level of i_SPI_Send_Sync.

**o_SPI_Send_Over_ack**:finish signal.

o_SPI_Send_Over_ack will be the same value as i_SPI_Send_Sync after each transaction is finished.
