// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Version: 2022.1
// Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module MNIST_PointwiseConv2d_10_1_4_Pipeline_py_px (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        point1_o76_din,
        point1_o76_num_data_valid,
        point1_o76_fifo_cap,
        point1_o76_full_n,
        point1_o76_write,
        depth1_o75_dout,
        depth1_o75_num_data_valid,
        depth1_o75_fifo_cap,
        depth1_o75_empty_n,
        depth1_o75_read,
        weights_load,
        weights_load_1,
        weights_load_2,
        weights_load_3
);

parameter    ap_ST_fsm_pp0_stage0 = 4'd1;
parameter    ap_ST_fsm_pp0_stage1 = 4'd2;
parameter    ap_ST_fsm_pp0_stage2 = 4'd4;
parameter    ap_ST_fsm_pp0_stage3 = 4'd8;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
output  [31:0] point1_o76_din;
input  [1:0] point1_o76_num_data_valid;
input  [1:0] point1_o76_fifo_cap;
input   point1_o76_full_n;
output   point1_o76_write;
input  [31:0] depth1_o75_dout;
input  [1:0] depth1_o75_num_data_valid;
input  [1:0] depth1_o75_fifo_cap;
input   depth1_o75_empty_n;
output   depth1_o75_read;
input  [31:0] weights_load;
input  [31:0] weights_load_1;
input  [31:0] weights_load_2;
input  [31:0] weights_load_3;

reg ap_idle;
reg[31:0] point1_o76_din;
reg point1_o76_write;
reg depth1_o75_read;

