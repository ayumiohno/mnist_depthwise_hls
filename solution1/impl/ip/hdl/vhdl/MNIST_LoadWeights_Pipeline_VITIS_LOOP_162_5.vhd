-- ==============================================================
-- RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
-- Version: 2022.1
-- Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MNIST_LoadWeights_Pipeline_VITIS_LOOP_162_5 is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    wstrm_TVALID : IN STD_LOGIC;
    wstrm_TDATA : IN STD_LOGIC_VECTOR (31 downto 0);
    wstrm_TREADY : OUT STD_LOGIC;
    wstrm_TKEEP : IN STD_LOGIC_VECTOR (3 downto 0);
    wstrm_TSTRB : IN STD_LOGIC_VECTOR (3 downto 0);
    wstrm_TUSER : IN STD_LOGIC_VECTOR (1 downto 0);
    wstrm_TLAST : IN STD_LOGIC_VECTOR (0 downto 0);
    wstrm_TID : IN STD_LOGIC_VECTOR (4 downto 0);
    wstrm_TDEST : IN STD_LOGIC_VECTOR (5 downto 0);
    depth3_0_address0 : OUT STD_LOGIC_VECTOR (4 downto 0);
    depth3_0_ce0 : OUT STD_LOGIC;
    depth3_0_we0 : OUT STD_LOGIC;
    depth3_0_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    depth3_1_address0 : OUT STD_LOGIC_VECTOR (4 downto 0);
    depth3_1_ce0 : OUT STD_LOGIC;
    depth3_1_we0 : OUT STD_LOGIC;
    depth3_1_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    depth3_2_address0 : OUT STD_LOGIC_VECTOR (4 downto 0);
    depth3_2_ce0 : OUT STD_LOGIC;
    depth3_2_we0 : OUT STD_LOGIC;
    depth3_2_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    depth3_3_address0 : OUT STD_LOGIC_VECTOR (4 downto 0);
    depth3_3_ce0 : OUT STD_LOGIC;
    depth3_3_we0 : OUT STD_LOGIC;
    depth3_3_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    depth3_4_address0 : OUT STD_LOGIC_VECTOR (4 downto 0);
    depth3_4_ce0 : OUT STD_LOGIC;
    depth3_4_we0 : OUT STD_LOGIC;
    depth3_4_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    depth3_5_address0 : OUT STD_LOGIC_VECTOR (4 downto 0);
    depth3_5_ce0 : OUT STD_LOGIC;
    depth3_5_we0 : OUT STD_LOGIC;
    depth3_5_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    depth3_6_address0 : OUT STD_LOGIC_VECTOR (4 downto 0);
    depth3_6_ce0 : OUT STD_LOGIC;
    depth3_6_we0 : OUT STD_LOGIC;
    depth3_6_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    depth3_7_address0 : OUT STD_LOGIC_VECTOR (4 downto 0);
    depth3_7_ce0 : OUT STD_LOGIC;
    depth3_7_we0 : OUT STD_LOGIC;
    depth3_7_d0 : OUT STD_LOGIC_VECTOR (31 downto 0) );
end;


architecture behav of MNIST_LoadWeights_Pipeline_VITIS_LOOP_162_5 is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv8_0 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    constant ap_const_lv3_6 : STD_LOGIC_VECTOR (2 downto 0) := "110";
    constant ap_const_lv3_5 : STD_LOGIC_VECTOR (2 downto 0) := "101";
    constant ap_const_lv3_4 : STD_LOGIC_VECTOR (2 downto 0) := "100";
    constant ap_const_lv3_3 : STD_LOGIC_VECTOR (2 downto 0) := "011";
    constant ap_const_lv3_2 : STD_LOGIC_VECTOR (2 downto 0) := "010";
    constant ap_const_lv3_1 : STD_LOGIC_VECTOR (2 downto 0) := "001";
    constant ap_const_lv3_0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    constant ap_const_lv3_7 : STD_LOGIC_VECTOR (2 downto 0) := "111";
    constant ap_const_lv8_C0 : STD_LOGIC_VECTOR (7 downto 0) := "11000000";
    constant ap_const_lv8_1 : STD_LOGIC_VECTOR (7 downto 0) := "00000001";
    constant ap_const_lv32_3 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000011";
    constant ap_const_lv32_7 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000111";
    constant ap_const_boolean_1 : BOOLEAN := true;

