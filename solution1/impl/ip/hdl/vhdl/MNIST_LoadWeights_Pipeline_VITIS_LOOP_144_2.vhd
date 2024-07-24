-- ==============================================================
-- RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
-- Version: 2022.1
-- Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MNIST_LoadWeights_Pipeline_VITIS_LOOP_144_2 is
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
    point1_address0 : OUT STD_LOGIC_VECTOR (1 downto 0);
    point1_ce0 : OUT STD_LOGIC;
    point1_we0 : OUT STD_LOGIC;
    point1_d0 : OUT STD_LOGIC_VECTOR (31 downto 0) );
end;


architecture behav of MNIST_LoadWeights_Pipeline_VITIS_LOOP_144_2 is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv3_0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    constant ap_const_lv3_4 : STD_LOGIC_VECTOR (2 downto 0) := "100";
    constant ap_const_lv3_1 : STD_LOGIC_VECTOR (2 downto 0) := "001";
    constant ap_const_boolean_1 : BOOLEAN := true;

attribute shreg_extract : string;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (0 downto 0) := "1";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal icmp_ln144_fu_95_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_block_state1_pp0_stage0_iter0 : BOOLEAN;
    signal ap_condition_exit_pp0_iter0_stage0 : STD_LOGIC;
    signal ap_loop_exit_ready : STD_LOGIC;
    signal ap_ready_int : STD_LOGIC;
    signal wstrm_TDATA_blk_n : STD_LOGIC;
    signal i_2_cast_fu_107_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal i_2_fu_52 : STD_LOGIC_VECTOR (2 downto 0);
    signal add_ln144_fu_101_p2 : STD_LOGIC_VECTOR (2 downto 0);
    signal ap_loop_init : STD_LOGIC;
    signal ap_sig_allocacmp_i : STD_LOGIC_VECTOR (2 downto 0);
    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_continue_int : STD_LOGIC;
    signal ap_done_int : STD_LOGIC;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_start_int : STD_LOGIC;
    signal ap_condition_121 : BOOLEAN;
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
                elsif ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_loop_exit_ready = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    i_2_fu_52_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_121)) then
                if ((icmp_ln144_fu_95_p2 = ap_const_lv1_0)) then 
                    i_2_fu_52 <= add_ln144_fu_101_p2;
                elsif ((ap_loop_init = ap_const_logic_1)) then 
                    i_2_fu_52 <= ap_const_lv3_0;
                end if;
            end if; 
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_CS_fsm, ap_CS_fsm_state1, wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                ap_NS_fsm <= ap_ST_fsm_state1;
            when others =>  
                ap_NS_fsm <= "X";
        end case;
    end process;
    add_ln144_fu_101_p2 <= std_logic_vector(unsigned(ap_sig_allocacmp_i) + unsigned(ap_const_lv3_1));
    ap_CS_fsm_state1 <= ap_CS_fsm(0);

    ap_ST_fsm_state1_blk_assign_proc : process(wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
        if (((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) then 
            ap_ST_fsm_state1_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state1_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_block_state1_pp0_stage0_iter0_assign_proc : process(wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
                ap_block_state1_pp0_stage0_iter0 <= ((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)));
    end process;


    ap_condition_121_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
                ap_condition_121 <= (not(((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1));
    end process;


    ap_condition_exit_pp0_iter0_stage0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln144_fu_95_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_1;
        else 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_done_int_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln144_fu_95_p2, ap_loop_exit_ready, ap_done_reg, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_loop_exit_ready = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_done_int <= ap_const_logic_1;
        else 
            ap_done_int <= ap_done_reg;
        end if; 
    end process;


    ap_idle_assign_proc : process(ap_CS_fsm_state1, ap_start_int)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state1) and (ap_start_int = ap_const_logic_0))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;

    ap_loop_exit_ready <= ap_condition_exit_pp0_iter0_stage0;

    ap_ready_int_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_ready_int <= ap_const_logic_1;
        else 
            ap_ready_int <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_allocacmp_i_assign_proc : process(ap_CS_fsm_state1, i_2_fu_52, ap_loop_init)
    begin
        if (((ap_loop_init = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_sig_allocacmp_i <= ap_const_lv3_0;
        else 
            ap_sig_allocacmp_i <= i_2_fu_52;
        end if; 
    end process;

    i_2_cast_fu_107_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(ap_sig_allocacmp_i),64));
    icmp_ln144_fu_95_p2 <= "1" when (ap_sig_allocacmp_i = ap_const_lv3_4) else "0";
    point1_address0 <= i_2_cast_fu_107_p1(2 - 1 downto 0);

    point1_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point1_ce0 <= ap_const_logic_1;
        else 
            point1_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point1_d0 <= wstrm_TDATA;

    point1_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point1_we0 <= ap_const_logic_1;
        else 
            point1_we0 <= ap_const_logic_0;
        end if; 
    end process;


    wstrm_TDATA_blk_n_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
        if (((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (ap_start_int = ap_const_logic_1))) then 
            wstrm_TDATA_blk_n <= wstrm_TVALID;
        else 
            wstrm_TDATA_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    wstrm_TREADY_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln144_fu_95_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln144_fu_95_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            wstrm_TREADY <= ap_const_logic_1;
        else 
            wstrm_TREADY <= ap_const_logic_0;
        end if; 
    end process;

end behav;
