`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2023 04:16:33
// Design Name: 
// Module Name: uartTop
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


module uartTop #(parameter dBits = 8, sbTicks = 16) (
input clk, resetn,
//transmitter
input [dBits-1:0] writeData,
input writeUART,
output tx, 
output txFull,
//receiver
output [dBits-1:0] readData,
input readUART,
input rx,
output rxEmpty,
//baud rate generator
input [10:0] timerValue
);

//timer - Baud Rate Generator
wire tick;
timer #(.bits(11)) baudRateGenerator (
.clk(clk), 
.resetn(resetn), 
.enable(1'b1),
.finalValue(timerValue),
.done(tick)
);

//Receiver
wire rxTick;
wire [dBits-1:0] rxOut;
uart_rx #(.dBits(dBits), .sbTicks(sbTicks)) receiver (
.clk(clk), 
.resetn(resetn),
.rx(rx), 
.sTick(tick),
.rxDone(rxTick),
.rxOut(rxOut)
);

FIFO rxFIFO (
  .clk(clk),                  // input wire clk
  .srst(~resetn),                // input wire srst
  .din(rxOut),                  // input wire [7 : 0] din
  .wr_en(rxTick),              // input wire wr_en
  .rd_en(readUART),              // input wire rd_en
  .dout(readData),                // output wire [7 : 0] dout
  .full(),                // output wire full
  .empty(rxEmpty)             // output wire empty
);

//Transmitter
wire txTick, txEmpty;
wire [dBits-1:0] txIn;
uart_tx #(.dBits(dBits), .sbTicks(sbTicks)) transmitter (
.clk(clk),
.resetn(resetn),
.txStart(~txEmpty), 
.sTick(tick),
.dataIn(txIn),
.txDone(txTick),
.tx(tx)
);

FIFO txFIFO (
  .clk(clk),                  // input wire clk
  .srst(~resetn),                // input wire srst
  .din(writeData),                  // input wire [7 : 0] din
  .wr_en(writeUART),              // input wire wr_en
  .rd_en(txTick),              // input wire rd_en
  .dout(txIn),                // output wire [7 : 0] dout
  .full(txFull),                // output wire full
  .empty(txEmpty)             // output wire empty
);

endmodule
