// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Version: 2022.1
// Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module MNIST_PointwiseConv2d_1_12_10_Pipeline_VITIS_LOOP_25_2 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        point3_o80_din,
        point3_o80_num_data_valid,
        point3_o80_fifo_cap,
        point3_o80_full_n,
        point3_o80_write,
        add277_reload,
        add27_18_reload,
        add27_29_reload,
        add27_310_reload,
        add27_411_reload,
        add27_512_reload,
        add27_613_reload,
        add27_714_reload,
        add27_815_reload,
        add27_916_reload
);

parameter    ap_ST_fsm_pp0_stage0 = 1'd1;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
output  [31:0] point3_o80_din;
input  [1:0] point3_o80_num_data_valid;
input  [1:0] point3_o80_fifo_cap;
input   point3_o80_full_n;
output   point3_o80_write;
input  [31:0] add277_reload;
input  [31:0] add27_18_reload;
input  [31:0] add27_29_reload;
input  [31:0] add27_310_reload;
input  [31:0] add27_411_reload;
input  [31:0] add27_512_reload;
input  [31:0] add27_613_reload;
input  [31:0] add27_714_reload;
input  [31:0] add27_815_reload;
input  [31:0] add27_916_reload;

reg ap_idle;
reg point3_o80_write;

(* fsm_encoding = "none" *) reg   [0:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_idle_pp0;
wire    ap_block_state1_pp0_stage0_iter0;
reg    ap_block_state2_pp0_stage0_iter1;
reg    ap_block_pp0_stage0_subdone;
wire   [0:0] icmp_ln25_fu_154_p2;
reg    ap_condition_exit_pp0_iter0_stage0;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
reg    point3_o80_blk_n;
wire    ap_block_pp0_stage0;
wire   [31:0] tmp_s_fu_166_p12;
reg   [31:0] tmp_s_reg_258;
reg    ap_block_pp0_stage0_11001;
reg   [3:0] oc_fu_70;
wire   [3:0] add_ln25_fu_160_p2;
wire    ap_loop_init;
reg   [3:0] ap_sig_allocacmp_oc_2;
reg    ap_block_pp0_stage0_01001;
wire   [31:0] bitcast_ln26_fu_198_p1;
wire   [7:0] tmp_20_fu_201_p4;
wire   [22:0] trunc_ln26_fu_211_p1;
wire   [0:0] icmp_ln26_9_fu_221_p2;
wire   [0:0] icmp_ln26_fu_215_p2;
wire   [0:0] or_ln26_fu_227_p2;
wire   [0:0] grp_fu_141_p2;
wire   [0:0] and_ln26_fu_233_p2;
reg    grp_fu_141_ce;
reg    ap_block_pp0_stage0_00001;
reg    ap_done_reg;
wire    ap_continue_int;
reg    ap_done_int;
reg   [0:0] ap_NS_fsm;
wire    ap_enable_pp0;
wire    ap_start_int;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 1'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_done_reg = 1'b0;
end

MNIST_fcmp_32ns_32ns_1_2_no_dsp_1 #(
    .ID( 1 ),
    .NUM_STAGE( 2 ),
    .din0_WIDTH( 32 ),
    .din1_WIDTH( 32 ),
    .dout_WIDTH( 1 ))
