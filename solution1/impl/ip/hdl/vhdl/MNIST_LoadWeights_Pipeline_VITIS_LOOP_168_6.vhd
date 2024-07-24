-- ==============================================================
-- RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
-- Version: 2022.1
-- Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MNIST_LoadWeights_Pipeline_VITIS_LOOP_168_6 is
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
    point3_0_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_0_ce0 : OUT STD_LOGIC;
    point3_0_we0 : OUT STD_LOGIC;
    point3_0_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_1_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_1_ce0 : OUT STD_LOGIC;
    point3_1_we0 : OUT STD_LOGIC;
    point3_1_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_2_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_2_ce0 : OUT STD_LOGIC;
    point3_2_we0 : OUT STD_LOGIC;
    point3_2_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_3_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_3_ce0 : OUT STD_LOGIC;
    point3_3_we0 : OUT STD_LOGIC;
    point3_3_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_4_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_4_ce0 : OUT STD_LOGIC;
    point3_4_we0 : OUT STD_LOGIC;
    point3_4_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_5_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_5_ce0 : OUT STD_LOGIC;
    point3_5_we0 : OUT STD_LOGIC;
    point3_5_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_6_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_6_ce0 : OUT STD_LOGIC;
    point3_6_we0 : OUT STD_LOGIC;
    point3_6_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_7_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_7_ce0 : OUT STD_LOGIC;
    point3_7_we0 : OUT STD_LOGIC;
    point3_7_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_8_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_8_ce0 : OUT STD_LOGIC;
    point3_8_we0 : OUT STD_LOGIC;
    point3_8_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_9_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_9_ce0 : OUT STD_LOGIC;
    point3_9_we0 : OUT STD_LOGIC;
    point3_9_d0 : OUT STD_LOGIC_VECTOR (31 downto 0);
    point3_10_address0 : OUT STD_LOGIC_VECTOR (3 downto 0);
    point3_10_ce0 : OUT STD_LOGIC;
    point3_10_we0 : OUT STD_LOGIC;
    point3_10_d0 : OUT STD_LOGIC_VECTOR (31 downto 0) );
end;


architecture behav of MNIST_LoadWeights_Pipeline_VITIS_LOOP_168_6 is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv7_0 : STD_LOGIC_VECTOR (6 downto 0) := "0000000";
    constant ap_const_lv15_0 : STD_LOGIC_VECTOR (14 downto 0) := "000000000000000";
    constant ap_const_lv4_9 : STD_LOGIC_VECTOR (3 downto 0) := "1001";
    constant ap_const_lv4_8 : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant ap_const_lv4_7 : STD_LOGIC_VECTOR (3 downto 0) := "0111";
    constant ap_const_lv4_6 : STD_LOGIC_VECTOR (3 downto 0) := "0110";
    constant ap_const_lv4_5 : STD_LOGIC_VECTOR (3 downto 0) := "0101";
    constant ap_const_lv4_4 : STD_LOGIC_VECTOR (3 downto 0) := "0100";
    constant ap_const_lv4_3 : STD_LOGIC_VECTOR (3 downto 0) := "0011";
    constant ap_const_lv4_2 : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    constant ap_const_lv4_1 : STD_LOGIC_VECTOR (3 downto 0) := "0001";
    constant ap_const_lv4_0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    constant ap_const_lv7_78 : STD_LOGIC_VECTOR (6 downto 0) := "1111000";
    constant ap_const_lv7_1 : STD_LOGIC_VECTOR (6 downto 0) := "0000001";
    constant ap_const_lv15_BB : STD_LOGIC_VECTOR (14 downto 0) := "000000010111011";
    constant ap_const_lv32_B : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001011";
    constant ap_const_lv32_E : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001110";
    constant ap_const_lv7_B : STD_LOGIC_VECTOR (6 downto 0) := "0001011";
    constant ap_const_boolean_1 : BOOLEAN := true;