attribute shreg_extract : string;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (0 downto 0) := "1";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal icmp_ln162_fu_220_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_block_state1_pp0_stage0_iter0 : BOOLEAN;
    signal ap_condition_exit_pp0_iter0_stage0 : STD_LOGIC;
    signal ap_loop_exit_ready : STD_LOGIC;
    signal ap_ready_int : STD_LOGIC;
    signal wstrm_TDATA_blk_n : STD_LOGIC;
    signal zext_ln166_fu_258_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal i_fu_86 : STD_LOGIC_VECTOR (7 downto 0);
    signal add_ln162_fu_226_p2 : STD_LOGIC_VECTOR (7 downto 0);
    signal ap_loop_init : STD_LOGIC;
    signal ap_sig_allocacmp_i_4 : STD_LOGIC_VECTOR (7 downto 0);
    signal trunc_ln166_fu_270_p1 : STD_LOGIC_VECTOR (2 downto 0);
    signal bitcast_ln166_fu_236_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal lshr_ln_fu_248_p4 : STD_LOGIC_VECTOR (4 downto 0);
    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_continue_int : STD_LOGIC;
    signal ap_done_int : STD_LOGIC;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_start_int : STD_LOGIC;
    signal ap_condition_219 : BOOLEAN;
    signal ap_ce_reg : STD_LOGIC;

    component MNIST_flow_control_loop_pipe_sequential_init IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_start_int : OUT STD_LOGIC;
        ap_loop_init : OUT STD_LOGIC;
        ap_ready_int : IN STD_LOGIC;
        ap_loop_exit_ready : IN STD_LOGIC;
        ap_loop_exit_done : IN STD_LOGIC;
        ap_continue_int : OUT STD_LOGIC;
        ap_done_int : IN STD_LOGIC );
    end component;



