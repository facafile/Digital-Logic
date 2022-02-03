library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- warning: this file will not be saved if:
--     * following entity block contains any syntactic errors (e.g. port list isn't separated with ; character)
--     * following entity name and current file name differ (e.g. if file is named mux41 then entity must also be named mux41 and vice versa)
ENTITY moore IS PORT(
	clk: IN STD_LOGIC;
	rst: IN STD_LOGIC;
	l: IN STD_LOGIC;
	r: IN STD_LOGIC;
	m: OUT STD_LOGIC
);
END moore;

ARCHITECTURE moore1 OF moore IS 
constant s0: std_logic_vector(3 downto 0):="0000";
constant s1: std_logic_vector(3 downto 0):="0001";
constant s2: std_logic_vector(3 downto 0):="0010";
constant s3: std_logic_vector(3 downto 0):="0011";
constant s4: std_logic_vector(3 downto 0):="0100";
constant s5: std_logic_vector(3 downto 0):="0101";
constant s6: std_logic_vector(3 downto 0):="0110";
constant s7: std_logic_vector(3 downto 0):="0111";
constant s8: std_logic_vector(3 downto 0):="1000";
constant s9: std_logic_vector(3 downto 0):="1001";
constant s10: std_logic_vector(3 downto 0):="1010";
constant s11: std_logic_vector(3 downto 0):="1011";
constant s12: std_logic_vector(3 downto 0):="1100";

signal R_state: std_logic_vector(3 downto 0);
signal R_timer: std_logic_vector(1 downto 0);
signal new_state: std_logic_vector(3 downto 0);
signal state_we: std_logic;
BEGIN

process(clk,rst)
begin
	if rst = '1' then
		R_state <= (others => '0');
		R_timer <= (others => '0');
	elsif rising_edge(clk) then
		if state_we = '1' then
			R_state <= new_state;
			
			case new_state is
			
			when  s2 | s5 | s6 | s7 | s9 | s10 | s8 =>
			R_timer <= "00";
			
			when s1 | s3 | s11 =>
			R_timer <= "10";
			
			when s4 | s12 =>
			R_timer <="01";
			
			when others =>
			R_timer <="00";
			end case;
		else
			R_timer <= std_logic_vector(signed(R_timer)-1);
		end if;
	end if;
end process;
process(R_state,R_timer,l,r)
begin
	new_state <= std_logic_vector(signed(R_state)+1);
	state_we <= '1';
	
	case R_state is
	when s0 =>
		m <= '0';
		if l = '0' and r = '0' then
			new_state <= s0;
		end if;
		if r = '1' then
			new_state <= s5; 
		end if;
	when s7 | s5 | s9 =>
		m <= '1';
	when s2 | s8 | s6 | s10 =>
		m <= '0';	
	when s1 | s3 | s11 =>
		m <= '1';
		if R_timer /= "00" then
			state_we <= '0';
		end if;
	when s4 | s12 =>
		m <= '0';
		if R_timer /= "00" then
			state_we <= '0';
		end if;
		new_state <= s0;
	when others =>
		new_state <= s0;
		state_we <= '0';
	end case;
end process;
END moore1;