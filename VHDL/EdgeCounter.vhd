-----------------------------------------------------------------------------
-- Title           : Title
-----------------------------------------------------------------------------
-- Author          : Daniel Pelikan
-- Date Created    : xx-xx-2014
-----------------------------------------------------------------------------
-- Description     : This code counts raising edges and displays it with help of the numerical display
--							It can count from 0 to 8192 using 13 bits
--							
--
-----------------------------------------------------------------------------
-- Copyright 2014. All rights reserved
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity EdgeCounter is
--  generic (
--    g_Variable : integer := 10    
--    );
	port 
	(
		clk		: in std_logic;
		reset	:	in	std_logic;
		
		ones : out std_logic_vector(3 downto 0);
		tens : out std_logic_vector(3 downto 0);
		hundrets : out std_logic_vector(3 downto 0);
		thousands : out std_logic_vector(3 downto 0)
		
	);

end entity;

architecture rtl of EdgeCounter is

	

--	constant const    : std_logic_vector(3 downto 0) := "1000";

begin

	EdgeCounter_process: process(clk, reset)
	variable int_ones : std_logic_vector(3 downto 0) := "0000";
	variable int_tens : std_logic_vector(3 downto 0) := "0000";
	variable int_hundrets : std_logic_vector(3 downto 0) := "0000";
	variable int_thousands : std_logic_vector(3 downto 0) := "0000";
	begin
		if(reset='0') then
			int_ones:="0000";
			int_tens:="0000";
			int_hundrets:="0000";
			int_thousands:="0000";

		elsif(rising_edge(clk)) then 
			
			int_ones:=int_ones+1;
			
			if(int_ones = 10) then
				int_tens:=int_tens+1;
				int_ones:="0000";
			end if;
			
			if(int_tens = 10) then
				int_hundrets:=int_hundrets+1;
				int_tens:="0000";
			end if;
			
			if(int_hundrets = 10) then
				int_thousands:=int_thousands+1;
				int_hundrets:="0000";
			end if;
			
			if(int_thousands = 10) then
				int_thousands:="0000";
			end if;
			
			ones<=int_ones;
			tens<=int_tens;
			hundrets<=int_hundrets;
			thousands<=int_thousands;
			
		end if;
	end process EdgeCounter_process;
	

	
end rtl;

---name_of_std_logic_vector <= conv_integer(Name_of_integer, NumberOfBits)
