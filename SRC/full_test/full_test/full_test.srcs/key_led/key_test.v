//===========================================================================
// Module name: key_test.v
// ����: ��⿪�����ϵ��ĸ�����KEY1~KEY4, ����⵽��������ʱ,��Ӧ��LED�Ʒ�ת
//===========================================================================
`timescale 1ns / 1ps
module key_test  (
                     input          sys_clk,                      // �������ϲ������ʱ��P: 200Mhz
					 input		    rst_n,                        // �����壨���İ壩�����븴λ����
					 input	[3:0]	key_in,                       // �װ������밴���ź�(KEY1~KEY4)
					 output         key1_flag,
					 output         key2_flag,
					 output         key3_flag,
                     output         key4_flag,					 
					 output	[3:0]	led_out                       // ���LED��,���ڿ��ƿ��������ĸ�LED(LED1~LED4)
						);

	
//�Ĵ�������
reg [23:0] count;
reg [3:0] key_scan; //����ɨ��ֵKEY



//===========================================================================
// ��������ֵ��20msɨ��һ��,����Ƶ��С�ڰ���ë��Ƶ�ʣ��൱���˳����˸�Ƶë���źš�
//===========================================================================
always @(posedge sys_clk or negedge rst_n)     //���ʱ�ӵ������غ͸�λ���½���
begin
   if(!rst_n)                //��λ�źŵ���Ч
      count <= 24'd0;        //��������0
   else
      begin
         if(count ==24'd3_999_999)   //20msɨ��һ�ΰ���,20ms����(200M/50-1=3_999_999)
            begin
               count <= 24'b0;     //�������Ƶ�20ms������������
               key_scan <= key_in; //�������������ƽ
            end
         else
            count <= count + 24'b1; //��������1
     end
end
//===========================================================================
// �����ź�����һ��ʱ�ӽ���
//===========================================================================
reg [3:0] key_scan_r;
always @(posedge sys_clk)
    key_scan_r <= key_scan;       
    
wire [3:0] flag_key = key_scan_r[3:0] & (~key_scan[3:0]);  //����⵽�������½��ر仯ʱ�������ð��������£�������Ч 

//===========================================================================
// LED�ƿ���,��������ʱ,��ص�LED�����ת
//===========================================================================
reg [3:0] temp_led;
always @ (posedge sys_clk or negedge rst_n)      //���ʱ�ӵ������غ͸�λ���½���
begin
    if (!rst_n)                 //��λ�źŵ���Ч
         temp_led <= 4'b1111;   //LED�ƿ����ź����Ϊ��, LED��ȫ��
    else
         begin            
             if ( flag_key[0] ) temp_led[0] <= ~temp_led[0];   //����KEY1ֵ�仯ʱ��LED1��������ת
             if ( flag_key[1] ) temp_led[1] <= ~temp_led[1];   //����KEY2ֵ�仯ʱ��LED2��������ת
             if ( flag_key[2] ) temp_led[2] <= ~temp_led[2];   //����KEY3ֵ�仯ʱ��LED3��������ת
             if ( flag_key[3] ) temp_led[3] <= ~temp_led[3];   //����KEY4ֵ�仯ʱ��LED4��������ת
         end
end
 
 assign key1_flag =  temp_led[0];
 assign key2_flag =  temp_led[1]; 
 assign key3_flag =  temp_led[2]; 
 assign key4_flag =  temp_led[3]; 
 
 assign led_out[0] = temp_led[0];
 assign led_out[1] = temp_led[1];
 assign led_out[2] = temp_led[2];
 assign led_out[3] = temp_led[3];
            
endmodule