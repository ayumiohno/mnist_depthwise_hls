// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Version: 2022.1
// Copyright (C) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module MNIST_Loop_VITIS_LOOP_226_1_proc6 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_continue,
        ap_idle,
        ap_ready,
        point3_o_dout,
        point3_o_num_data_valid,
        point3_o_fifo_cap,
        point3_o_empty_n,
        point3_o_read,
        ostrm_TREADY,
        p_read,
        p_read1,
        p_read2,
        p_read3,
        p_read4,
        ostrm_TDATA,
        ostrm_TVALID,
        ostrm_TKEEP,
        ostrm_TSTRB,
        ostrm_TUSER,
        ostrm_TLAST,
        ostrm_TID,
        ostrm_TDEST
);

parameter    ap_ST_fsm_pp0_stage0 = 1'd1;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
input   ap_continue;
output   ap_idle;
output   ap_ready;
input  [31:0] point3_o_dout;
input  [1:0] point3_o_num_data_valid;
input  [1:0] point3_o_fifo_cap;
input   point3_o_empty_n;
output   point3_o_read;
input   ostrm_TREADY;
input  [3:0] p_read;
input  [3:0] p_read1;
input  [1:0] p_read2;
input  [4:0] p_read3;
input  [5:0] p_read4;
output  [31:0] ostrm_TDATA;
output   ostrm_TVALID;
output  [3:0] ostrm_TKEEP;
output  [3:0] ostrm_TSTRB;
output  [1:0] ostrm_TUSER;
output  [0:0] ostrm_TLAST;
output  [4:0] ostrm_TID;
output  [5:0] ostrm_TDEST;

reg ap_idle;
reg point3_o_read;

(* fsm_encoding = "none" *) reg   [0:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_enable_reg_pp0_iter2;
reg    ap_idle_pp0;
reg    ap_done_reg;
reg    ap_block_state1_pp0_stage0_iter0;
wire    regslice_both_ostrm_V_data_V_U_apdone_blk;
reg    ap_block_state2_pp0_stage0_iter1;
reg    ap_block_state3_pp0_stage0_iter2;
wire    ap_loop_exit_ready;
reg    ap_loop_exit_ready_pp0_iter1_reg;
reg    ap_block_pp0_stage0_subdone;
wire   [0:0] icmp_ln226_fu_148_p2;
reg    ap_condition_exit_pp0_iter0_stage0;
reg    ap_ready_int;
reg    point3_o_blk_n;
wire    ap_block_pp0_stage0;
reg    ostrm_TDATA_blk_n;
reg   [5:0] p_read_1_reg_178;
reg    ap_block_pp0_stage0_11001;
reg   [4:0] p_read_2_reg_183;
reg   [1:0] p_read_3_reg_188;
reg   [3:0] p_read_4_reg_193;
reg   [3:0] p_read_5_reg_198;
wire   [0:0] tmp_last_V_fu_160_p2;
reg   [0:0] tmp_last_V_reg_207;
reg   [3:0] i_fu_74;
wire   [3:0] i_2_fu_154_p2;
wire    ap_loop_init;
reg   [3:0] ap_sig_allocacmp_i_1;
reg    ap_block_pp0_stage0_01001;
wire    ap_continue_int;
reg    ap_done_int;
reg   [0:0] ap_NS_fsm;
wire    ap_enable_pp0;
wire    ap_start_int;
reg    ostrm_TVALID_int_regslice;
wire    ostrm_TREADY_int_regslice;
wire    regslice_both_ostrm_V_data_V_U_vld_out;
wire    regslice_both_ostrm_V_keep_V_U_apdone_blk;
wire    regslice_both_ostrm_V_keep_V_U_ack_in_dummy;
wire    regslice_both_ostrm_V_keep_V_U_vld_out;
wire    regslice_both_ostrm_V_strb_V_U_apdone_blk;
wire    regslice_both_ostrm_V_strb_V_U_ack_in_dummy;
wire    regslice_both_ostrm_V_strb_V_U_vld_out;
wire    regslice_both_ostrm_V_user_V_U_apdone_blk;
wire    regslice_both_ostrm_V_user_V_U_ack_in_dummy;
wire    regslice_both_ostrm_V_user_V_U_vld_out;
wire    regslice_both_ostrm_V_last_V_U_apdone_blk;
wire    regslice_both_ostrm_V_last_V_U_ack_in_dummy;
wire    regslice_both_ostrm_V_last_V_U_vld_out;
wire    regslice_both_ostrm_V_id_V_U_apdone_blk;
wire    regslice_both_ostrm_V_id_V_U_ack_in_dummy;
wire    regslice_both_ostrm_V_id_V_U_vld_out;
wire    regslice_both_ostrm_V_dest_V_U_apdone_blk;
wire    regslice_both_ostrm_V_dest_V_U_ack_in_dummy;
wire    regslice_both_ostrm_V_dest_V_U_vld_out;
reg    ap_condition_142;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 1'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_enable_reg_pp0_iter2 = 1'b0;
#0 ap_done_reg = 1'b0;
end

MNIST_flow_control_loop_pipe flow_control_loop_pipe_U(
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
    .ap_done_int(ap_done_int),
    .ap_continue(ap_continue)
);

MNIST_regslice_both #(
    .DataWidth( 32 ))
