// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xmnist.h"

extern XMnist_Config XMnist_ConfigTable[];

XMnist_Config *XMnist_LookupConfig(u16 DeviceId) {
	XMnist_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XMNIST_NUM_INSTANCES; Index++) {
		if (XMnist_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XMnist_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XMnist_Initialize(XMnist *InstancePtr, u16 DeviceId) {
	XMnist_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XMnist_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XMnist_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

