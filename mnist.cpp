#include "mnist.hpp"

template <int SIZE, int IN_CH, int OUT_CH>
void PointwiseConv2d(
    hls::stream<float> &input, const float* weights, hls::stream<float> &output)
{
    float out_buf[OUT_CH];
    #pragma HLS ARRAY_PARTITION variable=out_buf complete
    for (int py = 0; py < SIZE; py++)
    {
        for (int px = 0; px < SIZE; px++)
        {
            for (int oc = 0; oc < OUT_CH; oc++)
                #pragma HLS UNROLL
                out_buf[oc] = 0.0;
            for (int ic = 0; ic < IN_CH; ic++)
            {
                float in = input.read();
                for (int oc = 0; oc < OUT_CH; oc++)
                {
                    #pragma HLS UNROLL
                    out_buf[oc] += in * weights[oc * IN_CH + ic];
                }
            }
            for (int oc = 0; oc < OUT_CH; oc++)
                output.write(out_buf[oc] > 0 ? out_buf[oc] : 0.0);
        }
    }
}
template <int SIZE, int OUT_SIZE, int IN_CH, int KERNEL = 3>
void DepthwiseConv2d(
    hls::stream<float> &input, const float* weights, hls::stream<float> &output)
{
    float line_buf[2][SIZE + 2][IN_CH];
    float window_buf[KERNEL][KERNEL][IN_CH];
    #pragma HLS ARRAY_PARTITION variable=window_buf complete
    #pragma HLS ARRAY_PARTITION variable=line_buf complete

    py: for (int py = 0; py < OUT_SIZE; py++)
    {
        // Initialize line buffer[0]
        if (py != 0)
        {
            for (int ic = 0; ic < IN_CH; ic++)
                #pragma HLS UNROLL
                line_buf[0][0][ic] = 0.0;
            line0: for (int px = 1; px < SIZE + 1; px++)
                #pragma HLS UNROLL
                for (int ic = 0; ic < IN_CH; ic++)
                    line_buf[0][px][ic] = input.read();
            for (int ic = 0; ic < IN_CH; ic++)
                #pragma HLS UNROLL
                line_buf[0][SIZE+1][ic] = 0.0;
        }
        else
        {
            for (int px = 0; px < SIZE + 2; px++)
                #pragma HLS UNROLL
                for (int ic = 0; ic < IN_CH; ic++)
                    line_buf[0][px][ic] = 0.0;
        }
        // Initialize line buffer[1]
        for (int ic = 0; ic < IN_CH; ic++)
            #pragma HLS UNROLL
            line_buf[1][0][ic] = 0.0;
        line1: for (int px = 1; px < SIZE + 1; px++)
            #pragma HLS UNROLL
            for (int ic = 0; ic < IN_CH; ic++)
                line_buf[1][px][ic] = input.read();
        for (int ic = 0; ic < IN_CH; ic++)
            #pragma HLS UNROLL
            line_buf[1][SIZE+1][ic] = 0.0;
        // Iterate over px
        px: for (int px = 0; px < OUT_SIZE; px++)
        {
			#pragma HLS PIPELINE II=1
            // Set Window Buffer
            win1: for (int ky = 0; ky < KERNEL - 1; ky++)
                for (int kx = 0; kx < KERNEL; kx++)
                    for (int ic = 0; ic < IN_CH; ic++)
                        window_buf[ky][kx][ic] = line_buf[ky][kx + px * KERNEL][ic];
            win2: for (int kx = 0; kx < KERNEL; kx++)
                for (int ic = 0; ic < IN_CH; ic++)
                    if ((px == 0 && kx == 0)
                        || (px == OUT_SIZE - 1 && kx == KERNEL - 1) || (py == OUT_SIZE - 1))
                    	window_buf[2][kx][ic] = 0.0;
                    else
                        window_buf[2][kx][ic] = input.read();
            // Convolution
            conv: for (int ic = 0; ic < IN_CH; ic++)
            {
                float out = 0.0;
                for (int ky = 0; ky < KERNEL; ky++)
                    for (int kx = 0; kx < KERNEL; kx++)
                        out += window_buf[ky][kx][ic] * weights[ic * KERNEL * KERNEL + ky * KERNEL + kx];
                output.write(out);
            }
        }
    }
}

