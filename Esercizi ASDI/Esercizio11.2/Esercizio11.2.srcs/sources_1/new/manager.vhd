library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity manager is
    Port ( 
        clk, r : in std_logic;

        -- bit 10 = enable, [9:7] = src, [6:4] = dest, [3:0] = payload (4 bit)
        A0, A1, A2, A3, A4, A5, A6, A7 : in std_logic_vector(10 downto 0);

        -- verso la omega_network
        s, d : out std_logic_vector(2 downto 0);
        i0, i1, i2, i3, i4, i5, i6, i7 : out std_logic_vector(3 downto 0)
    );
end manager;

architecture Behavioral of manager is

    --------------------------------------------------------------------
    -- FSM
    --------------------------------------------------------------------
    type state_t is (IDLE, READ, DISPATCH);
    signal state : state_t := IDLE;

    --------------------------------------------------------------------
    -- Tipi per i buffer FIFO (4 locazioni per 8 destinazioni)
    --------------------------------------------------------------------
    type fifo_payload_t       is array(0 to 3) of std_logic_vector(3 downto 0);
    type fifo_src_t           is array(0 to 3) of std_logic_vector(2 downto 0);
    type fifo_payload_array_t is array(0 to 7) of fifo_payload_t;
    type fifo_src_array_t     is array(0 to 7) of fifo_src_t;

    signal buf_payload : fifo_payload_array_t;
    signal buf_src     : fifo_src_array_t;

    --------------------------------------------------------------------
    -- Tipi per puntatori e contatori
    --------------------------------------------------------------------
    type ptr_array_t   is array(0 to 7) of unsigned(1 downto 0); -- 0..3
    type count_array_t is array(0 to 7) of integer range 0 to 4;

    signal head_ptr  : ptr_array_t;
    signal tail_ptr  : ptr_array_t;
    signal buf_count : count_array_t;

    --------------------------------------------------------------------
    -- Array ingressi
    --------------------------------------------------------------------
    type bus_array is array(0 to 7) of std_logic_vector(10 downto 0);
    signal A : bus_array;

    signal any_valid : std_logic;

begin

    --------------------------------------------------------------------
    -- Collegamento ingressi
    --------------------------------------------------------------------
    A(0) <= A0; A(1) <= A1; A(2) <= A2; A(3) <= A3;
    A(4) <= A4; A(5) <= A5; A(6) <= A6; A(7) <= A7;

    any_valid <= A0(10) or A1(10) or A2(10) or A3(10) or
                 A4(10) or A5(10) or A6(10) or A7(10);

    --------------------------------------------------------------------
    -- FSM
    --------------------------------------------------------------------
    process(clk, r)
        variable dest    : integer range 0 to 7;
        variable payload : std_logic_vector(3 downto 0);
        variable src_val : std_logic_vector(2 downto 0);
        variable dsel    : integer range 0 to 7;
        variable found   : boolean;
    begin
        if r='1' then
            ----------------------------------------------------------------
            -- RESET
            ----------------------------------------------------------------
            state <= IDLE;

            for d_i in 0 to 7 loop
                head_ptr(d_i)  <= (others=>'0');
                tail_ptr(d_i)  <= (others=>'0');
                buf_count(d_i) <= 0;
                for j in 0 to 3 loop
                    buf_payload(d_i)(j) <= (others=>'0');
                    buf_src(d_i)(j)     <= (others=>'0');
                end loop;
            end loop;

            s <= (others=>'0');
            d <= (others=>'0');

            i0 <= (others=>'0'); i1 <= (others=>'0'); i2 <= (others=>'0'); i3 <= (others=>'0');
            i4 <= (others=>'0'); i5 <= (others=>'0'); i6 <= (others=>'0'); i7 <= (others=>'0');

        elsif rising_edge(clk) then

            case state is

                ---------------------------------------------------------
                -- IDLE
                ---------------------------------------------------------
                when IDLE =>
                    if any_valid='1' then
                        state <= READ;
                    elsif (buf_count(0)>0 or buf_count(1)>0 or buf_count(2)>0 or buf_count(3)>0 or
                           buf_count(4)>0 or buf_count(5)>0 or buf_count(6)>0 or buf_count(7)>0) then
                        state <= DISPATCH;
                    else
                        state <= IDLE;
                    end if;

                ---------------------------------------------------------
                -- READ: bufferizza tutte le trasmissioni parallele
                ---------------------------------------------------------
                when READ =>

                    for i in 0 to 7 loop
                        if A(i)(10)='1' then  -- enable
                            dest    := to_integer(unsigned(A(i)(6 downto 4)));
                            src_val := A(i)(9 downto 7);
                            payload := A(i)(3 downto 0);

                            if buf_count(dest) < 4 then
                                buf_payload(dest)(to_integer(tail_ptr(dest))) <= payload;
                                buf_src(dest)(to_integer(tail_ptr(dest)))     <= src_val;
                                tail_ptr(dest) <= tail_ptr(dest) + 1;
                                buf_count(dest) <= buf_count(dest) + 1;
                            -- se il buffer è pieno non accumula
                            end if;
                        end if;
                    end loop;

                    state <= DISPATCH;

                ---------------------------------------------------------
                -- DISPATCH: invia un messaggio alla omega_network
                ---------------------------------------------------------
                when DISPATCH =>

                    -- reset ingressi alla omega
                    i0 <= (others=>'0'); i1 <= (others=>'0'); i2 <= (others=>'0'); i3 <= (others=>'0');
                    i4 <= (others=>'0'); i5 <= (others=>'0'); i6 <= (others=>'0'); i7 <= (others=>'0');

                    -- scegli la prima destinazione con messaggi (priorità fissa sui dest più vecchi)
                    found := false;
                    dsel  := 0;

                    for d_i in 0 to 7 loop
                        if (not found) and (buf_count(d_i)>0) then
                            found := true;
                            dsel  := d_i;
                        end if;
                    end loop;

                    if found then
                        -- estrai il messaggio dalla FIFO di dsel
                        payload := buf_payload(dsel)(to_integer(head_ptr(dsel)));
                        src_val := buf_src(dsel)(to_integer(head_ptr(dsel)));

                        head_ptr(dsel)  <= head_ptr(dsel) + 1;
                        buf_count(dsel) <= buf_count(dsel) - 1;

                        -- manda alla omega_network
                        s <= src_val;
                        d <= std_logic_vector(to_unsigned(dsel,3));

                        case to_integer(unsigned(src_val)) is
                            when 0 => i0 <= payload;
                            when 1 => i1 <= payload;
                            when 2 => i2 <= payload;
                            when 3 => i3 <= payload;
                            when 4 => i4 <= payload;
                            when 5 => i5 <= payload;
                            when 6 => i6 <= payload;
                            when 7 => i7 <= payload;
                            when others => null;
                        end case;
                    else
                        -- nessun messaggio in coda: niente da inviare
                        s <= (others=>'0');
                        d <= (others=>'0');
                    end if;

                    state <= IDLE;

            end case;
        end if;
    end process;

end Behavioral;