regslice_both_ostrm_V_data_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .data_in(point3_o_dout),
    .vld_in(ostrm_TVALID_int_regslice),
    .ack_in(ostrm_TREADY_int_regslice),
    .data_out(ostrm_TDATA),
    .vld_out(regslice_both_ostrm_V_data_V_U_vld_out),
    .ack_out(ostrm_TREADY),
    .apdone_blk(regslice_both_ostrm_V_data_V_U_apdone_blk)
);

MNIST_regslice_both #(
    .DataWidth( 4 ))
regslice_both_ostrm_V_keep_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .data_in(p_read_5_reg_198),
    .vld_in(ostrm_TVALID_int_regslice),
    .ack_in(regslice_both_ostrm_V_keep_V_U_ack_in_dummy),
    .data_out(ostrm_TKEEP),
    .vld_out(regslice_both_ostrm_V_keep_V_U_vld_out),
    .ack_out(ostrm_TREADY),
    .apdone_blk(regslice_both_ostrm_V_keep_V_U_apdone_blk)
);

MNIST_regslice_both #(
    .DataWidth( 4 ))
regslice_both_ostrm_V_strb_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .data_in(p_read_4_reg_193),
    .vld_in(ostrm_TVALID_int_regslice),
    .ack_in(regslice_both_ostrm_V_strb_V_U_ack_in_dummy),
    .data_out(ostrm_TSTRB),
    .vld_out(regslice_both_ostrm_V_strb_V_U_vld_out),
    .ack_out(ostrm_TREADY),
    .apdone_blk(regslice_both_ostrm_V_strb_V_U_apdone_blk)
);

MNIST_regslice_both #(
    .DataWidth( 2 ))
regslice_both_ostrm_V_user_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .data_in(p_read_3_reg_188),
    .vld_in(ostrm_TVALID_int_regslice),
    .ack_in(regslice_both_ostrm_V_user_V_U_ack_in_dummy),
    .data_out(ostrm_TUSER),
    .vld_out(regslice_both_ostrm_V_user_V_U_vld_out),
    .ack_out(ostrm_TREADY),
    .apdone_blk(regslice_both_ostrm_V_user_V_U_apdone_blk)
);

MNIST_regslice_both #(
    .DataWidth( 1 ))
regslice_both_ostrm_V_last_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .data_in(tmp_last_V_reg_207),
    .vld_in(ostrm_TVALID_int_regslice),
    .ack_in(regslice_both_ostrm_V_last_V_U_ack_in_dummy),
    .data_out(ostrm_TLAST),
    .vld_out(regslice_both_ostrm_V_last_V_U_vld_out),
    .ack_out(ostrm_TREADY),
    .apdone_blk(regslice_both_ostrm_V_last_V_U_apdone_blk)
);

MNIST_regslice_both #(
    .DataWidth( 5 ))
regslice_both_ostrm_V_id_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .data_in(p_read_2_reg_183),
    .vld_in(ostrm_TVALID_int_regslice),
    .ack_in(regslice_both_ostrm_V_id_V_U_ack_in_dummy),
    .data_out(ostrm_TID),
    .vld_out(regslice_both_ostrm_V_id_V_U_vld_out),
    .ack_out(ostrm_TREADY),
    .apdone_blk(regslice_both_ostrm_V_id_V_U_apdone_blk)
);

MNIST_regslice_both #(
    .DataWidth( 6 ))
