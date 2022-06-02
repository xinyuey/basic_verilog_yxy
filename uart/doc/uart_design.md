### uart特性

- 全双工、异步、串行通信
- 两线协议
- 点对点通信
- 开始信号（1位，低电平）+ 数据（8位）+ 结束信号（1/2/3位，高电平）
- 奇偶校验位（1位，可选）
- 无应答信号

### uart参数

- 波特率
  - 单位：bps（bits per second）
  - 时钟分频倍数 = 系统时钟频率 / 波特率
  - 采样时刻：1/2分频时钟周期处

### uart子模块

- uart_tx
- uart_rx

### uart时序波形图

![image-20220602110109720](C:\Users\dell\AppData\Roaming\Typora\typora-user-images\image-20220602110109720.png)