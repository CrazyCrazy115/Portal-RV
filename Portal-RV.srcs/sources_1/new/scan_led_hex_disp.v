`timescale 1ns / 1ps
module scan_led_hex_disp(
    input clk,
    input reset,
    input [3:0] hex0, 
    input [3:0] hex1,
    input [3:0] hex2,
    input [3:0] hex3,
    output reg [3:0] an,   
    output reg [6:0] sseg  
    );

 localparam N = 18;
 reg [N-1:0] regN; 
 reg [3:0] hex_in; 
 
 always@(posedge clk)
 begin
  if(reset)
   regN <= 0;
  else
   regN <= regN + 1;
 end
 
 always@ *
 begin
  case(regN[N-1:N-2])
  2'b00:begin
   an = 4'b0001; 
   hex_in = hex0; 
  end
  2'b01:begin
   an = 4'b0010; 
   hex_in = hex1;
  end
  2'b10:begin
   an = 4'b0100;
   hex_in = hex2;
  end
  default:begin
   an = 4'b1000;
   hex_in = hex3;
  end
  
  endcase
 
 end
 always@ *
 begin
  case(hex_in)
   4'h0: sseg[6:0] = ~7'b0000001; 
   4'h1: sseg[6:0] = ~7'b1001111;
   4'h2: sseg[6:0] = ~7'b0010010;
   4'h3: sseg[6:0] = ~7'b0000110;
   4'h4: sseg[6:0] = ~7'b1001100;
   4'h5: sseg[6:0] = ~7'b0100100;
   4'h6: sseg[6:0] = ~7'b0100000;
   4'h7: sseg[6:0] = ~7'b0001111;
   4'h8: sseg[6:0] = ~7'b0000000;
   4'h9: sseg[6:0] = ~7'b0000100;
   4'ha: sseg[6:0] = ~7'b0001000;
   4'hb: sseg[6:0] = ~7'b1100000;
   4'hc: sseg[6:0] = ~7'b0110001; 
   4'hd: sseg[6:0] = ~7'b1000010;
   4'he: sseg[6:0] = ~7'b0110000;
   default: sseg[6:0] = ~7'b0111000;
  endcase
 end
endmodule
