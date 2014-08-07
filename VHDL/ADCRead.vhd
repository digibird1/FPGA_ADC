-----------------------------------------------------------------------------
-- Title           : Title
-----------------------------------------------------------------------------
-- Author          : Daniel Pelikan
-- Date Created    : 20-07-2014
-----------------------------------------------------------------------------
-- Description     : ADC readout
--							
--
-----------------------------------------------------------------------------
-- Copyright 2014. All rights reserved
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ADCRead is
--  generic (
--    g_Variable : integer := 10    
--    );
	port 
	(
		clk		: in std_logic; -- slowest clock is 3 MHz
		reset	:	in	std_logic;
		ADC_in:	in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(7 downto 0);
		encode	: out std_logic -- ADC triggers on encode raising edge
		
	);

end entity;

architecture rtl of ADCRead is

--	signal tmp : std_logic := 0 ;
--	constant const    : std_logic_vector(3 downto 0) := "1000";

--signal counter : std_logic_vector (3 downto 0) := "0000";

begin

	ADCRead_process: process(clk, reset) 
	begin
		if(reset='0') then
			data_out<="00000000";
		elsif(rising_edge(clk)) then 
			data_out<=ADC_in;
			--data_out<="0011" & counter; -- generate some input
			--counter<=counter+1;
		end if;
	end process ADCRead_process;
	
	encode<= clk;--not clk;
	
end rtl;
