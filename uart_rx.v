`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2023 01:49:44
// Design Name: 
// Module Name: uart_rx
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


module uart_rx #(parameter dBits = 8, sbTicks = 16) (
input clk, resetn,
input rx, sTick,
output reg rxDone,
output [dBits-1:0] rxOut
);
    
localparam idle = 0, start = 1, data = 2, stop = 3;

reg [1:0] state, stateNext;
reg [3:0] s, sNext;
reg [$clog2(dBits)-1:0] n, nNext;
reg [dBits-1:0] temp, tempNext;

always @(posedge clk, negedge resetn)
begin
    if(~resetn)
        begin
            state <= idle;
            s <= 0;
            n <= 0;
            temp <= 0;
        end
    else
        begin
            state <= stateNext;
            s <= sNext;
            n <= nNext;
            temp <= tempNext;
        end
end

always @(*)
begin
    stateNext = state;
    sNext = s;
    nNext = n;
    tempNext = temp;
    rxDone = 1'b0;
    case(state)
        idle:
            if(~rx)
                begin
                    sNext = 0;
                    stateNext = start;
                end
        start:
            if(sTick)
                if(s == 7)
                    begin
                        sNext = 0;
                        nNext = 0;
                        stateNext = data;
                    end
                else
                    sNext = s+1;
        data:
            if(sTick)
                if(s == 15)
                    begin
                        sNext = 0;
                        tempNext = {rx, temp[dBits-1:1]};
                        if(n == dBits-1)
                            stateNext = stop;
                        else
                            nNext = n+1;
                    end
                else
                    sNext = s+1;
        stop:
             if(sTick)
                if(s==sbTicks-1)
                    begin
                        rxDone = 1'b1;
                        stateNext = idle;
                    end
                else
                    sNext = s+1;
        default:
             stateNext = idle;
    endcase
end
assign rxOut = temp;
endmodule
