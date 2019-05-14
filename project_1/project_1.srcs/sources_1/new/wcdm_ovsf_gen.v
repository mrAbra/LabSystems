`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2019 12:46:13
// Design Name: 
// Module Name: wcdma_ovsf_gen
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



 module ovsf_gen #
 (
 )
 (
     input ACLK,
     input ARST,
     //axis
     input S_AXIS_CONFIG_TVALID,
     input [15:0] S_AXIS_CONFIG_TDATA,
     //axim
     output M_AXIS_DATA_TVALID,
     output M_AXIS_DATA_TREADY,
     output M_AXIS_DATA_TLAST,
     output [8:0] M_AXIS_DATA_TDATA
     );
 /******************************************************************
     S_AXIS_CONFIG_TDATA[15:12] - reserved
     S_AXIS_CONFIG_TDATA[11:9] -  SF: 0 - 4, 1 - 8, 2 - 16,
    3 - 32, 4 - 64, 5 - 128, 6 - 256, 7 - 512;
    S_AXIS_CONFIG_TDATA[8..0] биты - номер OVSF кода, принимает
    значения в диапазоне от 0 до (SF - 1)
   
  *******************************************************************/ 
  
  logic [2:0]   SF = 0;
  logic [8:0]   K  = 0;
  logic [8:0]   count = 0;
  
  
  /**********************************************
                        ARST 0  1
    S_AXIS_CONFIG_TVALID 
             0               0  0 
             1               0  1
  ***********************************************/
/*  always @(ARST or S_AXIS_CONFIG_TVALID)
    begin
        rst = (ARST ? S_AXIS_CONFIG_TVALID ? 1 : 0 : 0); 
    end*/
  
  //SF decoder
     always @(posedge ACLK or negedge ARST)
        begin
            if(!ARST)
                begin
                   SF <= 0; 
                end
             else
                begin
                    case(S_AXIS_CONFIG_TDATA[11:9])
                        3'b000  : SF <= 3;
                        3'b001  : SF <= 7;
                        3'b010  : SF <= 16;
                        3'b011  : SF <= 31;
                        3'b100  : SF <= 63;
                        3'b101  : SF <= 127;
                        3'b110  : SF <= 255;
                        3'b111  : SF <= 511;
                        default : SF <= 0;
                     endcase
                end
        end
        
 //Code generetor counter. 1 posedge clk => 1 code point       
     always @(posedge ACLK or negedge ARST)
        begin
            if(!ARST)
                begin
                    count <= 0;
                end
             else if(count == SF)
                begin
                    count <= 0;
                end
             else
                begin
                    count <= count + 1;    
                end  
        end
    
  //K Decoder 
  always @(posedge ACLK or negedge ARST)
     begin
         if(!ARST)
             begin
                SF <= 0; 
             end
          else
             begin
                 case(SF)
                     3'b000  : K <= {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,K[0],K[1]};
                     3'b001  : K <= {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,K[0],K[1],K[2]};
                     3'b010  : K <= {1'b0,1'b0,1'b0,1'b0,1'b0,K[0],K[1],K[2],K[3]};
                     3'b011  : K <= {1'b0,1'b0,1'b0,1'b0,K[0],K[1],K[2],K[3],K[4]};
                     3'b100  : K <= {1'b0,1'b0,1'b0,K[0],K[1],K[2],K[3],K[4],K[5]};
                     3'b101  : K <= {1'b0,1'b0,K[0],K[1],K[2],K[3],K[4],K[5],K[6]};
                     3'b110  : K <= {1'b0,K[0],K[1],K[2],K[3],K[4],K[5],K[6],K[7]};
                     3'b111  : K <= {K[0],K[1],K[2],K[3],K[4],K[5],K[6],K[7],K[8]};
                     default : K <= 0;
                  endcase
             end
     end
  
 assign M_AXIS_DATA_TDATA[0] = ^(K & count);
 
 //Cheak LW
 
 
 //cheak DataValid  
 endmodule
 

