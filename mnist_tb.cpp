#include <iostream>
#include "mnist.hpp"
#include "params.hpp"

void MNIST(
    hls::stream<StreamPix> &istrm,
    hls::stream<StreamPix> &wstrm,
    hls::stream<StreamPix> &ostrm);

template <int SIZE, int OUT_SIZE, int IN_CH, int KERNEL = 3>
void DepthwiseConv2d(
    hls::stream<float> &input, const float *weights, hls::stream<float> &output);

template <int SIZE, int IN_CH, int OUT_CH>
void PointwiseConv2d(
    hls::stream<float> &input, const float *weights, hls::stream<float> &output);

void TestMnist()
{
    float input[SIZE1 * SIZE1 * CH1];
    for (int i = 0; i < SIZE1 * SIZE1 * CH1; i++)
    {
        input[i] = (float)i / SIZE1 / SIZE1 / CH1;
    }
    float output[SIZE4 * SIZE4 * CH4];

    StreamPix pix;
    fp_int fi;
    hls::stream<StreamPix> istrm, wstrm, ostrm;

    // Load weights
    for (int i = 0; i < CH1 * KERNEL1 * KERNEL1; i++)
    {
        fi.f = depth1_w[i];
        pix.data = fi.i;
        wstrm << pix;
    }
    for (int i = 0; i < CH2 * CH1; i++)
    {
        fi.f = point1_w[i];
        pix.data = fi.i;
        wstrm << pix;
    }
    for (int i = 0; i < CH2 * KERNEL1 * KERNEL1; i++)
    {
        fi.f = depth2_w[i];
        pix.data = fi.i;
        wstrm << pix;
    }
    for (int i = 0; i < CH3 * CH2; i++)
    {
        fi.f = point2_w[i];
        pix.data = fi.i;
        wstrm << pix;
    }
    for (int i = 0; i < CH3 * KERNEL2 * KERNEL2; i++)
    {
        fi.f = depth3_w[i];
        pix.data = fi.i;
        wstrm << pix;
    }
    for (int i = 0; i < CH4 * CH3; i++)
    {
        fi.f = point3_w[i];
        pix.data = fi.i;
        wstrm << pix;
    }

    for (int i = 0; i < SIZE1 * SIZE1 * CH1; i++)
    {
        fi.f = input[i];
        pix.data = fi.i;
        istrm << pix;
    }

    MNIST(istrm, wstrm, ostrm);

    StreamPix pix_out;
    for (int i = 0; i < SIZE4 * SIZE4 * CH4; i++)
    {
        pix_out = ostrm.read();
        fi.i = pix_out.data;
        output[i] = fi.f;
        std::cout << output[i] << std::endl;
    }
}

void TestDepthwiseConv2d()
{
    float input[SIZE1 * SIZE1 * CH1];
    for (int i = 0; i < SIZE1 * SIZE1 * CH1; i++)
    {
        input[i] = (float)i / SIZE1 / SIZE1 / CH1;
    }
    float output[SIZE2 * SIZE2 * CH1];

    hls::stream<float> istrm, ostrm;
    // Load input
    for (int i = 0; i < SIZE1 * SIZE1 * CH1; i++)
    {
        istrm << input[i];
    }

    DepthwiseConv2d<SIZE1, SIZE2, CH1>(istrm, depth1_w, ostrm);

    for (int i = 0; i < SIZE2 * SIZE2 * CH1; i++)
    {
        output[i] = ostrm.read();
        std::cout << output[i] << std::endl;
    }
}

void TestPointwiseConv2d()
{
    float input[SIZE1 * SIZE1 * CH1];
    for (int i = 0; i < SIZE1 * SIZE1 * CH1; i++)
    {
        input[i] = (float)i / SIZE1 / SIZE1 / CH1;
    }

    hls::stream<float> istrm, ostrm, mid_strm;
    // Load input
    for (int i = 0; i < SIZE1 * SIZE1 * CH1; i++)
    {
        istrm << input[i];
    }

    DepthwiseConv2d<SIZE1, SIZE2, CH1>(istrm, depth1_w, mid_strm);
    PointwiseConv2d<SIZE2, CH1, CH2>(mid_strm, point1_w, ostrm);

    for (int i = 0; i < SIZE2 * SIZE2 * CH2; i++)
    {
        std::cout << ostrm.read() << "," << std::endl;
    }
}

int main()
{
    // TestPointwiseConv2d();
    // TestDepthwiseConv2d();
    TestMnist();
    return 0;
}


