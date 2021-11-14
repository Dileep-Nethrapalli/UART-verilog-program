`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS 
// Engineer: Dileep Nethrapalli 
// 
// Create Date: 10.07.2020 17:42:43
// Design Name: 
// Module Name: Keyboard_top
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


module UART_top(
         output AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0,
         output CA, CB, CC, CD, CE, CF, CG, DP, 
         output RXD, 
         input  TXD, Clock_100MHz, Reset_n);
         
         wire clock_10Khz;
         wire [7:0]  uart_data; 
         
  UART_Receiver uart_rx_DUT(
      .UART_Data(uart_data), .TXD(TXD),
      .clock_10KHz(clock_10Khz), .Reset_n(Reset_n)); 
                                                         
                        
  UART_Transmitter uart_tx_DUT(
      .RXD(RXD), .clock_10KHz(clock_10Khz),
      .Reset_n(Reset_n));   
                                                            
                                 
  Clock_10KHz clk_10KHz_DUT(
       .clock_10KHz(clock_10Khz), 
       .Clock_100MHz(Clock_100MHz), .Reset_n(Reset_n));                                                                          
     

  BCH_to_7_segment_LED_Decoder bch_to_7_seg_LED_DUT (
     .DP(DP),
     .Cathodes({CA,CB,CC,CD,CE,CF,CG}), 
     .Anodes({AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0}),                  
     .Clock_100MHz(Clock_100MHz), .Enable(1'b1),
     .Clear_n(Reset_n), .In(uart_data));

endmodule
