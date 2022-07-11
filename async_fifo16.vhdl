--////////////////////////////////////////////////////////////////
--//
--// Project  : async_lib
--// Function : async_fifo16
--// Engineer : Grigory Polushkin
--// Created  : 10.07.2022
--//
--////////////////////////////////////////////////////////////////

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity async_fifo16 is
    port
    (
        W_CLK   : in std_logic;
        DIN     : in std_logic;
        DIN_DV  : in std_logic;
        R_CLK   : in std_logic;
        DOUT    : out std_logic; 
        DOUT_DV : out std_logic 
    );
end async_fifo16;

architecture rtl of async_fifo16 is

    signal r_wr_pointer     : std_logic_vector (3 downto 0) := 4d"1";
    signal r_wr_pointer_g   : std_logic_vector (3 downto 0) := (others => '0');
    signal r_wr_pointer_g1  : std_logic_vector (3 downto 0) := (others => '0');
    signal r_wr_pointer_g2  : std_logic_vector (3 downto 0) := (others => '0');
 
    signal r_rd_pointer     : std_logic_vector (3 downto 0) := 4d"1";
    signal r_rd_pointer_g   : std_logic_vector (3 downto 0) := (others => '0');
 
    signal r_data           : std_logic_vector (15 downto 0) := (others => '0');

    signal r_dout           : std_logic := '0';
    signal r_dout_dv        : std_logic := '0';

    signal w_not_empty      : std_logic;
    signal r_not_equal      : std_logic := '0';

begin

    DOUT_DV <= r_not_equal;
    DOUT <= r_dout;
    w_not_empty <= '0' when r_wr_pointer_g2 = r_rd_pointer_g else '1';

    proc_write:
    process( W_CLK )
    begin
        if( W_CLK'event and W_CLK = '1' ) then
            if( DIN_DV ) then
                r_data( to_integer(unsigned(r_wr_pointer_g))) <= DIN;
                r_wr_pointer   <= r_wr_pointer + '1';
                r_wr_pointer_g <= r_wr_pointer(3) & ( r_wr_pointer(3 downto 1) XOR r_wr_pointer(2 downto 0) );
            end if;
        end if;
    end process;

    proc_read:
    process( R_CLK)
    begin
        if( R_CLK'event and R_CLK = '1' ) then
            if( w_not_empty ) then
                r_rd_pointer   <= r_rd_pointer + '1';
                r_rd_pointer_g <= r_rd_pointer(3) & ( r_rd_pointer(3 downto 1) XOR r_rd_pointer(2 downto 0) );
            end if;
            r_not_equal <= w_not_empty;
            r_dout <= r_data( to_integer(unsigned(r_rd_pointer_g)) );
            r_wr_pointer_g1 <= r_wr_pointer_g;
            r_wr_pointer_g2 <= r_wr_pointer_g1;
    
        end if;
    end process;

end rtl;