regslice_both_ostrm_V_dest_V_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .data_in(p_read_1_reg_178),
    .vld_in(ostrm_TVALID_int_regslice),
    .ack_in(regslice_both_ostrm_V_dest_V_U_ack_in_dummy),
    .data_out(ostrm_TDEST),
    .vld_out(regslice_both_ostrm_V_dest_V_U_vld_out),
    .ack_out(ostrm_TREADY),
    .apdone_blk(regslice_both_ostrm_V_dest_V_U_apdone_blk)
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
        end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_loop_exit_ready_pp0_iter1_reg == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
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
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter2 <= 1'b0;
    end else begin
        if ((1'b0 == ap_block_pp0_stage0_subdone)) begin
            ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
        end
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_condition_142)) begin
        if ((icmp_ln226_fu_148_p2 == 1'd0)) begin
            i_fu_74 <= i_2_fu_154_p2;
        end else if ((ap_loop_init == 1'b1)) begin
            i_fu_74 <= 4'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_loop_exit_ready_pp0_iter1_reg <= ap_loop_exit_ready;
        p_read_1_reg_178 <= p_read4;
        p_read_2_reg_183 <= p_read3;
        p_read_3_reg_188 <= p_read2;
        p_read_4_reg_193 <= p_read1;
        p_read_5_reg_198 <= p_read;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln226_fu_148_p2 == 1'd0) & (1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        tmp_last_V_reg_207 <= tmp_last_V_fu_160_p2;
    end
end

always @ (*) begin
    if (((icmp_ln226_fu_148_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_subdone) & (ap_start_int == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter0_stage0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_loop_exit_ready_pp0_iter1_reg == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if (((ap_idle_pp0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_start_int == 1'b0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter2 == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_start_int == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_start_int == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0) & (ap_loop_init == 1'b1))) begin
        ap_sig_allocacmp_i_1 = 4'd0;
    end else begin
        ap_sig_allocacmp_i_1 = i_fu_74;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter2 == 1'b1)) | ((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0)))) begin
        ostrm_TDATA_blk_n = ostrm_TREADY_int_regslice;
    end else begin
        ostrm_TDATA_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ostrm_TVALID_int_regslice = 1'b1;
    end else begin
        ostrm_TVALID_int_regslice = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        point3_o_blk_n = point3_o_empty_n;
    end else begin
        point3_o_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        point3_o_read = 1'b1;
    end else begin
        point3_o_read = 1'b0;
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

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage0_01001 = ((ap_done_reg == 1'b1) | ((ap_loop_exit_ready_pp0_iter1_reg == 1'b1) & (regslice_both_ostrm_V_data_V_U_apdone_blk == 1'b1)) | ((ap_enable_reg_pp0_iter2 == 1'b1) & (ostrm_TREADY_int_regslice == 1'b0)) | ((ap_enable_reg_pp0_iter1 == 1'b1) & ((regslice_both_ostrm_V_data_V_U_apdone_blk == 1'b1) | (point3_o_empty_n == 1'b0) | (ostrm_TREADY_int_regslice == 1'b0))) | ((ap_done_reg == 1'b1) & (ap_start_int == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_11001 = ((ap_done_reg == 1'b1) | ((ap_loop_exit_ready_pp0_iter1_reg == 1'b1) & (regslice_both_ostrm_V_data_V_U_apdone_blk == 1'b1)) | ((ap_enable_reg_pp0_iter2 == 1'b1) & (ostrm_TREADY_int_regslice == 1'b0)) | ((ap_enable_reg_pp0_iter1 == 1'b1) & ((regslice_both_ostrm_V_data_V_U_apdone_blk == 1'b1) | (point3_o_empty_n == 1'b0) | (ostrm_TREADY_int_regslice == 1'b0))) | ((ap_done_reg == 1'b1) & (ap_start_int == 1'b1)));
end

always @ (*) begin
    ap_block_pp0_stage0_subdone = ((ap_done_reg == 1'b1) | ((ap_loop_exit_ready_pp0_iter1_reg == 1'b1) & (regslice_both_ostrm_V_data_V_U_apdone_blk == 1'b1)) | ((ap_enable_reg_pp0_iter2 == 1'b1) & (ostrm_TREADY_int_regslice == 1'b0)) | ((ap_enable_reg_pp0_iter1 == 1'b1) & ((regslice_both_ostrm_V_data_V_U_apdone_blk == 1'b1) | (point3_o_empty_n == 1'b0) | (ostrm_TREADY_int_regslice == 1'b0))) | ((ap_done_reg == 1'b1) & (ap_start_int == 1'b1)));
end

always @ (*) begin
    ap_block_state1_pp0_stage0_iter0 = (ap_done_reg == 1'b1);
end

always @ (*) begin
    ap_block_state2_pp0_stage0_iter1 = ((regslice_both_ostrm_V_data_V_U_apdone_blk == 1'b1) | (point3_o_empty_n == 1'b0) | (ostrm_TREADY_int_regslice == 1'b0));
end

always @ (*) begin
    ap_block_state3_pp0_stage0_iter2 = (ostrm_TREADY_int_regslice == 1'b0);
end

always @ (*) begin
    ap_condition_142 = ((1'b0 == ap_block_pp0_stage0_11001) & (ap_start_int == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0));
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_enable_reg_pp0_iter0 = ap_start_int;

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter0_stage0;

assign i_2_fu_154_p2 = (ap_sig_allocacmp_i_1 + 4'd1);

assign icmp_ln226_fu_148_p2 = ((ap_sig_allocacmp_i_1 == 4'd10) ? 1'b1 : 1'b0);

assign ostrm_TVALID = regslice_both_ostrm_V_data_V_U_vld_out;

assign tmp_last_V_fu_160_p2 = ((ap_sig_allocacmp_i_1 == 4'd9) ? 1'b1 : 1'b0);

endmodule //MNIST_Loop_VITIS_LOOP_226_1_proc6