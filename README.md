# SPI_Demo

### 1 Set the parameters
Set parameters as your IC's datasheets suggested!



* **DIVIDE_VALUE_for_Clk_Freq**

if DIVIDE_VALUE_for_Clk_Freq=0,SPI_Clk frequency will be 1/4 of c_Clk_High frequency.
if DIVIDE_VALUE_for_Clk_Freq=1,SPI_Clk frequency will be 1/8 of c_Clk_High frequency.

* **DATA_VALID_at_FALLING**

The edge of slave sampling.boolean value,**1 for ture,0 for false**. :point_down: 

![DATA_VALID_at_FALLING.png](https://github.com/KevinwangNs/SPI_Demo/blob/main/Image/DATA_VALID_at_FALLING.png)

* **IDLE_VALUE_for_Clk**  and  **IDLE_VALUE_for_MOSI**   

 The value of SPI_CLk and SPI_MOSI when they are idle. :point_down: 
![IDLE_VALUE.png](https://github.com/KevinwangNs/SPI_Demo/blob/main/Image/IDLE_VALUE.png)

* **TRAN_WIDTH**

The number of bits will be send in each SPI transaction,from 8bits to 32bits.  :point_down:  
![TRAN_WIDTH.png](https://github.com/KevinwangNs/SPI_Demo/blob/main/Image/TRAN_WIDTH.png)

### 2 Control the (Send/Receive)Interface
* Send Interface

control the Send Interface as follow 3 Steps.

![Send_interface.png](https://github.com/KevinwangNs/SPI_Demo/blob/main/Image/Send_interface.png)

**i_SPI_Send_Sync** : control signal of each transaction.

SPI Mater will start transaction each time after detecting the level change of **i_SPI_Send_Sync**.

**[TRAN_WIDTH:0]i_SPI_Send_Data** :the data to send.

In order to avoid the problem that may be caused by crossing clock domains, please set the i_SPI_Send_Data **before** change the level of i_SPI_Send_Sync.

**o_SPI_Send_Over_ack**:finish signal.

o_SPI_Send_Over_ack will be the same value as i_SPI_Send_Sync after each transaction is finished.

* Receive Interface

Data will be ready to read before Receive_Sync inverted. 

![Receive_interface.png](https://github.com/KevinwangNs/SPI_Demo/blob/main/Image/Receive_interface.png)

**o_SPI_Receive_Sync**: finish signal,inverted when data is ready for reading.(please sample the datas after inverting ASAP.)

**[TRAN_WIDTH-1:0]o_SPI_Receive_Data**:data has been received.

**[TRAN_WIDTH-1:0]o_SPI_Sent_Data** :data has been sent.(this data is synchronized with o_SPI_Receive_Data).


 :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction:  :construction: 
### trouble shooting