attribute shreg_extract : string;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (0 downto 0) := "1";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal icmp_ln168_fu_295_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_block_state1_pp0_stage0_iter0 : BOOLEAN;
    signal ap_condition_exit_pp0_iter0_stage0 : STD_LOGIC;
    signal ap_loop_exit_ready : STD_LOGIC;
    signal ap_ready_int : STD_LOGIC;
    signal wstrm_TDATA_blk_n : STD_LOGIC;
    signal zext_ln172_fu_348_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal phi_urem211_fu_104 : STD_LOGIC_VECTOR (6 downto 0);
    signal select_ln168_fu_382_p3 : STD_LOGIC_VECTOR (6 downto 0);
    signal ap_loop_init : STD_LOGIC;
    signal ap_sig_allocacmp_phi_urem211_load : STD_LOGIC_VECTOR (6 downto 0);
    signal ap_sig_allocacmp_phi_urem211_load_1 : STD_LOGIC_VECTOR (6 downto 0);
    signal phi_mul209_fu_108 : STD_LOGIC_VECTOR (14 downto 0);
    signal add_ln172_fu_332_p2 : STD_LOGIC_VECTOR (14 downto 0);
    signal ap_sig_allocacmp_phi_mul209_load : STD_LOGIC_VECTOR (14 downto 0);
    signal i_fu_112 : STD_LOGIC_VECTOR (6 downto 0);
    signal add_ln168_fu_301_p2 : STD_LOGIC_VECTOR (6 downto 0);
    signal ap_sig_allocacmp_i_3 : STD_LOGIC_VECTOR (6 downto 0);
    signal trunc_ln172_fu_363_p1 : STD_LOGIC_VECTOR (3 downto 0);
    signal bitcast_ln172_fu_317_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_fu_338_p4 : STD_LOGIC_VECTOR (3 downto 0);
    signal add_ln168_1_fu_370_p2 : STD_LOGIC_VECTOR (6 downto 0);
    signal icmp_ln168_1_fu_376_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_continue_int : STD_LOGIC;
    signal ap_done_int : STD_LOGIC;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_start_int : STD_LOGIC;
    signal ap_condition_302 : BOOLEAN;
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
                elsif ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_loop_exit_ready = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    i_fu_112_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_302)) then
                if ((icmp_ln168_fu_295_p2 = ap_const_lv1_0)) then 
                    i_fu_112 <= add_ln168_fu_301_p2;
                elsif ((ap_loop_init = ap_const_logic_1)) then 
                    i_fu_112 <= ap_const_lv7_0;
                end if;
            end if; 
        end if;
    end process;

    phi_mul209_fu_108_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_302)) then
                if ((icmp_ln168_fu_295_p2 = ap_const_lv1_0)) then 
                    phi_mul209_fu_108 <= add_ln172_fu_332_p2;
                elsif ((ap_loop_init = ap_const_logic_1)) then 
                    phi_mul209_fu_108 <= ap_const_lv15_0;
                end if;
            end if; 
        end if;
    end process;

    phi_urem211_fu_104_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_boolean_1 = ap_condition_302)) then
                if ((icmp_ln168_fu_295_p2 = ap_const_lv1_0)) then 
                    phi_urem211_fu_104 <= select_ln168_fu_382_p3;
                elsif ((ap_loop_init = ap_const_logic_1)) then 
                    phi_urem211_fu_104 <= ap_const_lv7_0;
                end if;
            end if; 
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_CS_fsm, ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                ap_NS_fsm <= ap_ST_fsm_state1;
            when others =>  
                ap_NS_fsm <= "X";
        end case;
    end process;
    add_ln168_1_fu_370_p2 <= std_logic_vector(unsigned(ap_sig_allocacmp_phi_urem211_load_1) + unsigned(ap_const_lv7_1));
    add_ln168_fu_301_p2 <= std_logic_vector(unsigned(ap_sig_allocacmp_i_3) + unsigned(ap_const_lv7_1));
    add_ln172_fu_332_p2 <= std_logic_vector(unsigned(ap_sig_allocacmp_phi_mul209_load) + unsigned(ap_const_lv15_BB));
    ap_CS_fsm_state1 <= ap_CS_fsm(0);

    ap_ST_fsm_state1_blk_assign_proc : process(wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if (((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) then 
            ap_ST_fsm_state1_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state1_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_block_state1_pp0_stage0_iter0_assign_proc : process(wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
                ap_block_state1_pp0_stage0_iter0 <= ((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)));
    end process;


    ap_condition_302_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
                ap_condition_302 <= (not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1));
    end process;


    ap_condition_exit_pp0_iter0_stage0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_1;
        else 
            ap_condition_exit_pp0_iter0_stage0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_done_int_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_loop_exit_ready, ap_done_reg, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_loop_exit_ready = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
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

    ap_ready_int_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_ready_int <= ap_const_logic_1;
        else 
            ap_ready_int <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_allocacmp_i_3_assign_proc : process(ap_CS_fsm_state1, ap_loop_init, i_fu_112)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state1) and (ap_loop_init = ap_const_logic_1))) then 
            ap_sig_allocacmp_i_3 <= ap_const_lv7_0;
        else 
            ap_sig_allocacmp_i_3 <= i_fu_112;
        end if; 
    end process;


    ap_sig_allocacmp_phi_mul209_load_assign_proc : process(ap_CS_fsm_state1, ap_loop_init, phi_mul209_fu_108)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state1) and (ap_loop_init = ap_const_logic_1))) then 
            ap_sig_allocacmp_phi_mul209_load <= ap_const_lv15_0;
        else 
            ap_sig_allocacmp_phi_mul209_load <= phi_mul209_fu_108;
        end if; 
    end process;


    ap_sig_allocacmp_phi_urem211_load_assign_proc : process(ap_CS_fsm_state1, phi_urem211_fu_104, ap_loop_init)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state1) and (ap_loop_init = ap_const_logic_1))) then 
            ap_sig_allocacmp_phi_urem211_load <= ap_const_lv7_0;
        else 
            ap_sig_allocacmp_phi_urem211_load <= phi_urem211_fu_104;
        end if; 
    end process;


    ap_sig_allocacmp_phi_urem211_load_1_assign_proc : process(ap_CS_fsm_state1, phi_urem211_fu_104, ap_loop_init)
    begin
        if (((ap_const_logic_1 = ap_CS_fsm_state1) and (ap_loop_init = ap_const_logic_1))) then 
            ap_sig_allocacmp_phi_urem211_load_1 <= ap_const_lv7_0;
        else 
            ap_sig_allocacmp_phi_urem211_load_1 <= phi_urem211_fu_104;
        end if; 
    end process;

    bitcast_ln172_fu_317_p1 <= wstrm_TDATA;
    icmp_ln168_1_fu_376_p2 <= "1" when (unsigned(add_ln168_1_fu_370_p2) < unsigned(ap_const_lv7_B)) else "0";
    icmp_ln168_fu_295_p2 <= "1" when (ap_sig_allocacmp_i_3 = ap_const_lv7_78) else "0";
    point3_0_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_0_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_0_ce0 <= ap_const_logic_1;
        else 
            point3_0_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_0_d0 <= bitcast_ln172_fu_317_p1;

    point3_0_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_0))) then 
            point3_0_we0 <= ap_const_logic_1;
        else 
            point3_0_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_10_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_10_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_10_ce0 <= ap_const_logic_1;
        else 
            point3_10_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_10_d0 <= bitcast_ln172_fu_317_p1;

    point3_10_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_0)) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_1)) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_2)) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_3)) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_4)) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_5)) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_6)) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_7)) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_8)) and not((trunc_ln172_fu_363_p1 = ap_const_lv4_9)) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_10_we0 <= ap_const_logic_1;
        else 
            point3_10_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_1_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_1_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_1_ce0 <= ap_const_logic_1;
        else 
            point3_1_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_1_d0 <= bitcast_ln172_fu_317_p1;

    point3_1_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_1))) then 
            point3_1_we0 <= ap_const_logic_1;
        else 
            point3_1_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_2_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_2_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_2_ce0 <= ap_const_logic_1;
        else 
            point3_2_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_2_d0 <= bitcast_ln172_fu_317_p1;

    point3_2_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_2))) then 
            point3_2_we0 <= ap_const_logic_1;
        else 
            point3_2_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_3_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_3_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_3_ce0 <= ap_const_logic_1;
        else 
            point3_3_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_3_d0 <= bitcast_ln172_fu_317_p1;

    point3_3_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_3))) then 
            point3_3_we0 <= ap_const_logic_1;
        else 
            point3_3_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_4_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_4_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_4_ce0 <= ap_const_logic_1;
        else 
            point3_4_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_4_d0 <= bitcast_ln172_fu_317_p1;

    point3_4_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_4))) then 
            point3_4_we0 <= ap_const_logic_1;
        else 
            point3_4_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_5_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_5_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_5_ce0 <= ap_const_logic_1;
        else 
            point3_5_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_5_d0 <= bitcast_ln172_fu_317_p1;

    point3_5_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_5))) then 
            point3_5_we0 <= ap_const_logic_1;
        else 
            point3_5_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_6_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_6_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_6_ce0 <= ap_const_logic_1;
        else 
            point3_6_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_6_d0 <= bitcast_ln172_fu_317_p1;

    point3_6_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_6))) then 
            point3_6_we0 <= ap_const_logic_1;
        else 
            point3_6_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_7_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_7_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_7_ce0 <= ap_const_logic_1;
        else 
            point3_7_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_7_d0 <= bitcast_ln172_fu_317_p1;

    point3_7_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_7))) then 
            point3_7_we0 <= ap_const_logic_1;
        else 
            point3_7_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_8_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_8_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_8_ce0 <= ap_const_logic_1;
        else 
            point3_8_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_8_d0 <= bitcast_ln172_fu_317_p1;

    point3_8_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_8))) then 
            point3_8_we0 <= ap_const_logic_1;
        else 
            point3_8_we0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_9_address0 <= zext_ln172_fu_348_p1(4 - 1 downto 0);

    point3_9_ce0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            point3_9_ce0 <= ap_const_logic_1;
        else 
            point3_9_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    point3_9_d0 <= bitcast_ln172_fu_317_p1;

    point3_9_we0_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, trunc_ln172_fu_363_p1, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1) and (trunc_ln172_fu_363_p1 = ap_const_lv4_9))) then 
            point3_9_we0 <= ap_const_logic_1;
        else 
            point3_9_we0 <= ap_const_logic_0;
        end if; 
    end process;

    select_ln168_fu_382_p3 <= 
        add_ln168_1_fu_370_p2 when (icmp_ln168_1_fu_376_p2(0) = '1') else 
        ap_const_lv7_0;
    tmp_fu_338_p4 <= ap_sig_allocacmp_phi_mul209_load(14 downto 11);
    trunc_ln172_fu_363_p1 <= ap_sig_allocacmp_phi_urem211_load(4 - 1 downto 0);

    wstrm_TDATA_blk_n_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if (((ap_start_int = ap_const_logic_1) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            wstrm_TDATA_blk_n <= wstrm_TVALID;
        else 
            wstrm_TDATA_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    wstrm_TREADY_assign_proc : process(ap_CS_fsm_state1, wstrm_TVALID, icmp_ln168_fu_295_p2, ap_start_int)
    begin
        if ((not(((ap_start_int = ap_const_logic_0) or ((icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (wstrm_TVALID = ap_const_logic_0)))) and (icmp_ln168_fu_295_p2 = ap_const_lv1_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            wstrm_TREADY <= ap_const_logic_1;
        else 
            wstrm_TREADY <= ap_const_logic_0;
        end if; 
    end process;

    zext_ln172_fu_348_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmp_fu_338_p4),64));
end behav;