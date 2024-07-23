#pragma once
#include <hls_stream.h>
#include <ap_axi_sdata.h>

typedef ap_axis<32, 2, 5, 6> StreamPix;

union fp_int
{
    int i;
    float f;
};

const int CH1 = 1;
const int CH2 = 4;
const int CH3 = 12;
const int CH4 = 10;
const int SIZE1 = 28;
const int SIZE2 = 10;
const int SIZE3 = 4;
const int SIZE4 = 1;
const int KERNEL1 = 3;
const int KERNEL2 = 4;