template <int SIZE = 4, int OUT_SIZE = 1, int IN_CH = 12, int KERNEL = 4>
void DepthwiseConv2dFinal(hls::stream<float> &input, const float* weights, hls::stream<float> &output)
{
    float input_buf[SIZE][SIZE][IN_CH];
    #pragma HLS ARRAY_PARTITION variable=input_buf complete
    for (int py = 0; py < SIZE; py++)
    {
        for (int px = 0; px < SIZE; px++)
        {
            for (int ic = 0; ic < IN_CH; ic++)
            {
                input_buf[py][px][ic] = input.read();
            }
        }
    }
    for (int ic = 0; ic < IN_CH; ic++)
    {
        float out = 0.0;
        for (int ky = 0; ky < KERNEL; ky++)
        {
            for (int kx = 0; kx < KERNEL; kx++)
            {
                out += input_buf[ky][kx][ic] * weights[ic * KERNEL * KERNEL + ky * KERNEL + kx];
            }
        }
        output.write(out);
    }
}

void LoadWeights(
    hls::stream<StreamPix> &istrm, float *depth1, float *point1, float *depth2, float *point2, float *depth3, float *point3)
{
    StreamPix pix;
    fp_int fi;
    for (int i = 0; i < CH1 * KERNEL1 * KERNEL1; i++)
    {
        pix = istrm.read();
        fi.i = pix.data;
        depth1[i] = fi.f;
    }
    for (int i = 0; i < CH2 * CH1; i++)
    {
        pix = istrm.read();
        fi.i = pix.data;
        point1[i] = fi.f;
    }
    for (int i = 0; i < CH2 * KERNEL1 * KERNEL1; i++)
    {
        pix = istrm.read();
        fi.i = pix.data;
        depth2[i] = fi.f;
    }
    for (int i = 0; i < CH3 * CH2; i++)
    {
        pix = istrm.read();
        fi.i = pix.data;
        point2[i] = fi.f;
    }
    for (int i = 0; i < CH3 * KERNEL2 * KERNEL2; i++)
    {
        pix = istrm.read();
        fi.i = pix.data;
        depth3[i] = fi.f;
    }
    for (int i = 0; i < CH4 * CH3; i++)
    {
        pix = istrm.read();
        fi.i = pix.data;
        point3[i] = fi.f;
    }
}

StreamPix LoadInput(
    hls::stream<StreamPix> &istrm, hls::stream<float> &input)
{
    StreamPix pix;
    fp_int fi;
    for (int i = 0; i < SIZE1 * SIZE1; i++)
    {
        pix = istrm.read();
        fi.i = pix.data;
        input.write(fi.f);
    }
    return pix;
}

void MNIST(
            hls::stream<StreamPix> &istrm,
            hls::stream<StreamPix> &wstrm,
            hls::stream<StreamPix> &ostrm)
{
#pragma HLS INTERFACE s_axilite port=return bundle=CONTROL_BUS
#pragma HLS INTERFACE axis port=istrm
#pragma HLS INTERFACE axis port=ostrm
#pragma HLS INTERFACE axis port=wstrm

    hls::stream<float> input("input");
    hls::stream<float> depth1_o("depth1_o"), point1_o("point1_o"), depth2_o("depth2_o"), point2_o("point2_o"), depth3_o("depth3_o"), point3_o("point3_o");

    float depth1_w[KERNEL1 * KERNEL1 * CH1];
    float point1_w[CH2 * CH1];
    float depth2_w[KERNEL1 * KERNEL1 * CH2];
    float point2_w[CH3 * CH2];
    float depth3_w[KERNEL2 * KERNEL2 * CH3];
    float point3_w[CH4 * CH3];

    #pragma HLS dataflow

    LoadWeights(wstrm, depth1_w, point1_w, depth2_w, point2_w, depth3_w, point3_w);

    StreamPix pix = LoadInput(istrm, input);

    DepthwiseConv2d<SIZE1, SIZE2, CH1>(input, depth1_w, depth1_o);
    PointwiseConv2d<SIZE2, CH1, CH2>(depth1_o, point1_w, point1_o);
    DepthwiseConv2d<SIZE2, SIZE3, CH2>(point1_o, depth2_w, depth2_o);
    PointwiseConv2d<SIZE3, CH2, CH3>(depth2_o, point2_w, point2_o);
    DepthwiseConv2dFinal(point2_o, depth3_w, depth3_o);
    PointwiseConv2d<SIZE4, CH3, CH4>(depth3_o, point3_w, point3_o);

    // output
    {
        fp_int fi;
        for (int i = 0; i < 10; i++)
        {
            fi.f = point3_o.read();
            pix.data = fi.i;
            if (i == 9)
                pix.last = true;
            else
                pix.last = false;
            ostrm.write(pix);
        }
    }
}
