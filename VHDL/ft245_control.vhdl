-----------------------------------------------------------------------------
-- Title           : Title
-----------------------------------------------------------------------------
-- Author          : Daniel Pelikan
-- Date Created    : xx-xx-2014
-----------------------------------------------------------------------------
-- Description     : Description
--							
--
-----------------------------------------------------------------------------
-- Copyright 2014. All rights reserved
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ft245_control is
--  generic (
--    g_Variable : integer := 10    
--    );
	port 
	(
      FT_CLK   : in std_logic;                     -- 60 MHz FT232H clock
      TXE      : in std_logic;                     -- Can TX
      RXF      : in std_logic;                     -- Can RX
      RD      : out std_logic;                     -- Read -- low to be able to read
      --SIWU      : out std_logic;                     -- Send Immediate / WakeUp
      OE      : out std_logic;                     -- Output enable, high to write to USB
      WR      : out std_logic;                  -- FIFO Buffer Write Enable, low to write to usb
      FT_INOUT      : inout std_logic_vector(7 downto 0);   -- Bidirectional FIFO data
		
	
		data_av	:	in std_logic;	-- data is available to be written to USB
		data_in	:	in std_logic_vector(7 downto 0);
		data_out	:	out std_logic_vector(7 downto 0);
		reset		: 	in std_logic;	-- low for reset
		read_data : in std_logic -- put high if you want to read data
		
	);

end entity;

architecture MOORE of ft245_control is

--	signal tmp : std_logic := 0 ;
--	constant const    : std_logic_vector(3 downto 0) := "1000";



type state_type is (SM_Idle,SM_Next_isWrite,SM_Write,SM_Next_isRead, SM_Read);
signal current_state, next_state : state_type;

signal counter : std_logic_vector (3 downto 0) := "0000";
signal int_RD, int_WR, int_OE : std_logic;
signal int_FT_INOUT : std_logic_vector(7 downto 0) := "00000000";
signal countup : std_logic :='0';


begin
	P0:process(current_state,data_av,TXE,RXF,read_data)
	begin
		case current_state is
		
			when SM_Idle =>	
				if(data_av='1' and TXE ='0') then -- what happens if read is also high?
					next_state<=SM_Next_isWrite;
					
				elsif (read_data='1' and RXF = '0') then
					next_state<=SM_Next_isRead;
					
				else
					next_state<=SM_Idle;
				end if;
				
			when SM_Next_isWrite =>
					next_state<=SM_Write;
					
			when SM_Write =>
					-- put here a mode to stay in write mode if more data is available
				if(data_av='1' and TXE ='0' and read_data='0') then
					next_state<=SM_Write;
				else
					next_state<=SM_Idle;
				end if;
			
			when SM_Next_isRead =>
				next_state<=SM_Read;
				
			when SM_Read =>
				-- put here a mode to stay in read mode if more data is available
				next_state<=SM_Idle;

			when others => next_state<= SM_Idle;
		end case;
	end process;

	
	P1: process(FT_CLK,reset)
	begin
		if reset='0' then
			current_state<=SM_Idle;	
		elsif rising_edge(FT_CLK) then
				current_state<=next_state;
				if (countup='1') then
					counter<=counter+1;
					int_FT_INOUT<="0011" & counter;--data_in;
				end if;	
		end if;
	end process;

	P2:process(current_state,counter,FT_INOUT,TXE,RXF)
	begin
		
		
		case current_state is
			when SM_Idle=> 				int_RD<='1';
												int_OE<='1';
												int_WR<='1';
												countup<='0';
												

							
			when SM_Next_isWrite => 	int_RD<='1';
												int_OE<='1';
												int_WR<='1';
												countup<='0';												
												--int_FT_INOUT<="0011" & counter;--data_in;
												
												
			when SM_Write => 				int_RD<='1';
												int_OE<='1';
												countup<='1';
												if(TXE ='0') then 
													int_WR<='0'; -- the WR low can be used to trigger that the next byte is load into data_in
												else 
													int_WR<='1';
												end if;	
												
												
			when SM_Next_isRead => 		int_RD<='1';
												int_OE<='0';
												int_WR<='1';
												countup<='0';
												--int_FT_INOUT <= (others =>'Z');
												--data_out <= FT_INOUT;
												
												
			
			when SM_Read =>  				
												int_OE<='0';
												int_WR<='1';
												countup<='0';
												--int_FT_INOUT <= (others =>'Z');
												if(RXF = '0') then
													int_RD<='0';
												else	
													int_RD<='1';
												end if;	
												--data_out <= FT_INOUT;
												
			

									
							
		end case;
	end process;
	
	--Make available to the outside
	RD<=int_RD;
	WR<=int_WR;
	OE<=int_OE;
	FT_INOUT<=int_FT_INOUT;
	data_out <= FT_INOUT;
end MOORE;




















