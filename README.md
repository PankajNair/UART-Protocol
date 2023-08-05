# UART Protocol
## Problem Statement
The UART (Universal Asynchronous Receiver/Transmitter) protocol plays a crucial role in various fields, such as telecommunications, embedded systems, industrial automation, and IoT devices. Its popularity has grown as a preferred hardware platform for implementing communication interfaces due to its versatility, real-time capabilities, and ease of integration. Utilizing FPGAs for implementing the UART protocol allows for customized hardware architecture tailored to the specific requirements of the application. This enables the implementation of specialized UART communication schemes that may not be readily available in standard software libraries or traditional microcontrollers.

The following is the design of UART Protocol Serial Communication System using Verilog HDL. 
## Data Information
The input data and stop bits are parameterized allowing for flexibility.
## Project Pipeline
* Baud Rate Generator (timer): A parameterized timer that ticks every user-specified interval (finalValue). Used for upsampling (16*Baud Rate) the input data and finding the middle value for proper sampling.
* Receiver (uart_rx): This module contains the design of the receiver. It serially takes in the data stream and outputs the data in parallel.
* Transmitter (uart_tx): This module contains the design of the transmitter. It takes in the data in parallel and serially outputs the data.
* Top Module (uartTop): This is the topmost module that is used to connect all other modules in the design. 
