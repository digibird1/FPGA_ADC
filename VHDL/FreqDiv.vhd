library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity FreqDiv is
  generic (
    g_DIV : integer := 50000     -- Needs to be set correctly this devides 2 x g_DIV !!!
    );
	port 
	(
		clk		: in std_logic;
		nrst_in	:	in	std_logic;
		q_out		: buffer std_logic := '0' -- initialie the buffer
	);

end entity;

architecture rtl of FreqDiv is

	--variable dVec	: std_logic_vector(2 downto 0);
	signal tmp : integer := 0 ;

begin

	Div_process: process(clk, nrst_in) -- Divide process
	begin
		if(nrst_in='0') then
			tmp<=0; -- on reset set to 0
			q_out<='0';
		elsif(rising_edge(clk)) then --syncrone reset
			--if(nrst_in='0') then
				--tmp<=x"00000000"; -- on reset set to 0
				--q_out<='0';
			--else		
				tmp<= tmp + 2;
			--end if;
			
			if(tmp=g_DIV) then --we devide
				tmp<=0;
				q_out<=not q_out;
			end if;
		
		end if;
	end process Div_process;
end rtl;