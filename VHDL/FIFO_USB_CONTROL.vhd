-----------------------------------------------------------------------------
-- Title           : Title
-----------------------------------------------------------------------------
-- Author          : Daniel Pelikan
-- Date Created    : 20-07-2014
-----------------------------------------------------------------------------
-- Description     : Controls the interplay between FiFo and FT245
--							
--
-----------------------------------------------------------------------------
-- Copyright 2014. All rights reserved
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity FIFO_USB_CONTROL is
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
		data_in	:	in std_logic_vector(7 downto 0);
		reset		: 	in std_logic;	-- low for reset
		
		
		
	   rdclk : out std_logic;
		rdreq : out std_logic;
		wrclk : out std_logic;
		wrreq : out std_logic;
		
		wrclk_in : in std_logic;
		rdempty : in std_logic;
		wrfull : in std_logic
		
	);

end entity;

architecture rtl of FIFO_USB_CONTROL is

signal read_data : std_logic; -- put high if you want to read data
signal data_out	:	std_logic_vector(7 downto 0);
signal data_av	:	std_logic;	-- data is available to be written to USB
signal WR_int : std_logic;

component ft245_control 
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
end component;

begin
ft245_cnt : ft245_control 
--   generic map( 
--   cpol_level => cpol_level
--   )
   port map(
      FT_CLK        	=>      FT_CLK,
      TXE            =>      TXE,
      RXF        		=>      RXF,
      RD        		=>      RD,
      OE       		=>      OE,
      WR      			=>      WR_int,
      FT_INOUT       =>      FT_INOUT,
      data_av       	=>      data_av,
      data_in      	=>      data_in,
      data_out    	=>      data_out,
      reset    		=>      reset,
      read_data      =>      read_data       
 
   );


	--route some signal through
	read_data<='0';
	wrclk<=wrclk_in;
	rdclk<=FT_CLK;
	
	wrreq<='1' WHEN wrfull = '0' ELSE '0';
	rdreq<='1' when (WR_int = '0' and rdempty = '0') else '0';
	data_av<= '1' when rdempty = '0' else '0';
	
	WR<=WR_int;


--	FIFO_USB_CONTROL_process: process(clk, reset) 
--	begin
--		if(reset='1') then
--
--		elsif(rising_edge(clk)) then 
--		
--		end if;
--	end process FIFO_USB_CONTROL_process;
	
end rtl;