begin
    flow_control_loop_pipe_sequential_init_U : component MNIST_flow_control_loop_pipe_sequential_init
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => ap_start,
        ap_ready => ap_ready,
        ap_done => ap_done,
        ap_start_int => ap_start_int,
        ap_loop_init => ap_loop_init,
        ap_ready_int => ap_ready_int,
        ap_loop_exit_ready => ap_condition_exit_pp0_iter0_stage0,
        ap_loop_exit_done => ap_done_int,
        ap_continue_int => ap_continue_int,
        ap_done_int => ap_done_int);





    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_state1;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_done_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_done_reg <= ap_const_logic_0;
            else
                if ((ap_continue_int = ap_const_logic_1)) then 
                    ap_done_reg <= ap_const_logic_0;
                elsif ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_loop_exit_ready = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    i_fu_86_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_219)) then
                if ((icmp_ln162_fu_220_p2 = ap_const_lv1_0)) then 
                    i_fu_86 <= add_ln162_fu_226_p2;
                elsif ((ap_loop_init = ap_const_logic_1)) then 
                    i_fu_86 <= ap_const_lv8_0;
                end if;
            end if; 
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_CS_fsm, ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                ap_NS_fsm <= ap_ST_fsm_state1;
            when others =>  
                ap_NS_fsm <= "X";
        end case;
    end process;
    add_ln162_fu_226_p2 <= std_logic_vector(unsigned(ap_sig_allocacmp_i_4) + unsigned(ap_const_lv8_1));
    ap_CS_fsm_state1 <= ap_CS_fsm(0);

    ap_ST_fsm_state1_blk_assign_proc : process(wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if (((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) then 
            ap_ST_fsm_state1_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state1_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_block_state1_pp0_stage0_iter0_assign_proc : process(wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
                ap_block_state1_pp0_stage0_iter0 <= ((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)));
    end process;


    ap_condition_219_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
                ap_condition_219 <= (not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1));
    end process;


    ap_condition_exit_pp0_iter0_stage0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_1;
        else 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_done_int_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_loop_exit_ready, ap_done_reg, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_loop_exit_ready = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_done_int <= ap_const_logic_1;
        else 
            ap_done_int <= ap_done_reg;
        end if; 
    end process;


    ap_idle_assign_proc : process(ap_CS_fsm_state1, ap_start_int)
    begin
        if (((ap_start_int = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;

    ap_loop_exit_ready <= ap_condition_exit_pp0_iter0_stage0;

    ap_ready_int_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_ready_int <= ap_const_logic_1;
        else 
            ap_ready_int <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_allocacmp_i_4_assign_proc : process(ap_CS_fsm_state1, i_fu_86, ap_loop_init)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state1) and (ap_loop_init = ap_const_logic_1))) then 
            ap_sig_allocacmp_i_4 <= ap_const_lv8_0;
        else 
            ap_sig_allocacmp_i_4 <= i_fu_86;
        end if; 
    end process;

    bitcast_ln166_fu_236_p1 <= wstrm_TDATA;
    depth3_0_address0 <= zext_ln166_fu_258_p1(5 - 1 downto 0);

    depth3_0_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            depth3_0_ce0 <= ap_const_logic_1;
        else 
            depth3_0_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_0_d0 <= bitcast_ln166_fu_236_p1;

    depth3_0_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, trunc_ln166_fu_270_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln166_fu_270_p1 = ap_const_lv3_0))) then 
            depth3_0_we0 <= ap_const_logic_1;
        else 
            depth3_0_we0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_1_address0 <= zext_ln166_fu_258_p1(5 - 1 downto 0);

    depth3_1_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            depth3_1_ce0 <= ap_const_logic_1;
        else 
            depth3_1_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_1_d0 <= bitcast_ln166_fu_236_p1;

    depth3_1_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, trunc_ln166_fu_270_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln166_fu_270_p1 = ap_const_lv3_1))) then 
            depth3_1_we0 <= ap_const_logic_1;
        else 
            depth3_1_we0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_2_address0 <= zext_ln166_fu_258_p1(5 - 1 downto 0);

    depth3_2_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            depth3_2_ce0 <= ap_const_logic_1;
        else 
            depth3_2_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_2_d0 <= bitcast_ln166_fu_236_p1;

    depth3_2_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, trunc_ln166_fu_270_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln166_fu_270_p1 = ap_const_lv3_2))) then 
            depth3_2_we0 <= ap_const_logic_1;
        else 
            depth3_2_we0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_3_address0 <= zext_ln166_fu_258_p1(5 - 1 downto 0);

    depth3_3_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            depth3_3_ce0 <= ap_const_logic_1;
        else 
            depth3_3_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_3_d0 <= bitcast_ln166_fu_236_p1;

    depth3_3_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, trunc_ln166_fu_270_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln166_fu_270_p1 = ap_const_lv3_3))) then 
            depth3_3_we0 <= ap_const_logic_1;
        else 
            depth3_3_we0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_4_address0 <= zext_ln166_fu_258_p1(5 - 1 downto 0);

    depth3_4_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            depth3_4_ce0 <= ap_const_logic_1;
        else 
            depth3_4_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_4_d0 <= bitcast_ln166_fu_236_p1;

    depth3_4_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, trunc_ln166_fu_270_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln166_fu_270_p1 = ap_const_lv3_4))) then 
            depth3_4_we0 <= ap_const_logic_1;
        else 
            depth3_4_we0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_5_address0 <= zext_ln166_fu_258_p1(5 - 1 downto 0);

    depth3_5_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            depth3_5_ce0 <= ap_const_logic_1;
        else 
            depth3_5_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_5_d0 <= bitcast_ln166_fu_236_p1;

    depth3_5_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, trunc_ln166_fu_270_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln166_fu_270_p1 = ap_const_lv3_5))) then 
            depth3_5_we0 <= ap_const_logic_1;
        else 
            depth3_5_we0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_6_address0 <= zext_ln166_fu_258_p1(5 - 1 downto 0);

    depth3_6_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            depth3_6_ce0 <= ap_const_logic_1;
        else 
            depth3_6_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_6_d0 <= bitcast_ln166_fu_236_p1;

    depth3_6_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, trunc_ln166_fu_270_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln166_fu_270_p1 = ap_const_lv3_6))) then 
            depth3_6_we0 <= ap_const_logic_1;
        else 
            depth3_6_we0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_7_address0 <= zext_ln166_fu_258_p1(5 - 1 downto 0);

    depth3_7_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            depth3_7_ce0 <= ap_const_logic_1;
        else 
            depth3_7_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    depth3_7_d0 <= bitcast_ln166_fu_236_p1;

    depth3_7_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, trunc_ln166_fu_270_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln166_fu_270_p1 = ap_const_lv3_7))) then 
            depth3_7_we0 <= ap_const_logic_1;
        else 
            depth3_7_we0 <= ap_const_logic_0;
        end if; 
    end process;

    icmp_ln162_fu_220_p2 <= "1" when (ap_sig_allocacmp_i_4 = ap_const_lv8_C0) else "0";
    lshr_ln_fu_248_p4 <= ap_sig_allocacmp_i_4(7 downto 3);
    trunc_ln166_fu_270_p1 <= ap_sig_allocacmp_i_4(3 - 1 downto 0);

    wstrm_TDATA_blk_n_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if (((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_start_int = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            wstrm_TDATA_blk_n <= wstrm_TVALID;
        else 
            wstrm_TDATA_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    wstrm_TREADY_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln162_fu_220_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln162_fu_220_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            wstrm_TREADY <= ap_const_logic_1;
        else 
            wstrm_TREADY <= ap_const_logic_0;
        end if; 
    end process;

    zext_ln166_fu_258_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(lshr_ln_fu_248_p4),64));
end behav;