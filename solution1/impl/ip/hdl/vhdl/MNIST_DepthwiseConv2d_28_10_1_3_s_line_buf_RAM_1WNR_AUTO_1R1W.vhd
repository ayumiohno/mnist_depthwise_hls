-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
-- Tool Version Limit: 2022.04
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
--
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity MNIST_DepthwiseConv2d_28_10_1_3_s_line_buf_RAM_1WNR_AUTO_1R1W is 
    generic(
            MEM_TYPE    : string := "auto"; 
            DataWidth     : integer := 32; 
            AddressWidth     : integer := 5; 
            AddressRange    : integer := 30
    ); 
    port (
          address0     : in std_logic_vector(AddressWidth-1 downto 0); 
          ce0       : in std_logic; 
          d0        : in std_logic_vector(DataWidth-1 downto 0); 
          we0       : in std_logic; 
          q0        : out std_logic_vector(DataWidth-1 downto 0);
          reset      : in std_logic; 
          clk        : in std_logic 
    ); 
end entity; 


architecture rtl of MNIST_DepthwiseConv2d_28_10_1_3_s_line_buf_RAM_1WNR_AUTO_1R1W is 

signal address0_tmp : std_logic_vector(AddressWidth-1 downto 0); 
type mem_array is array (0 to AddressRange-1) of std_logic_vector (DataWidth-1 downto 0); 
shared variable ram0 : mem_array;

attribute syn_ramstyle : string; 
attribute syn_ramstyle of ram0 : variable is "auto";
attribute ram_style : string;
attribute ram_style of ram0 : variable is MEM_TYPE;

begin 


memory_access_guard_0: process (address0) 
begin
      address0_tmp <= address0;
--synthesis translate_off
      if (CONV_INTEGER(address0) > AddressRange-1) then
           address0_tmp <= (others => '0');
      else 
           address0_tmp <= address0;
      end if;
--synthesis translate_on
end process;

p_memory_access_0: process (clk)  
begin 
    if (clk'event and clk = '1') then
        if (ce0 = '1') then 
            q0 <= ram0(CONV_INTEGER(address0_tmp));
            if (we0 = '1') then 
                ram0(CONV_INTEGER(address0_tmp)) := d0; 
            end if;
        end if;
    end if;
end process;


end rtl;