(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
reg    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_enable_reg_pp0_iter2;
reg    ap_enable_reg_pp0_iter3;
reg    ap_idle_pp0;
wire    ap_CS_fsm_pp0_stage3;
wire    ap_block_state4_pp0_stage3_iter0;
wire    ap_block_state8_pp0_stage3_iter1;
reg    ap_block_state12_pp0_stage3_iter2;
reg    ap_block_pp0_stage3_subdone;
reg   [0:0] icmp_ln9_reg_387;
reg    ap_condition_exit_pp0_iter0_stage3;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
reg    depth1_o75_blk_n;
wire    ap_CS_fsm_pp0_stage1;
wire    ap_block_pp0_stage1;
reg    point1_o76_blk_n;
wire    ap_CS_fsm_pp0_stage2;
wire    ap_block_pp0_stage2;
wire    ap_block_pp0_stage3;
wire    ap_block_pp0_stage0;
wire   [31:0] grp_fu_103_p2;
reg   [31:0] reg_117;
wire    ap_block_state1_pp0_stage0_iter0;
wire    ap_block_state5_pp0_stage0_iter1;
wire    ap_block_state9_pp0_stage0_iter2;
reg    ap_block_state13_pp0_stage0_iter3;
reg    ap_block_pp0_stage0_11001;
wire    ap_block_state3_pp0_stage2_iter0;
wire    ap_block_state7_pp0_stage2_iter1;
reg    ap_block_state11_pp0_stage2_iter2;
reg    ap_block_pp0_stage2_11001;
reg   [31:0] reg_122;
reg    ap_block_state2_pp0_stage1_iter0;
wire    ap_block_state6_pp0_stage1_iter1;
wire    ap_block_state10_pp0_stage1_iter2;
reg    ap_block_state14_pp0_stage1_iter3;
reg    ap_block_pp0_stage1_11001;
reg    ap_block_pp0_stage3_11001;
wire   [0:0] icmp_ln9_fu_135_p2;
reg   [0:0] icmp_ln9_reg_387_pp0_iter1_reg;
reg   [0:0] icmp_ln9_reg_387_pp0_iter2_reg;
reg   [31:0] depth1_o75_read_reg_391;
wire   [31:0] tmp_27_fu_152_p1;
reg   [31:0] tmp_27_reg_396;
wire   [31:0] grp_fu_108_p2;
reg   [31:0] mul_reg_401;
reg   [31:0] mul24_1_reg_406;
reg   [31:0] mul24_2_reg_411;
reg   [31:0] mul24_3_reg_416;
reg    ap_enable_reg_pp0_iter0_reg;
reg    ap_block_pp0_stage1_subdone;
reg   [6:0] indvar_flatten_fu_62;
wire   [6:0] add_ln9_fu_141_p2;
wire    ap_loop_init;
reg   [6:0] ap_sig_allocacmp_indvar_flatten_load;
wire   [31:0] select_ln174_fu_198_p3;
reg    ap_block_pp0_stage2_01001;
wire   [31:0] select_ln174_1_fu_249_p3;
reg    ap_block_pp0_stage3_01001;
wire   [31:0] select_ln174_2_fu_300_p3;
reg    ap_block_pp0_stage0_01001;
wire   [31:0] select_ln174_3_fu_351_p3;
reg    ap_block_pp0_stage1_01001;
reg   [31:0] grp_fu_103_p0;
reg   [31:0] grp_fu_108_p0;
reg   [31:0] grp_fu_108_p1;
reg   [31:0] grp_fu_112_p0;
wire   [31:0] bitcast_ln26_fu_156_p1;
wire   [7:0] tmp_fu_160_p4;
wire   [22:0] trunc_ln26_fu_170_p1;
wire   [0:0] icmp_ln26_2_fu_180_p2;
wire   [0:0] icmp_ln26_fu_174_p2;
wire   [0:0] or_ln26_fu_186_p2;
wire   [0:0] grp_fu_112_p2;
wire   [0:0] and_ln26_fu_192_p2;
wire   [31:0] bitcast_ln26_1_fu_207_p1;
wire   [7:0] tmp_14_fu_211_p4;
wire   [22:0] trunc_ln26_1_fu_221_p1;
wire   [0:0] icmp_ln26_4_fu_231_p2;
wire   [0:0] icmp_ln26_3_fu_225_p2;
wire   [0:0] or_ln26_1_fu_237_p2;
wire   [0:0] and_ln26_1_fu_243_p2;
wire   [31:0] bitcast_ln26_2_fu_258_p1;
wire   [7:0] tmp_16_fu_262_p4;
wire   [22:0] trunc_ln26_2_fu_272_p1;
wire   [0:0] icmp_ln26_6_fu_282_p2;
wire   [0:0] icmp_ln26_5_fu_276_p2;
wire   [0:0] or_ln26_2_fu_288_p2;
wire   [0:0] and_ln26_2_fu_294_p2;
wire   [31:0] bitcast_ln26_3_fu_309_p1;
wire   [7:0] tmp_18_fu_313_p4;
wire   [22:0] trunc_ln26_3_fu_323_p1;
wire   [0:0] icmp_ln26_8_fu_333_p2;
wire   [0:0] icmp_ln26_7_fu_327_p2;
wire   [0:0] or_ln26_3_fu_339_p2;
wire   [0:0] and_ln26_3_fu_345_p2;
reg    grp_fu_103_ce;
reg    grp_fu_108_ce;
reg    grp_fu_112_ce;
reg    ap_block_pp0_stage1_00001;
reg    ap_block_pp0_stage2_00001;
reg    ap_block_pp0_stage3_00001;
reg    ap_block_pp0_stage0_00001;
reg    ap_done_reg;
wire    ap_continue_int;
reg    ap_done_int;
reg    ap_loop_exit_ready_pp0_iter1_reg;
reg    ap_condition_exit_pp0_iter2_stage1;
reg    ap_idle_pp0_0to1;
reg    ap_loop_exit_ready_pp0_iter2_reg;
reg   [3:0] ap_NS_fsm;
reg    ap_block_pp0_stage0_subdone;
reg    ap_idle_pp0_1to3;
reg    ap_block_pp0_stage2_subdone;
wire    ap_enable_pp0;
wire    ap_start_int;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 4'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_enable_reg_pp0_iter2 = 1'b0;
#0 ap_enable_reg_pp0_iter3 = 1'b0;
#0 ap_enable_reg_pp0_iter0_reg = 1'b0;
#0 ap_done_reg = 1'b0;
end

MNIST_fadd_32ns_32ns_32_4_full_dsp_1 #(
    .ID( 1 ),
    .NUM_STAGE( 4 ),
    .din0_WIDTH( 32 ),
    .din1_WIDTH( 32 ),
    .dout_WIDTH( 32 ))
fadd_32ns_32ns_32_4_full_dsp_1_U168(
    .clk(ap_clk),
    .reset(ap_rst),
    .din0(grp_fu_103_p0),
    .din1(32'd0),
    .ce(grp_fu_103_ce),
    .dout(grp_fu_103_p2)
);

MNIST_fmul_32ns_32ns_32_3_max_dsp_1 #(
    .ID( 1 ),
    .NUM_STAGE( 3 ),
    .din0_WIDTH( 32 ),
    .din1_WIDTH( 32 ),
    .dout_WIDTH( 32 ))
