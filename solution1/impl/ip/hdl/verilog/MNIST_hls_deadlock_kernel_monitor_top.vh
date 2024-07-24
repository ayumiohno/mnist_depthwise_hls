
wire kernel_monitor_reset;
wire kernel_monitor_clock;
assign kernel_monitor_reset = ~ap_rst_n;
assign kernel_monitor_clock = ap_clk;
wire [7:0] axis_block_sigs;
wire [18:0] inst_idle_sigs;
wire [8:0] inst_block_sigs;
wire kernel_block;

assign axis_block_sigs[0] = ~LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_138_1_fu_112.wstrm_TDATA_blk_n;
assign axis_block_sigs[1] = ~LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_144_2_fu_132.wstrm_TDATA_blk_n;
assign axis_block_sigs[2] = ~LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_150_3_fu_152.wstrm_TDATA_blk_n;
assign axis_block_sigs[3] = ~LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_156_4_fu_172.wstrm_TDATA_blk_n;
assign axis_block_sigs[4] = ~LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_162_5_fu_216.wstrm_TDATA_blk_n;
assign axis_block_sigs[5] = ~LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_168_6_fu_250.wstrm_TDATA_blk_n;
assign axis_block_sigs[6] = ~LoadInput_U0.istrm_TDATA_blk_n;
assign axis_block_sigs[7] = ~Loop_VITIS_LOOP_226_1_proc6_U0.ostrm_TDATA_blk_n;

assign inst_idle_sigs[0] = LoadWeights_U0.ap_idle;
assign inst_block_sigs[0] = (LoadWeights_U0.ap_done & ~LoadWeights_U0.ap_continue);
assign inst_idle_sigs[1] = LoadInput_U0.ap_idle;
assign inst_block_sigs[1] = (LoadInput_U0.ap_done & ~LoadInput_U0.ap_continue) | ~LoadInput_U0.input74_blk_n;
assign inst_idle_sigs[2] = DepthwiseConv2d_28_10_1_3_U0.ap_idle;
assign inst_block_sigs[2] = (DepthwiseConv2d_28_10_1_3_U0.ap_done & ~DepthwiseConv2d_28_10_1_3_U0.ap_continue) | ~DepthwiseConv2d_28_10_1_3_U0.input74_blk_n | ~DepthwiseConv2d_28_10_1_3_U0.grp_DepthwiseConv2d_28_10_1_3_Pipeline_px_fu_652.input74_blk_n | ~DepthwiseConv2d_28_10_1_3_U0.grp_DepthwiseConv2d_28_10_1_3_Pipeline_px_fu_652.depth1_o75_blk_n;
assign inst_idle_sigs[3] = PointwiseConv2d_10_1_4_U0.ap_idle;
assign inst_block_sigs[3] = (PointwiseConv2d_10_1_4_U0.ap_done & ~PointwiseConv2d_10_1_4_U0.ap_continue) | ~PointwiseConv2d_10_1_4_U0.grp_PointwiseConv2d_10_1_4_Pipeline_py_px_fu_73.depth1_o75_blk_n | ~PointwiseConv2d_10_1_4_U0.grp_PointwiseConv2d_10_1_4_Pipeline_py_px_fu_73.point1_o76_blk_n;
assign inst_idle_sigs[4] = DepthwiseConv2d_10_4_4_3_U0.ap_idle;
assign inst_block_sigs[4] = (DepthwiseConv2d_10_4_4_3_U0.ap_done & ~DepthwiseConv2d_10_4_4_3_U0.ap_continue) | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_728_fu_830.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_730_fu_844.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_723_fu_795.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_729_fu_837.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_2_fu_656.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_22_fu_663.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_7_fu_781.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_23_fu_670.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_24_fu_677.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_726_fu_816.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_727_fu_823.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_725_fu_809.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_722_fu_788.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_724_fu_802.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_px_fu_851.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_25_fu_684.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_26_fu_691.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_27_fu_698.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_28_fu_705.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_29_fu_712.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_50_210_fu_719.point1_o76_blk_n | ~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_px_fu_851.depth2_o77_blk_n;
assign inst_idle_sigs[5] = PointwiseConv2d_4_4_12_U0.ap_idle;
assign inst_block_sigs[5] = (PointwiseConv2d_4_4_12_U0.ap_done & ~PointwiseConv2d_4_4_12_U0.ap_continue) | ~PointwiseConv2d_4_4_12_U0.grp_PointwiseConv2d_4_4_12_Pipeline_ic_fu_288.depth2_o77_blk_n | ~PointwiseConv2d_4_4_12_U0.grp_PointwiseConv2d_4_4_12_Pipeline_VITIS_LOOP_25_2_fu_344.point2_o78_blk_n;
assign inst_idle_sigs[6] = DepthwiseConv2dFinal_4_1_12_4_U0.ap_idle;
assign inst_block_sigs[6] = (DepthwiseConv2dFinal_4_1_12_4_U0.ap_done & ~DepthwiseConv2dFinal_4_1_12_4_U0.ap_continue) | ~DepthwiseConv2dFinal_4_1_12_4_U0.grp_DepthwiseConv2dFinal_4_1_12_4_Pipeline_ld_VITIS_LOOP_110_1_VITIS_LOOP_112_2_fu_54.point2_o78_blk_n | ~DepthwiseConv2dFinal_4_1_12_4_U0.grp_DepthwiseConv2dFinal_4_1_12_4_Pipeline_conv_fu_68.depth3_o79_blk_n;
assign inst_idle_sigs[7] = PointwiseConv2d_1_12_10_U0.ap_idle;
assign inst_block_sigs[7] = (PointwiseConv2d_1_12_10_U0.ap_done & ~PointwiseConv2d_1_12_10_U0.ap_continue) | ~PointwiseConv2d_1_12_10_U0.grp_PointwiseConv2d_1_12_10_Pipeline_ic_fu_84.depth3_o79_blk_n | ~PointwiseConv2d_1_12_10_U0.grp_PointwiseConv2d_1_12_10_Pipeline_VITIS_LOOP_25_2_fu_122.point3_o80_blk_n;
assign inst_idle_sigs[8] = Loop_VITIS_LOOP_226_1_proc6_U0.ap_idle;
assign inst_block_sigs[8] = (Loop_VITIS_LOOP_226_1_proc6_U0.ap_done & ~Loop_VITIS_LOOP_226_1_proc6_U0.ap_continue) | ~Loop_VITIS_LOOP_226_1_proc6_U0.point3_o_blk_n;

