   
    parameter PROC_NUM = 9;
    parameter ST_IDLE = 3'b000;
    parameter ST_FILTER_FAKE = 3'b001;
    parameter ST_DL_DETECTED = 3'b010;
    parameter ST_DL_REPORT = 3'b100;
   

    reg [2:0] CS_fsm;
    reg [2:0] NS_fsm;
    reg [PROC_NUM - 1:0] dl_detect_reg;
    reg [PROC_NUM - 1:0] dl_done_reg;
    reg [PROC_NUM - 1:0] origin_reg;
    reg [PROC_NUM - 1:0] dl_in_vec_reg;
    reg [31:0] dl_keep_cnt;
    integer i;
    integer fp;

    // FSM State machine
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            CS_fsm <= ST_IDLE;
        end
        else begin
            CS_fsm <= NS_fsm;
        end
    end
    always @ (CS_fsm or dl_in_vec or dl_detect_reg or dl_done_reg or dl_in_vec or origin_reg or dl_keep_cnt) begin
        case (CS_fsm)
            ST_IDLE : begin
                if (|dl_in_vec) begin
                    NS_fsm = ST_FILTER_FAKE;
                end
                else begin
                    NS_fsm = ST_IDLE;
                end
            end
            ST_FILTER_FAKE: begin
                if (dl_keep_cnt >= 32'd1000) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else if (dl_detect_reg != (dl_detect_reg & dl_in_vec)) begin
                    NS_fsm = ST_IDLE;
                end
                else begin
                    NS_fsm = ST_FILTER_FAKE;
                end
            end
            ST_DL_DETECTED: begin
                // has unreported deadlock cycle
                if (dl_detect_reg != dl_done_reg) begin
                    NS_fsm = ST_DL_REPORT;
                end
                else begin
                    NS_fsm = ST_DL_DETECTED;
                end
            end
            ST_DL_REPORT: begin
                if (|(dl_in_vec & origin_reg)) begin
                    NS_fsm = ST_DL_DETECTED;
                end
                else begin
                    NS_fsm = ST_DL_REPORT;
                end
            end
            default: NS_fsm = ST_IDLE;
        endcase
    end

    // dl_detect_reg record the procs that first detect deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_detect_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_IDLE) begin
                dl_detect_reg <= dl_in_vec;
            end
        end
    end

    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_keep_cnt <= 32'h0;
        end
        else begin
            if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg == (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= dl_keep_cnt + 32'h1;
            end
            else if (CS_fsm == ST_FILTER_FAKE && (dl_detect_reg != (dl_detect_reg & dl_in_vec))) begin
                dl_keep_cnt <= 32'h0;
            end
        end
    end

    // dl_detect_out keeps in high after deadlock detected
    assign dl_detect_out = (|dl_detect_reg) && (CS_fsm == ST_DL_DETECTED || CS_fsm == ST_DL_REPORT);

    // dl_done_reg record the cycles has been reported
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_done_reg <= 'b0;
        end
        else begin
            if ((CS_fsm == ST_DL_REPORT) && (|(dl_in_vec & dl_detect_reg) == 'b1)) begin
                dl_done_reg <= dl_done_reg | dl_in_vec;
            end
        end
    end

    // clear token once a cycle is done
    assign token_clear = (CS_fsm == ST_DL_REPORT) ? ((|(dl_in_vec & origin_reg)) ? 'b1 : 'b0) : 'b0;

    // origin_reg record the current cycle start id
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            origin_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                origin_reg <= origin;
            end
        end
    end
   
    // origin will be valid for only one cycle
    wire [PROC_NUM*PROC_NUM - 1:0] origin_tmp;
    assign origin_tmp[PROC_NUM - 1:0] = (dl_detect_reg[0] & ~dl_done_reg[0]) ? 'b1 : 'b0;
    genvar j;
    generate
    for(j = 1;j < PROC_NUM;j = j + 1) begin: F1
        assign origin_tmp[j*PROC_NUM +: PROC_NUM] = (dl_detect_reg[j] & ~dl_done_reg[j]) ? ('b1 << j) : origin_tmp[(j - 1)*PROC_NUM +: PROC_NUM];
    end
    endgenerate
    always @ (CS_fsm or origin_tmp) begin
        if (CS_fsm == ST_DL_DETECTED) begin
            origin = origin_tmp[(PROC_NUM - 1)*PROC_NUM +: PROC_NUM];
        end
        else begin
            origin = 'b0;
        end
    end

    
    // dl_in_vec_reg record the current cycle dl_in_vec
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            dl_in_vec_reg <= 'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED) begin
                dl_in_vec_reg <= origin;
            end
            else if (CS_fsm == ST_DL_REPORT) begin
                dl_in_vec_reg <= dl_in_vec;
            end
        end
    end
    
    // find_df_deadlock to report the deadlock
    always @ (negedge dl_reset or posedge dl_clock) begin
        if (~dl_reset) begin
            find_df_deadlock <= 1'b0;
        end
        else begin
            if (CS_fsm == ST_DL_DETECTED && dl_detect_reg == dl_done_reg) begin
                find_df_deadlock <= 1'b1;
            end
            else if (CS_fsm == ST_IDLE) begin
                find_df_deadlock <= 1'b0;
            end
        end
    end
    
    // get the first valid proc index in dl vector
    function integer proc_index(input [PROC_NUM - 1:0] dl_vec);
        begin
            proc_index = 0;
            for (i = 0; i < PROC_NUM; i = i + 1) begin
                if (dl_vec[i]) begin
                    proc_index = i;
                end
            end
        end
    endfunction

    // get the proc path based on dl vector
    function [392:0] proc_path(input [PROC_NUM - 1:0] dl_vec);
        integer index;
        begin
            index = proc_index(dl_vec);
            case (index)
                0 : begin
                    proc_path = "MNIST_MNIST.LoadWeights_U0";
                end
                1 : begin
                    proc_path = "MNIST_MNIST.LoadInput_U0";
                end
                2 : begin
                    proc_path = "MNIST_MNIST.DepthwiseConv2d_28_10_1_3_U0";
                end
                3 : begin
                    proc_path = "MNIST_MNIST.PointwiseConv2d_10_1_4_U0";
                end
                4 : begin
                    proc_path = "MNIST_MNIST.DepthwiseConv2d_10_4_4_3_U0";
                end
                5 : begin
                    proc_path = "MNIST_MNIST.PointwiseConv2d_4_4_12_U0";
                end
                6 : begin
                    proc_path = "MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0";
                end
                7 : begin
                    proc_path = "MNIST_MNIST.PointwiseConv2d_1_12_10_U0";
                end
                8 : begin
                    proc_path = "MNIST_MNIST.Loop_VITIS_LOOP_226_1_proc6_U0";
                end
                default : begin
                    proc_path = "unknown";
                end
            endcase
        end
    endfunction

    // print the headlines of deadlock detection
    task print_dl_head;
        begin
            $display("\n//////////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", $time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            fp = $fopen("deadlock_db.dat", "w");
        end
    endtask

    // print the start of a cycle
    task print_cycle_start(input reg [392:0] proc_path, input integer cycle_id);
        begin
            $display("/////////////////////////");
            $display("// Dependence cycle %0d:", cycle_id);
            $display("// (1): Process: %0s", proc_path);
            $fdisplay(fp, "Dependence_Cycle_ID %0d", cycle_id);
            $fdisplay(fp, "Dependence_Process_ID 1");
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print the end of deadlock detection
    task print_dl_end(input integer num, input integer record_time);
        begin
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// Totally %0d cycles detected!", num);
            $display("////////////////////////////////////////////////////////////////////////");
            $display("// ERROR!!! DEADLOCK DETECTED at %0t ns! SIMULATION WILL BE STOPPED! //", record_time);
            $display("//////////////////////////////////////////////////////////////////////////////");
            $fdisplay(fp, "Dependence_Cycle_Number %0d", num);
            $fclose(fp);
        end
    endtask

    // print one proc component in the cycle
    task print_cycle_proc_comp(input reg [392:0] proc_path, input integer cycle_comp_id);
        begin
            $display("// (%0d): Process: %0s", cycle_comp_id, proc_path);
            $fdisplay(fp, "Dependence_Process_ID %0d", cycle_comp_id);
            $fdisplay(fp, "Dependence_Process_path %0s", proc_path);
        end
    endtask

    // print one channel component in the cycle
    task print_cycle_chan_comp(input [PROC_NUM - 1:0] dl_vec1, input [PROC_NUM - 1:0] dl_vec2);
        reg [240:0] chan_path;
        integer index1;
        integer index2;
        begin
            index1 = proc_index(dl_vec1);
            index2 = proc_index(dl_vec2);
            case (index1)
                0 : begin
                    case(index2)
                    2: begin
                        if (~depth1_w_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth1_w_U.t_read) begin
                            if (~depth1_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth1_w_U' written by process 'MNIST_MNIST.DepthwiseConv2d_28_10_1_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth1_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth1_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth1_w_U' read by process 'MNIST_MNIST.DepthwiseConv2d_28_10_1_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth1_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    3: begin
                        if (~point1_w_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point1_w_U.t_read) begin
                            if (~point1_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point1_w_U' written by process 'MNIST_MNIST.PointwiseConv2d_10_1_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point1_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point1_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point1_w_U' read by process 'MNIST_MNIST.PointwiseConv2d_10_1_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point1_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    4: begin
                        if (~depth2_w_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth2_w_U.t_read) begin
                            if (~depth2_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth2_w_U' written by process 'MNIST_MNIST.DepthwiseConv2d_10_4_4_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth2_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth2_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth2_w_U' read by process 'MNIST_MNIST.DepthwiseConv2d_10_4_4_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth2_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    5: begin
                        if (~point2_w_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_U.t_read) begin
                            if (~point2_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_1_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_1_U.t_read) begin
                            if (~point2_w_1_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_1_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_1_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_1_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_2_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_2_U.t_read) begin
                            if (~point2_w_2_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_2_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_2_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_2_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_3_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_3_U.t_read) begin
                            if (~point2_w_3_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_3_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_3_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_3_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_4_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_4_U.t_read) begin
                            if (~point2_w_4_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_4_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_4_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_4_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_5_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_5_U.t_read) begin
                            if (~point2_w_5_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_5_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_5_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_5_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_6_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_6_U.t_read) begin
                            if (~point2_w_6_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_6_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_6_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_6_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_7_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_7_U.t_read) begin
                            if (~point2_w_7_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_7_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_7_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_7_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_8_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_8_U.t_read) begin
                            if (~point2_w_8_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_8_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_8_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_8_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_8_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_8_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_9_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_9_U.t_read) begin
                            if (~point2_w_9_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_9_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_9_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_9_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_10_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_10_U.t_read) begin
                            if (~point2_w_10_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_10_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_10_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_10_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_11_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_11_U.t_read) begin
                            if (~point2_w_11_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_11_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_11_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_11_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_12_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point2_w_12_U.t_read) begin
                            if (~point2_w_12_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_12_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_12_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_12_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    6: begin
                        if (~depth3_w_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth3_w_U.t_read) begin
                            if (~depth3_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_1_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth3_w_1_U.t_read) begin
                            if (~depth3_w_1_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_1_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_1_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_1_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_2_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth3_w_2_U.t_read) begin
                            if (~depth3_w_2_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_2_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_2_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_2_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_3_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth3_w_3_U.t_read) begin
                            if (~depth3_w_3_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_3_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_3_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_3_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_4_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth3_w_4_U.t_read) begin
                            if (~depth3_w_4_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_4_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_4_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_4_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_5_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth3_w_5_U.t_read) begin
                            if (~depth3_w_5_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_5_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_5_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_5_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_6_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth3_w_6_U.t_read) begin
                            if (~depth3_w_6_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_6_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_6_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_6_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_7_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~depth3_w_7_U.t_read) begin
                            if (~depth3_w_7_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_7_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_7_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_7_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    7: begin
                        if (~point3_w_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_U.t_read) begin
                            if (~point3_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_1_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_1_U.t_read) begin
                            if (~point3_w_1_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_1_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_1_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_1_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_2_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_2_U.t_read) begin
                            if (~point3_w_2_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_2_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_2_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_2_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_3_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_3_U.t_read) begin
                            if (~point3_w_3_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_3_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_3_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_3_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_4_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_4_U.t_read) begin
                            if (~point3_w_4_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_4_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_4_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_4_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_5_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_5_U.t_read) begin
                            if (~point3_w_5_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_5_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_5_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_5_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_6_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_6_U.t_read) begin
                            if (~point3_w_6_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_6_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_6_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_6_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_7_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_7_U.t_read) begin
                            if (~point3_w_7_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_7_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_7_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_7_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_8_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_8_U.t_read) begin
                            if (~point3_w_8_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_8_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_8_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_8_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_8_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_8_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_9_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_9_U.t_read) begin
                            if (~point3_w_9_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_9_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_9_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_9_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_10_U.i_full_n & LoadWeights_U0.ap_done & ap_done_reg_0 & ~point3_w_10_U.t_read) begin
                            if (~point3_w_10_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_10_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_10_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_10_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    1: begin
                        if (ap_sync_LoadWeights_U0_ap_ready & LoadWeights_U0.ap_idle & ~ap_sync_LoadInput_U0_ap_ready) begin
                            $display("//      Blocked by input sync logic with process : 'MNIST_MNIST.LoadInput_U0'");
                        end
                    end
                    endcase
                end
                1 : begin
                    case(index2)
                    2: begin
                        if (~LoadInput_U0.input74_blk_n) begin
                            if (~input_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.input_U' written by process 'MNIST_MNIST.DepthwiseConv2d_28_10_1_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.input_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~input_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.input_U' read by process 'MNIST_MNIST.DepthwiseConv2d_28_10_1_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.input_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (ap_sync_LoadInput_U0_ap_ready & LoadInput_U0.ap_idle & ~ap_sync_LoadWeights_U0_ap_ready) begin
                            $display("//      Blocked by input sync logic with process : 'MNIST_MNIST.LoadWeights_U0'");
                        end
                    end
                    endcase
                end
                2 : begin
                    case(index2)
                    1: begin
                        if (~DepthwiseConv2d_28_10_1_3_U0.input74_blk_n) begin
                            if (~input_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.input_U' written by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.input_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~input_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.input_U' read by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.input_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (~depth1_w_U.t_empty_n & DepthwiseConv2d_28_10_1_3_U0.ap_idle & ~depth1_w_U.i_write) begin
                            if (~depth1_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth1_w_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth1_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth1_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth1_w_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth1_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    3: begin
                        if (~DepthwiseConv2d_28_10_1_3_U0.grp_DepthwiseConv2d_28_10_1_3_Pipeline_px_fu_652.depth1_o75_blk_n) begin
                            if (~depth1_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.depth1_o_U' written by process 'MNIST_MNIST.PointwiseConv2d_10_1_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth1_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth1_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.depth1_o_U' read by process 'MNIST_MNIST.PointwiseConv2d_10_1_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth1_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                3 : begin
                    case(index2)
                    2: begin
                        if (~PointwiseConv2d_10_1_4_U0.grp_PointwiseConv2d_10_1_4_Pipeline_py_px_fu_73.depth1_o75_blk_n) begin
                            if (~depth1_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.depth1_o_U' written by process 'MNIST_MNIST.DepthwiseConv2d_28_10_1_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth1_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth1_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.depth1_o_U' read by process 'MNIST_MNIST.DepthwiseConv2d_28_10_1_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth1_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (~point1_w_U.t_empty_n & PointwiseConv2d_10_1_4_U0.ap_idle & ~point1_w_U.i_write) begin
                            if (~point1_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point1_w_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point1_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point1_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point1_w_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point1_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    4: begin
                        if (~PointwiseConv2d_10_1_4_U0.grp_PointwiseConv2d_10_1_4_Pipeline_py_px_fu_73.point1_o76_blk_n) begin
                            if (~point1_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.point1_o_U' written by process 'MNIST_MNIST.DepthwiseConv2d_10_4_4_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point1_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point1_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.point1_o_U' read by process 'MNIST_MNIST.DepthwiseConv2d_10_4_4_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point1_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                4 : begin
                    case(index2)
                    3: begin
                        if (~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_VITIS_LOOP_69_728_fu_830.point1_o76_blk_n) begin
                            if (~point1_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.point1_o_U' written by process 'MNIST_MNIST.PointwiseConv2d_10_1_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point1_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point1_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.point1_o_U' read by process 'MNIST_MNIST.PointwiseConv2d_10_1_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point1_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (~depth2_w_U.t_empty_n & DepthwiseConv2d_10_4_4_3_U0.ap_idle & ~depth2_w_U.i_write) begin
                            if (~depth2_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth2_w_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth2_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth2_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth2_w_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth2_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    5: begin
                        if (~DepthwiseConv2d_10_4_4_3_U0.grp_DepthwiseConv2d_10_4_4_3_Pipeline_px_fu_851.depth2_o77_blk_n) begin
                            if (~depth2_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.depth2_o_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth2_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth2_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.depth2_o_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth2_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                5 : begin
                    case(index2)
                    4: begin
                        if (~PointwiseConv2d_4_4_12_U0.grp_PointwiseConv2d_4_4_12_Pipeline_ic_fu_288.depth2_o77_blk_n) begin
                            if (~depth2_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.depth2_o_U' written by process 'MNIST_MNIST.DepthwiseConv2d_10_4_4_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth2_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth2_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.depth2_o_U' read by process 'MNIST_MNIST.DepthwiseConv2d_10_4_4_3_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth2_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (~point2_w_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_U.i_write) begin
                            if (~point2_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_1_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_1_U.i_write) begin
                            if (~point2_w_1_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_1_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_1_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_1_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_2_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_2_U.i_write) begin
                            if (~point2_w_2_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_2_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_2_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_2_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_3_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_3_U.i_write) begin
                            if (~point2_w_3_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_3_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_3_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_3_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_4_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_4_U.i_write) begin
                            if (~point2_w_4_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_4_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_4_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_4_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_5_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_5_U.i_write) begin
                            if (~point2_w_5_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_5_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_5_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_5_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_6_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_6_U.i_write) begin
                            if (~point2_w_6_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_6_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_6_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_6_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_7_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_7_U.i_write) begin
                            if (~point2_w_7_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_7_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_7_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_7_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_8_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_8_U.i_write) begin
                            if (~point2_w_8_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_8_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_8_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_8_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_8_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_8_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_9_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_9_U.i_write) begin
                            if (~point2_w_9_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_9_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_9_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_9_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_10_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_10_U.i_write) begin
                            if (~point2_w_10_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_10_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_10_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_10_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_11_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_11_U.i_write) begin
                            if (~point2_w_11_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_11_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_11_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_11_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_11_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_11_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point2_w_12_U.t_empty_n & PointwiseConv2d_4_4_12_U0.ap_idle & ~point2_w_12_U.i_write) begin
                            if (~point2_w_12_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point2_w_12_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_12_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_w_12_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point2_w_12_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_w_12_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    6: begin
                        if (~PointwiseConv2d_4_4_12_U0.grp_PointwiseConv2d_4_4_12_Pipeline_VITIS_LOOP_25_2_fu_344.point2_o78_blk_n) begin
                            if (~point2_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.point2_o_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.point2_o_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                6 : begin
                    case(index2)
                    5: begin
                        if (~DepthwiseConv2dFinal_4_1_12_4_U0.grp_DepthwiseConv2dFinal_4_1_12_4_Pipeline_ld_VITIS_LOOP_110_1_VITIS_LOOP_112_2_fu_54.point2_o78_blk_n) begin
                            if (~point2_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.point2_o_U' written by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point2_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.point2_o_U' read by process 'MNIST_MNIST.PointwiseConv2d_4_4_12_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point2_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (~depth3_w_U.t_empty_n & DepthwiseConv2dFinal_4_1_12_4_U0.ap_idle & ~depth3_w_U.i_write) begin
                            if (~depth3_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_1_U.t_empty_n & DepthwiseConv2dFinal_4_1_12_4_U0.ap_idle & ~depth3_w_1_U.i_write) begin
                            if (~depth3_w_1_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_1_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_1_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_1_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_2_U.t_empty_n & DepthwiseConv2dFinal_4_1_12_4_U0.ap_idle & ~depth3_w_2_U.i_write) begin
                            if (~depth3_w_2_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_2_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_2_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_2_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_3_U.t_empty_n & DepthwiseConv2dFinal_4_1_12_4_U0.ap_idle & ~depth3_w_3_U.i_write) begin
                            if (~depth3_w_3_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_3_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_3_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_3_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_4_U.t_empty_n & DepthwiseConv2dFinal_4_1_12_4_U0.ap_idle & ~depth3_w_4_U.i_write) begin
                            if (~depth3_w_4_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_4_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_4_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_4_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_5_U.t_empty_n & DepthwiseConv2dFinal_4_1_12_4_U0.ap_idle & ~depth3_w_5_U.i_write) begin
                            if (~depth3_w_5_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_5_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_5_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_5_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_6_U.t_empty_n & DepthwiseConv2dFinal_4_1_12_4_U0.ap_idle & ~depth3_w_6_U.i_write) begin
                            if (~depth3_w_6_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_6_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_6_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_6_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~depth3_w_7_U.t_empty_n & DepthwiseConv2dFinal_4_1_12_4_U0.ap_idle & ~depth3_w_7_U.i_write) begin
                            if (~depth3_w_7_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.depth3_w_7_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_w_7_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.depth3_w_7_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    7: begin
                        if (~DepthwiseConv2dFinal_4_1_12_4_U0.grp_DepthwiseConv2dFinal_4_1_12_4_Pipeline_conv_fu_68.depth3_o79_blk_n) begin
                            if (~depth3_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.depth3_o_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.depth3_o_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                7 : begin
                    case(index2)
                    6: begin
                        if (~PointwiseConv2d_1_12_10_U0.grp_PointwiseConv2d_1_12_10_Pipeline_ic_fu_84.depth3_o79_blk_n) begin
                            if (~depth3_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.depth3_o_U' written by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~depth3_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.depth3_o_U' read by process 'MNIST_MNIST.DepthwiseConv2dFinal_4_1_12_4_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.depth3_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    0: begin
                        if (~point3_w_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_U.i_write) begin
                            if (~point3_w_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_1_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_1_U.i_write) begin
                            if (~point3_w_1_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_1_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_1_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_1_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_1_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_2_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_2_U.i_write) begin
                            if (~point3_w_2_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_2_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_2_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_2_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_2_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_3_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_3_U.i_write) begin
                            if (~point3_w_3_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_3_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_3_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_3_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_3_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_4_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_4_U.i_write) begin
                            if (~point3_w_4_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_4_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_4_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_4_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_4_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_5_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_5_U.i_write) begin
                            if (~point3_w_5_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_5_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_5_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_5_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_5_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_6_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_6_U.i_write) begin
                            if (~point3_w_6_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_6_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_6_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_6_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_6_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_7_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_7_U.i_write) begin
                            if (~point3_w_7_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_7_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_7_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_7_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_7_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_8_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_8_U.i_write) begin
                            if (~point3_w_8_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_8_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_8_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_8_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_8_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_8_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_9_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_9_U.i_write) begin
                            if (~point3_w_9_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_9_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_9_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_9_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_9_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_9_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~point3_w_10_U.t_empty_n & PointwiseConv2d_1_12_10_U0.ap_idle & ~point3_w_10_U.i_write) begin
                            if (~point3_w_10_U.t_empty_n) begin
                                $display("//      Blocked by empty input PIPO 'MNIST_MNIST.point3_w_10_U' written by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_10_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_w_10_U.i_full_n) begin
                                $display("//      Blocked by full output PIPO 'MNIST_MNIST.point3_w_10_U' read by process 'MNIST_MNIST.LoadWeights_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_w_10_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    8: begin
                        if (~PointwiseConv2d_1_12_10_U0.grp_PointwiseConv2d_1_12_10_Pipeline_VITIS_LOOP_25_2_fu_122.point3_o80_blk_n) begin
                            if (~point3_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.point3_o_U' written by process 'MNIST_MNIST.Loop_VITIS_LOOP_226_1_proc6_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.point3_o_U' read by process 'MNIST_MNIST.Loop_VITIS_LOOP_226_1_proc6_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
                8 : begin
                    case(index2)
                    1: begin
                        if (~pix_keep_V_U.if_empty_n & Loop_VITIS_LOOP_226_1_proc6_U0.ap_idle & ~pix_keep_V_U.if_write) begin
                            if (~pix_keep_V_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.pix_keep_V_U' written by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_keep_V_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~pix_keep_V_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.pix_keep_V_U' read by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_keep_V_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~pix_strb_V_U.if_empty_n & Loop_VITIS_LOOP_226_1_proc6_U0.ap_idle & ~pix_strb_V_U.if_write) begin
                            if (~pix_strb_V_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.pix_strb_V_U' written by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_strb_V_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~pix_strb_V_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.pix_strb_V_U' read by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_strb_V_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~pix_user_V_U.if_empty_n & Loop_VITIS_LOOP_226_1_proc6_U0.ap_idle & ~pix_user_V_U.if_write) begin
                            if (~pix_user_V_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.pix_user_V_U' written by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_user_V_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~pix_user_V_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.pix_user_V_U' read by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_user_V_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~pix_id_V_U.if_empty_n & Loop_VITIS_LOOP_226_1_proc6_U0.ap_idle & ~pix_id_V_U.if_write) begin
                            if (~pix_id_V_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.pix_id_V_U' written by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_id_V_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~pix_id_V_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.pix_id_V_U' read by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_id_V_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                        if (~pix_dest_V_U.if_empty_n & Loop_VITIS_LOOP_226_1_proc6_U0.ap_idle & ~pix_dest_V_U.if_write) begin
                            if (~pix_dest_V_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.pix_dest_V_U' written by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_dest_V_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~pix_dest_V_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.pix_dest_V_U' read by process 'MNIST_MNIST.LoadInput_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.pix_dest_V_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    7: begin
                        if (~Loop_VITIS_LOOP_226_1_proc6_U0.point3_o_blk_n) begin
                            if (~point3_o_U.if_empty_n) begin
                                $display("//      Blocked by empty input FIFO 'MNIST_MNIST.point3_o_U' written by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_o_U");
                                $fdisplay(fp, "Dependence_Channel_status EMPTY");
                            end
                            else if (~point3_o_U.if_full_n) begin
                                $display("//      Blocked by full output FIFO 'MNIST_MNIST.point3_o_U' read by process 'MNIST_MNIST.PointwiseConv2d_1_12_10_U0'");
                                $fdisplay(fp, "Dependence_Channel_path MNIST_MNIST.point3_o_U");
                                $fdisplay(fp, "Dependence_Channel_status FULL");
                            end
                        end
                    end
                    endcase
                end
            endcase
        end
    endtask

    // report
    initial begin : report_deadlock
        integer cycle_id;
        integer cycle_comp_id;
        integer record_time;
        wait (dl_reset == 1);
        cycle_id = 1;
        record_time = 0;
        while (1) begin
            @ (negedge dl_clock);
            case (CS_fsm)
                ST_DL_DETECTED: begin
                    cycle_comp_id = 2;
                    if (dl_detect_reg != dl_done_reg) begin
                        if (dl_done_reg == 'b0) begin
                            print_dl_head;
                            record_time = $time;
                        end
                        print_cycle_start(proc_path(origin), cycle_id);
                        cycle_id = cycle_id + 1;
                    end
                    else begin
                        print_dl_end((cycle_id - 1),record_time);
                        @(negedge dl_clock);
                        @(negedge dl_clock);
                        $finish;
                    end
                end
                ST_DL_REPORT: begin
                    if ((|(dl_in_vec)) & ~(|(dl_in_vec & origin_reg))) begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                        print_cycle_proc_comp(proc_path(dl_in_vec), cycle_comp_id);
                        cycle_comp_id = cycle_comp_id + 1;
                    end
                    else begin
                        print_cycle_chan_comp(dl_in_vec_reg, dl_in_vec);
                    end
                end
            endcase
        end
    end
 