fmul_32ns_32ns_32_3_max_dsp_1_U169(
    .clk(ap_clk),
    .reset(ap_rst),
    .din0(grp_fu_108_p0),
    .din1(grp_fu_108_p1),
    .ce(grp_fu_108_ce),
    .dout(grp_fu_108_p2)
);

MNIST_fcmp_32ns_32ns_1_2_no_dsp_1 #(
    .ID( 1 ),
    .NUM_STAGE( 2 ),
    .din0_WIDTH( 32 ),
    .din1_WIDTH( 32 ),
    .dout_WIDTH( 1 ))
fcmp_32ns_32ns_1_2_no_dsp_1_U170(
    .clk(ap_clk),
    .reset(ap_rst),
    .din0(grp_fu_112_p0),
    .din1(32'd0),
    .ce(grp_fu_112_ce),
    .opcode(5'd2),
    .dout(grp_fu_112_p2)
);

MNIST_flow_control_loop_pipe_sequential_init flow_control_loop_pipe_sequential_init_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_start_int(ap_start_int),
    .ap_loop_init(ap_loop_init),
    .ap_ready_int(ap_ready_int),
    .ap_loop_exit_ready(ap_condition_exit_pp0_iter0_stage3),
    .ap_loop_exit_done(ap_done_int),
    .ap_continue_int(ap_continue_int),
    .ap_done_int(ap_done_int)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue_int == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage1_subdone) & (ap_loop_exit_ready_pp0_iter2_reg == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter0_reg <= 1'b0;
    end else begin
        if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
            ap_enable_reg_pp0_iter0_reg <= ap_start_int;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter0_stage3)) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage3_subdone) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
            ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter2 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp0_stage3_subdone) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
            ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter3 <= 1'b0;
    end else begin
        if (((1'b0 == ap_block_pp0_stage1_subdone) & (ap_enable_reg_pp0_iter3 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
            ap_enable_reg_pp0_iter3 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage3_subdone) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
            ap_enable_reg_pp0_iter3 <= ap_enable_reg_pp0_iter2;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((ap_idle_pp0_0to1 == 1'b1) & (1'b1 == ap_condition_exit_pp0_iter2_stage1))) begin
        ap_loop_exit_ready_pp0_iter1_reg <= 1'b0;
    end else if (((1'b0 == ap_block_pp0_stage3_11001) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        ap_loop_exit_ready_pp0_iter1_reg <= ap_loop_exit_ready;
    end
end

always @ (posedge ap_clk) begin
    if (((ap_idle_pp0_0to1 == 1'b1) & (1'b1 == ap_condition_exit_pp0_iter2_stage1))) begin
        ap_loop_exit_ready_pp0_iter2_reg <= 1'b0;
    end else if (((1'b0 == ap_block_pp0_stage3_11001) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        ap_loop_exit_ready_pp0_iter2_reg <= ap_loop_exit_ready_pp0_iter1_reg;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if (((ap_enable_reg_pp0_iter0 == 1'b1) & (icmp_ln9_fu_135_p2 == 1'd0))) begin
            indvar_flatten_fu_62 <= add_ln9_fu_141_p2;
        end else if ((ap_loop_init == 1'b1)) begin
            indvar_flatten_fu_62 <= 7'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln9_reg_387 == 1'd0) & (1'b0 == ap_block_pp0_stage1_11001) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        depth1_o75_read_reg_391 <= depth1_o75_dout;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        icmp_ln9_reg_387 <= icmp_ln9_fu_135_p2;
        icmp_ln9_reg_387_pp0_iter1_reg <= icmp_ln9_reg_387;
        icmp_ln9_reg_387_pp0_iter2_reg <= icmp_ln9_reg_387_pp0_iter1_reg;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        mul24_1_reg_406 <= grp_fu_108_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage2_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2))) begin
        mul24_2_reg_411 <= grp_fu_108_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        mul24_3_reg_416 <= grp_fu_108_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        mul_reg_401 <= grp_fu_108_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((((1'b0 == ap_block_pp0_stage2_11001) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        reg_117 <= grp_fu_103_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((((1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)))) begin
        reg_122 <= grp_fu_103_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln9_reg_387 == 1'd0) & (1'b0 == ap_block_pp0_stage2_11001) & (1'b1 == ap_CS_fsm_pp0_stage2))) begin
        tmp_27_reg_396 <= tmp_27_fu_152_p1;
    end
end

always @ (*) begin
    if (((icmp_ln9_reg_387 == 1'd1) & (1'b0 == ap_block_pp0_stage3_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        ap_condition_exit_pp0_iter0_stage3 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter0_stage3 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage1_subdone) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1) & (icmp_ln9_reg_387_pp0_iter2_reg == 1'd1))) begin
        ap_condition_exit_pp0_iter2_stage1 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter2_stage1 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage1_subdone) & (ap_loop_exit_ready_pp0_iter2_reg == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_pp0_stage0)) begin
        ap_enable_reg_pp0_iter0 = ap_start_int;
    end else begin
        ap_enable_reg_pp0_iter0 = ap_enable_reg_pp0_iter0_reg;
    end
end

always @ (*) begin
    if (((ap_start_int == 1'b0) & (ap_idle_pp0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter3 == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0_0to1 = 1'b1;
    end else begin
        ap_idle_pp0_0to1 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter3 == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b0))) begin
        ap_idle_pp0_1to3 = 1'b1;
    end else begin
        ap_idle_pp0_1to3 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage3_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_loop_init == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_sig_allocacmp_indvar_flatten_load = 7'd0;
    end else begin
        ap_sig_allocacmp_indvar_flatten_load = indvar_flatten_fu_62;
    end
end

always @ (*) begin
    if (((icmp_ln9_reg_387 == 1'd0) & (1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        depth1_o75_blk_n = depth1_o75_empty_n;
    end else begin
        depth1_o75_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((icmp_ln9_reg_387 == 1'd0) & (1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        depth1_o75_read = 1'b1;
    end else begin
        depth1_o75_read = 1'b0;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage3_11001) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((1'b0 == ap_block_pp0_stage1_11001) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage2_11001) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        grp_fu_103_ce = 1'b1;
    end else begin
        grp_fu_103_ce = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        grp_fu_103_p0 = mul24_3_reg_416;
    end else if (((1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        grp_fu_103_p0 = mul24_2_reg_411;
    end else if (((1'b0 == ap_block_pp0_stage2) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2))) begin
        grp_fu_103_p0 = mul24_1_reg_406;
    end else if (((1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        grp_fu_103_p0 = mul_reg_401;
    end else begin
        grp_fu_103_p0 = 'bx;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage3_11001) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((1'b0 == ap_block_pp0_stage1_11001) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage2_11001) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        grp_fu_108_ce = 1'b1;
    end else begin
        grp_fu_108_ce = 1'b0;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)) | ((1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)))) begin
        grp_fu_108_p0 = tmp_27_reg_396;
    end else if (((1'b0 == ap_block_pp0_stage2) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2))) begin
        grp_fu_108_p0 = tmp_27_fu_152_p1;
    end else begin
        grp_fu_108_p0 = 'bx;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        grp_fu_108_p1 = weights_load_3;
    end else if (((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        grp_fu_108_p1 = weights_load_2;
    end else if (((1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        grp_fu_108_p1 = weights_load_1;
    end else if (((1'b0 == ap_block_pp0_stage2) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2))) begin
        grp_fu_108_p1 = weights_load;
    end else begin
        grp_fu_108_p1 = 'bx;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage3_11001) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((1'b0 == ap_block_pp0_stage1_11001) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage2_11001) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        grp_fu_112_ce = 1'b1;
    end else begin
        grp_fu_112_ce = 1'b0;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter3 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)) | ((1'b0 == ap_block_pp0_stage2) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)))) begin
        grp_fu_112_p0 = reg_122;
    end else if ((((1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)))) begin
        grp_fu_112_p0 = reg_117;
    end else begin
        grp_fu_112_p0 = 'bx;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage1) & (ap_enable_reg_pp0_iter3 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter3 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)) | ((1'b0 == ap_block_pp0_stage3) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((1'b0 == ap_block_pp0_stage2) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)))) begin
        point1_o76_blk_n = point1_o76_full_n;
    end else begin
        point1_o76_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage1_01001) & (ap_enable_reg_pp0_iter3 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1))) begin
        point1_o76_din = select_ln174_3_fu_351_p3;
    end else if (((1'b0 == ap_block_pp0_stage0_01001) & (ap_enable_reg_pp0_iter3 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        point1_o76_din = select_ln174_2_fu_300_p3;
    end else if (((1'b0 == ap_block_pp0_stage3_01001) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3))) begin
        point1_o76_din = select_ln174_1_fu_249_p3;
    end else if (((1'b0 == ap_block_pp0_stage2_01001) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2))) begin
        point1_o76_din = select_ln174_fu_198_p3;
    end else begin
        point1_o76_din = 'bx;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage3_11001) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage3)) | ((1'b0 == ap_block_pp0_stage1_11001) & (ap_enable_reg_pp0_iter3 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage1)) | ((1'b0 == ap_block_pp0_stage2_11001) & (ap_enable_reg_pp0_iter2 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage2)) | ((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter3 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        point1_o76_write = 1'b1;
    end else begin
        point1_o76_write = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            if ((~((ap_start_int == 1'b0) & (ap_idle_pp0_1to3 == 1'b1)) & (1'b0 == ap_block_pp0_stage0_subdone))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end
        end
        ap_ST_fsm_pp0_stage1 : begin
            if (((ap_idle_pp0_0to1 == 1'b1) & (1'b1 == ap_condition_exit_pp0_iter2_stage1))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else if ((1'b0 == ap_block_pp0_stage1_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage1;
            end
        end
        ap_ST_fsm_pp0_stage2 : begin
            if ((1'b0 == ap_block_pp0_stage2_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage2;
            end
        end
        ap_ST_fsm_pp0_stage3 : begin
            if ((1'b0 == ap_block_pp0_stage3_subdone)) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage3;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln9_fu_141_p2 = (ap_sig_allocacmp_indvar_flatten_load + 7'd1);

assign and_ln26_1_fu_243_p2 = (or_ln26_1_fu_237_p2 & grp_fu_112_p2);

assign and_ln26_2_fu_294_p2 = (or_ln26_2_fu_288_p2 & grp_fu_112_p2);

assign and_ln26_3_fu_345_p2 = (or_ln26_3_fu_339_p2 & grp_fu_112_p2);

assign and_ln26_fu_192_p2 = (or_ln26_fu_186_p2 & grp_fu_112_p2);

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_pp0_stage1 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_pp0_stage2 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_pp0_stage3 = ap_CS_fsm[32'd3];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage0_00001 = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage0_01001 = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage0_11001 = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage0_subdone = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b1));
end

assign ap_block_pp0_stage1 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage1_00001 = (((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b1)) | ((depth1_o75_empty_n == 1'b0) & (icmp_ln9_reg_387 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage1_01001 = (((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b1)) | ((depth1_o75_empty_n == 1'b0) & (icmp_ln9_reg_387 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage1_11001 = (((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b1)) | ((depth1_o75_empty_n == 1'b0) & (icmp_ln9_reg_387 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage1_subdone = (((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter3 == 1'b1)) | ((depth1_o75_empty_n == 1'b0) & (icmp_ln9_reg_387 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1)));
end

assign ap_block_pp0_stage2 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage2_00001 = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage2_01001 = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage2_11001 = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage2_subdone = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1));
end

assign ap_block_pp0_stage3 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage3_00001 = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage3_01001 = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage3_11001 = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage3_subdone = ((point1_o76_full_n == 1'b0) & (ap_enable_reg_pp0_iter2 == 1'b1));
end

assign ap_block_state10_pp0_stage1_iter2 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_state11_pp0_stage2_iter2 = (point1_o76_full_n == 1'b0);
end

always @ (*) begin
    ap_block_state12_pp0_stage3_iter2 = (point1_o76_full_n == 1'b0);
end

always @ (*) begin
    ap_block_state13_pp0_stage0_iter3 = (point1_o76_full_n == 1'b0);
end

always @ (*) begin
    ap_block_state14_pp0_stage1_iter3 = (point1_o76_full_n == 1'b0);
end

assign ap_block_state1_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_state2_pp0_stage1_iter0 = ((depth1_o75_empty_n == 1'b0) & (icmp_ln9_reg_387 == 1'd0));
end

assign ap_block_state3_pp0_stage2_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state4_pp0_stage3_iter0 = ~(1'b1 == 1'b1);

assign ap_block_state5_pp0_stage0_iter1 = ~(1'b1 == 1'b1);

assign ap_block_state6_pp0_stage1_iter1 = ~(1'b1 == 1'b1);

assign ap_block_state7_pp0_stage2_iter1 = ~(1'b1 == 1'b1);

assign ap_block_state8_pp0_stage3_iter1 = ~(1'b1 == 1'b1);

assign ap_block_state9_pp0_stage0_iter2 = ~(1'b1 == 1'b1);

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter0_stage3;

assign bitcast_ln26_1_fu_207_p1 = reg_122;

assign bitcast_ln26_2_fu_258_p1 = reg_117;

assign bitcast_ln26_3_fu_309_p1 = reg_122;

assign bitcast_ln26_fu_156_p1 = reg_117;

assign icmp_ln26_2_fu_180_p2 = ((trunc_ln26_fu_170_p1 == 23'd0) ? 1'b1 : 1'b0);

assign icmp_ln26_3_fu_225_p2 = ((tmp_14_fu_211_p4 != 8'd255) ? 1'b1 : 1'b0);

assign icmp_ln26_4_fu_231_p2 = ((trunc_ln26_1_fu_221_p1 == 23'd0) ? 1'b1 : 1'b0);

assign icmp_ln26_5_fu_276_p2 = ((tmp_16_fu_262_p4 != 8'd255) ? 1'b1 : 1'b0);

assign icmp_ln26_6_fu_282_p2 = ((trunc_ln26_2_fu_272_p1 == 23'd0) ? 1'b1 : 1'b0);

assign icmp_ln26_7_fu_327_p2 = ((tmp_18_fu_313_p4 != 8'd255) ? 1'b1 : 1'b0);

assign icmp_ln26_8_fu_333_p2 = ((trunc_ln26_3_fu_323_p1 == 23'd0) ? 1'b1 : 1'b0);

assign icmp_ln26_fu_174_p2 = ((tmp_fu_160_p4 != 8'd255) ? 1'b1 : 1'b0);

assign icmp_ln9_fu_135_p2 = ((ap_sig_allocacmp_indvar_flatten_load == 7'd100) ? 1'b1 : 1'b0);

assign or_ln26_1_fu_237_p2 = (icmp_ln26_4_fu_231_p2 | icmp_ln26_3_fu_225_p2);

assign or_ln26_2_fu_288_p2 = (icmp_ln26_6_fu_282_p2 | icmp_ln26_5_fu_276_p2);

assign or_ln26_3_fu_339_p2 = (icmp_ln26_8_fu_333_p2 | icmp_ln26_7_fu_327_p2);

assign or_ln26_fu_186_p2 = (icmp_ln26_fu_174_p2 | icmp_ln26_2_fu_180_p2);

assign select_ln174_1_fu_249_p3 = ((and_ln26_1_fu_243_p2[0:0] == 1'b1) ? bitcast_ln26_1_fu_207_p1 : 32'd0);

assign select_ln174_2_fu_300_p3 = ((and_ln26_2_fu_294_p2[0:0] == 1'b1) ? bitcast_ln26_2_fu_258_p1 : 32'd0);

assign select_ln174_3_fu_351_p3 = ((and_ln26_3_fu_345_p2[0:0] == 1'b1) ? bitcast_ln26_3_fu_309_p1 : 32'd0);

assign select_ln174_fu_198_p3 = ((and_ln26_fu_192_p2[0:0] == 1'b1) ? bitcast_ln26_fu_156_p1 : 32'd0);

assign tmp_14_fu_211_p4 = {{bitcast_ln26_1_fu_207_p1[30:23]}};

assign tmp_16_fu_262_p4 = {{bitcast_ln26_2_fu_258_p1[30:23]}};

assign tmp_18_fu_313_p4 = {{bitcast_ln26_3_fu_309_p1[30:23]}};

assign tmp_27_fu_152_p1 = depth1_o75_read_reg_391;

assign tmp_fu_160_p4 = {{bitcast_ln26_fu_156_p1[30:23]}};

assign trunc_ln26_1_fu_221_p1 = bitcast_ln26_1_fu_207_p1[22:0];

assign trunc_ln26_2_fu_272_p1 = bitcast_ln26_2_fu_258_p1[22:0];

assign trunc_ln26_3_fu_323_p1 = bitcast_ln26_3_fu_309_p1[22:0];

assign trunc_ln26_fu_170_p1 = bitcast_ln26_fu_156_p1[22:0];

endmodule //MNIST_PointwiseConv2d_10_1_4_Pipeline_py_px