assign inst_idle_sigs[9] = 1'b0;
assign inst_idle_sigs[10] = LoadWeights_U0.ap_idle;
assign inst_idle_sigs[11] = LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_138_1_fu_112.ap_idle;
assign inst_idle_sigs[12] = LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_144_2_fu_132.ap_idle;
assign inst_idle_sigs[13] = LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_150_3_fu_152.ap_idle;
assign inst_idle_sigs[14] = LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_156_4_fu_172.ap_idle;
assign inst_idle_sigs[15] = LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_162_5_fu_216.ap_idle;
assign inst_idle_sigs[16] = LoadWeights_U0.grp_LoadWeights_Pipeline_VITIS_LOOP_168_6_fu_250.ap_idle;
assign inst_idle_sigs[17] = LoadInput_U0.ap_idle;
assign inst_idle_sigs[18] = Loop_VITIS_LOOP_226_1_proc6_U0.ap_idle;

MNIST_hls_deadlock_idx0_monitor MNIST_hls_deadlock_idx0_monitor_U (
    .clock(kernel_monitor_clock),
    .reset(kernel_monitor_reset),
    .axis_block_sigs(axis_block_sigs),
    .inst_idle_sigs(inst_idle_sigs),
    .inst_block_sigs(inst_block_sigs),
    .block(kernel_block)
);

always @ (kernel_block or kernel_monitor_reset) begin
    if (kernel_block == 1'b1 && kernel_monitor_reset == 1'b0) begin
        find_kernel_block = 1'b1;
    end
    else begin
        find_kernel_block = 1'b0;
    end
end
