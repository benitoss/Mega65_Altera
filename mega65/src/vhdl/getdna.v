`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Aim.Systems
// Engineer: Joss Bird
// 
// Create Date: 03/31/2023 02:59:28 PM
// Design Name: Have fun :)
// Module Name: dna_check
// Project Name: aim-systems-zynq-fpga
// Target Devices: AX7015
// Tool Versions: Vivado 2023.1
// Description:  I copy paste from UnknownCheats 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
 
 
module dna_check(
    input clk,
    input [56:0] expected_dna,
    output reg match
);
    
    reg running;
    reg [6:0] current_bit; // 0 - 63
    wire expected_dna_bit = expected_dna[56 - current_bit];
    wire dna_bit;
    
    reg dna_shift;
    reg dna_read;
    
    reg first;
    
    initial begin
        
        match <= 0;
        dna_shift <= 0;
        dna_read <= 0;
        current_bit <= 0;
        first <= 1;
        running <= 1;
    end
 
    DNA_PORT #(
        .SIM_DNA_VALUE  (57'h028340E18D8C85C)
    ) dna (
        .DOUT(dna_bit),
        .CLK(clk),
        .DIN(0), // Rollover
        .READ(dna_read),
        .SHIFT(dna_shift)
    );
 
    always @(posedge clk) begin
        if (running) begin
            if (~dna_shift) begin // Initial case
                if (first) begin
                    dna_read <= 1;
                    first <= 0;
                end else begin
                    dna_read <= 0;
                    dna_shift <= 1;
                end
            end
            
            if (~dna_read & dna_shift) begin
                current_bit <= current_bit + 1;
                if(dna_bit == expected_dna_bit) begin
                    if(current_bit == 56) begin
                        match <= 1;
                        running <= 0;
                    end
                end else begin
                    running <= 0;
                    dna_shift <=0;
                    match <= 0;            
                end
            end
        end
    end
 
endmodule