------------------------------------------------------
--
-------------------------------------------------------------------------------
---- Title           : Title
-------------------------------------------------------------------------------
---- Author          : Daniel Pelikan
---- Date Created    : xx-xx-2014
-------------------------------------------------------------------------------
---- Description     : Works for TX
----							
----
-------------------------------------------------------------------------------
---- Copyright 2014. All rights reserved
-------------------------------------------------------------------------------
--
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
--
--entity ft245_control is
----  generic (
----    g_Variable : integer := 10    
----    );
--	port 
--	(
--      FT_CLK   : in std_logic;                     -- 60 MHz FT232H clock
--      TXE      : in std_logic;                     -- Can TX
--      RXF      : in std_logic;                     -- Can RX
--      RD      : out std_logic;                     -- Read -- low to be able to read
--      --SIWU      : out std_logic;                     -- Send Immediate / WakeUp
--      OE      : out std_logic;                     -- Output enable, high to write to USB
--      WR      : out std_logic;                  -- FIFO Buffer Write Enable, low to write to usb
--      FT_INOUT      : inout std_logic_vector(7 downto 0);   -- Bidirectional FIFO data
--		
--	
--		data_av	:	in std_logic;	-- data is available to be written to USB
--		data_in	:	in std_logic_vector(7 downto 0);
--		data_out	:	out std_logic_vector(7 downto 0);
--		reset		: 	in std_logic;	-- low for reset
--		read_data : in std_logic -- put high if you want to read data
--		
--	);
--
--end entity;
--
--architecture MOORE of ft245_control is
--
----	signal tmp : std_logic := 0 ;
----	constant const    : std_logic_vector(3 downto 0) := "1000";
--
--
--
--type state_type is (SM_Idle,SM_Next_isWrite,SM_Write,SM_Next_isRead, SM_Read);
--signal current_state, next_state : state_type;
--
--signal counter : std_logic_vector (3 downto 0) := "0000";
--signal int_RD, int_WR, int_OE : std_logic;
--signal int_FT_INOUT : std_logic_vector(7 downto 0) := "00000000";
--signal countup : std_logic :='0';
--
--
--begin
--	P0:process(current_state,data_av,TXE,RXF,read_data)
--	begin
--		case current_state is
--		
--			when SM_Idle =>	
--				if(data_av='1' and TXE ='0') then -- what happens if read is also high?
--					next_state<=SM_Next_isWrite;
--					
--				elsif (read_data='1' and RXF = '0') then
--					next_state<=SM_Next_isRead;
--					
--				else
--					next_state<=SM_Idle;
--				end if;
--				
--			when SM_Next_isWrite =>
--					next_state<=SM_Write;
--					
--			when SM_Write =>
--					-- put here a mode to stay in write mode if more data is available
--					next_state<=SM_Idle;
--			
--			when SM_Next_isRead =>
--				next_state<=SM_Read;
--				
--			when SM_Read =>
--				-- put here a mode to stay in read mode if more data is available
--				next_state<=SM_Idle;
--
--			when others => next_state<= SM_Idle;
--		end case;
--	end process;
--
--	
--	P1: process(FT_CLK,reset)
--	begin
--		if reset='0' then
--			current_state<=SM_Idle;	
--		elsif rising_edge(FT_CLK) then
--				current_state<=next_state;
--				if (countup='1') then
--					counter<=counter+1;
--					int_FT_INOUT<="0011" & counter;--data_in;
--				end if;	
--		end if;
--	end process;
--
--	P2:process(current_state,counter,FT_INOUT,TXE,RXF)
--	begin
--		
--		
--		case current_state is
--			when SM_Idle=> 				int_RD<='1';
--												int_OE<='1';
--												int_WR<='1';
--												countup<='0';
--												
--
--							
--			when SM_Next_isWrite => 	int_RD<='1';
--												int_OE<='1';
--												int_WR<='1';
--												countup<='0';												
--												--int_FT_INOUT<="0011" & counter;--data_in;
--												
--												
--			when SM_Write => 				int_RD<='1';
--												int_OE<='1';
--												countup<='1';
--												if(TXE ='0') then 
--													int_WR<='0'; -- the WR low can be used to trigger that the next byte is load into data_in
--												else 
--													int_WR<='1';
--												end if;	
--												
--												
--			when SM_Next_isRead => 		int_RD<='1';
--												int_OE<='0';
--												int_WR<='1';
--												countup<='0';
--												--int_FT_INOUT <= (others =>'Z');
--												--data_out <= FT_INOUT;
--												
--												
--			
--			when SM_Read =>  				
--												int_OE<='0';
--												int_WR<='1';
--												countup<='0';
--												--int_FT_INOUT <= (others =>'Z');
--												if(RXF = '0') then
--													int_RD<='0';
--												else	
--													int_RD<='1';
--												end if;	
--												--data_out <= FT_INOUT;
--												
--			
--
--									
--							
--		end case;
--	end process;
--	
--	--Make available to the outside
--	RD<=int_RD;
--	WR<=int_WR;
--	OE<=int_OE;
--	FT_INOUT<=int_FT_INOUT;
--	data_out <= FT_INOUT;
--end MOORE;
--