fcmp_32ns_32ns_1_2_no_dsp_1_U496(
    .clk(ap_clk),
    .reset(ap_rst),
    .din0(tmp_s_fu_166_p12),
    .din1(32'd0),
    .ce(grp_fu_141_ce),
    .opcode(5'd2),
    .dout(grp_fu_141_p2)
);

MNIST_mux_104_32_1_1 #(
    .ID( 1 ),
    .NUM_STAGE( 1 ),
    .din0_WIDTH( 32 ),
    .din1_WIDTH( 32 ),
    .din2_WIDTH( 32 ),
    .din3_WIDTH( 32 ),
    .din4_WIDTH( 32 ),
    .din5_WIDTH( 32 ),
    .din6_WIDTH( 32 ),
    .din7_WIDTH( 32 ),
    .din8_WIDTH( 32 ),
    .din9_WIDTH( 32 ),
    .din10_WIDTH( 4 ),
    .dout_WIDTH( 32 ))
mux_104_32_1_1_U497(
    .din0(add277_reload),
    .din1(add27_18_reload),
    .din2(add27_29_reload),
    .din3(add27_310_reload),
    .din4(add27_411_reload),
    .din5(add27_512_reload),
    .din6(add27_613_reload),
    .din7(add27_714_reload),
    .din8(add27_815_reload),
    .din9(add27_916_reload),
    .din10(ap_sig_allocacmp_oc_2),
    .dout(tmp_s_fu_166_p12)
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
    .ap_loop_exit_ready(ap_condition_exit_pp0_iter0_stage0),
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
        end else if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter0_stage0)) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_enable_reg_pp0_iter1 <= ap_start_int;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if (((icmp_ln25_fu_154_p2 == 1'd0) & (ap_enable_reg_pp0_iter0 == 1'b1))) begin
            oc_fu_70 <= add_ln25_fu_160_p2;
        end else if ((ap_loop_init == 1'b1)) begin
            oc_fu_70 <= 4'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln25_fu_154_p2 == 1'd0) & (1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        tmp_s_reg_258 <= tmp_s_fu_166_p12;
    end
end

always @ (*) begin
    if (((icmp_ln25_fu_154_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if (((ap_idle_pp0 == 1'b1) & (ap_start_int == 1'b0) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    if (((ap_loop_init == 1'b1) & (1'b0 == ap_block_pp0_stage0) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_sig_allocacmp_oc_2 = 4'd0;
    end else begin
        ap_sig_allocacmp_oc_2 = oc_fu_70;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        grp_fu_141_ce = 1'b1;
    end else begin
        grp_fu_141_ce = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        point3_o80_blk_n = point3_o80_full_n;
    end else begin
        point3_o80_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        point3_o80_write = 1'b1;
    end else begin
        point3_o80_write = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign add_ln25_fu_160_p2 = (ap_sig_allocacmp_oc_2 + 4'd1);

assign and_ln26_fu_233_p2 = (or_ln26_fu_227_p2 & grp_fu_141_p2);

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage0_00001 = ((point3_o80_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage0_01001 = ((point3_o80_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage0_11001 = ((point3_o80_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

always @ (*) begin
    ap_block_pp0_stage0_subdone = ((point3_o80_full_n == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

assign ap_block_state1_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_state2_pp0_stage0_iter1 = (point3_o80_full_n == 1'b0);
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_enable_reg_pp0_iter0 = ap_start_int;

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter0_stage0;

assign bitcast_ln26_fu_198_p1 = tmp_s_reg_258;

assign icmp_ln25_fu_154_p2 = ((ap_sig_allocacmp_oc_2 == 4'd10) ? 1'b1 : 1'b0);

assign icmp_ln26_9_fu_221_p2 = ((trunc_ln26_fu_211_p1 == 23'd0) ? 1'b1 : 1'b0);

assign icmp_ln26_fu_215_p2 = ((tmp_20_fu_201_p4 != 8'd255) ? 1'b1 : 1'b0);

assign or_ln26_fu_227_p2 = (icmp_ln26_fu_215_p2 | icmp_ln26_9_fu_221_p2);

assign point3_o80_din = ((and_ln26_fu_233_p2[0:0] == 1'b1) ? bitcast_ln26_fu_198_p1 : 32'd0);

assign tmp_20_fu_201_p4 = {{bitcast_ln26_fu_198_p1[30:23]}};

assign trunc_ln26_fu_211_p1 = bitcast_ln26_fu_198_p1[22:0];

endmodule //MNIST_PointwiseConv2d_1_12_10_Pipeline_VITIS_LOOP_25_2
