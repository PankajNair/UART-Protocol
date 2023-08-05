`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.08.2023 23:10:01
// Design Name: 
// Module Name: timer
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


module timer #(parameter bits = 4) (
input clk, resetn, enable,
input [bits-1:0] finalValue,
output done
);
    
reg [bits-1:0] Q, Qnext;

always @(posedge clk, negedge resetn)
begin
    if(~resetn)
        Q <= 0;
    else if(enable)
        Q <= Qnext;
    else
        Q <= Q;        
end

always @(*)
begin
    Qnext = (done)?'b0:Q+1;
end

assign done = (Q == finalValue);

endmodule
