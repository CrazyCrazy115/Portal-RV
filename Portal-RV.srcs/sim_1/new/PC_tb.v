`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/12/26 18:46:49
// Design Name:
// Module Name: PC_tb
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


module PC_tb(

       );
// Inputs
    reg clk;
    reg rst;
    reg stall;
    reg b_cond;
    reg [31:0] d_next_pc;

    // Outputs
    wire [31:0] pc;

    // Instantiate the Unit Under Test (UUT)
    PC uut (
        .clk(clk), 
        .rst(rst), 
        .stall(stall), 
        .b_cond(b_cond), 
        .d_next_pc(d_next_pc), 
        .pc(pc)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        stall = 0;
        b_cond = 0;
        d_next_pc = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Release global reset
        rst = 1;
        #100;
        rst = 0;
        #100;

        // Test Case 1: Check if PC holds its value when stall is high
        stall = 1;
        #100;
        stall = 0;
        #100;

        // Test Case 2: Check if PC gets the value of d_next_pc when b_cond is high
        b_cond = 1;
        d_next_pc = 32'hDEADBEEF;
        #100;
        b_cond = 0;
        d_next_pc = 0;
        #100;

        // Test Case 3: Check if PC increments by 4 when both stall and b_cond are low
        #100;

        // Add more test cases as needed

        // Finish the simulation
        $finish;
    end
      
    // Generate a clock with a period of 20ns
    always #10 clk = ~clk;

endmodule
