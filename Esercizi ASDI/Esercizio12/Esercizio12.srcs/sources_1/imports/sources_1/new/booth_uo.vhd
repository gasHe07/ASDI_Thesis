library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity boot_uo is
    port( 
        X, Y      : in  std_logic_vector(3 downto 0);
        clock     : in  std_logic;
        reset     : in  std_logic;

        loadAQ    : in  std_logic;
        shift     : in  std_logic;
        loadM     : in  std_logic;
        sub       : in  std_logic;
        selM      : in  std_logic;
        selAQ     : in  std_logic;
        selF      : in  std_logic;
        count_in  : in  std_logic;

        count     : out std_logic_vector(1 downto 0);
        q0        : out std_logic;
        q_1       : out std_logic;
        P         : out std_logic_vector(7 downto 0)
    );
end boot_uo;


architecture structural of boot_uo is

    signal Mreg       : std_logic_vector(3 downto 0);
    signal op2        : std_logic_vector(3 downto 0);
    signal AQ_init    : std_logic_vector(7 downto 0);
    signal AQ_in      : std_logic_vector(7 downto 0);
    signal AQ_out     : std_logic_vector(7 downto 0);
    signal temp_d     : std_logic := '0';
    signal temp_F     : std_logic := '0';
    signal sum        : std_logic_vector(3 downto 0);
    signal AQ_sum_in  : std_logic_vector(7 downto 0); 
    signal riporto    : std_logic;
    signal SRserialIn : std_logic;

begin

    --------------------------------------------------------------------
    -- Registro M
    --------------------------------------------------------------------
    M: entity work.registro8
        port map(
            A    => Y,
            clk  => clock,
            res  => reset,
            load => loadM,
            B    => Mreg
        );

    --------------------------------------------------------------------
    -- Mux M/0
    --------------------------------------------------------------------
    MUX_molt: entity work.mux_21
        generic map(width => 4)
        port map(
            x0 => (others => '0'),
            x1 => Mreg,
            s  => selM,
            y  => op2
        );

    --------------------------------------------------------------------
    -- Ingressi paralleli dello shift register
    --------------------------------------------------------------------
    AQ_init   <= "0000" & X;
    AQ_sum_in <= sum & AQ_out(3 downto 0);

    MUX_SR_parallel_in: entity work.mux_21
        generic map(width => 8)
        port map(
            x0 => AQ_init,
            x1 => AQ_sum_in,
            s  => selAQ,
            y  => AQ_in
        );

    --------------------------------------------------------------------
    -- Flip-Flop F (Q-1)
    --------------------------------------------------------------------
    temp_d <= (Mreg(3) and AQ_out(0)) or temp_F;

    D: entity work.FFD
        port map(
            clock => clock,
            reset => reset,
            d     => temp_d,
            y     => temp_F
        );

    SRserialIn <= temp_F when selF = '0' else AQ_out(7);

    --------------------------------------------------------------------
    -- Shift register A.Q (8 bit)
    --------------------------------------------------------------------
    SR: entity work.shift_register
        port map(
            parallel_in  => AQ_in,
            serial_in    => SRserialIn,
            clock        => clock,
            reset        => reset,
            load         => loadAQ,
            shift        => shift,
            parallel_out => AQ_out
        );

    --------------------------------------------------------------------
    -- Sommatore/Sottrattore
    --------------------------------------------------------------------
    ADD_SUB: entity work.adder_sub
        port map(
            X    => AQ_out(7 downto 4),
            Y    => op2,
            cin  => sub,
            Z    => sum,
            cout => riporto
        );

    --------------------------------------------------------------------
    -- Contatore
    --------------------------------------------------------------------
    CONT: entity work.cont_mod8
        port map(
            clock    => clock,
            reset    => reset,
            count_in => count_in,
            count    => count
        );

    --------------------------------------------------------------------
    -- Uscite
    --------------------------------------------------------------------
    P   <= AQ_out;
    q0  <= AQ_out(0);
    q_1 <= temp_F;

end structural;
