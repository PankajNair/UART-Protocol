`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2023 03:43:08
// Design Name: 
// Module Name: uart_tx
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


module uart_tx #(parameter dBits = 8, sbTicks = 16) (
input clk, resetn,
input txStart, sTick,
input [dBits-1:0] dataIn,
output reg txDone,
output tx
);
    
localparam idle = 0, start = 1, data = 2, stop = 3;

reg [1:0] state, stateNext;
reg [3:0] s, sNext;
reg [$clog2(dBits)-1:0] n, nNext;
reg [dBits-1:0] temp, tempNext;
reg txReg, txNext;

always @(posedge clk, negedge resetn)
begin
    if(~resetn)
        begin
            state <= idle;
            s <= 0;
            n <= 0;
            temp <= 0;
            txReg <= 1'b1;
        end
    else
        begin
            state <= stateNext;
            s <= sNext;
            n <= nNext;
            temp <= tempNext;
            txReg <= txNext;
        end
end

always @(*)
begin
    stateNext = state;
    sNext = s;
    nNext = n;
    tempNext = temp;
    txDone = 1'b0;
    case(state)
        idle:
            begin
                txNext = 1'b1;
                if(txStart)
                    begin
                        sNext = 0;
                        tempNext = dataIn;
                        stateNext = start;
                    end
            end
        start:
            begin
                txNext = 1'b0;
                if(sTick)
                    if(s == 15)
                        begin
                            sNext = 0;
                            nNext = 0;
                            stateNext = data;
                        end
                    else
                        sNext = s+1;
             end
        data:
            begin
                txNext = temp[0];
                if(sTick)
                    if(s == 15)
                        begin
                            sNext = 0;
                            tempNext = {1'b0, temp[dBits-1:1]};
                            if(n == dBits-1)
                                stateNext = stop;
                            else
                                nNext = n+1;
                        end
                    else
                        sNext = s+1;
            end
        stop:
            begin
                txNext = 1'b1;
                 if(sTick)
                    if(s == sbTicks-1)
                        begin
                            txDone = 1'b1;
                            stateNext = idle;
                        end
                    else
                        sNext = s+1;
            end
        default:
             stateNext = idle;
    endcase
end
endmodule
