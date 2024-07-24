// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
/***************************** Include Files *********************************/
#include "xmnist.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XMnist_CfgInitialize(XMnist *InstancePtr, XMnist_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_bus_BaseAddress = ConfigPtr->Control_bus_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XMnist_Start(XMnist *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMnist_ReadReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_AP_CTRL) & 0x80;
    XMnist_WriteReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_AP_CTRL, Data | 0x01);
}

u32 XMnist_IsDone(XMnist *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMnist_ReadReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XMnist_IsIdle(XMnist *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMnist_ReadReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XMnist_IsReady(XMnist *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMnist_ReadReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XMnist_EnableAutoRestart(XMnist *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMnist_WriteReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_AP_CTRL, 0x80);
}

void XMnist_DisableAutoRestart(XMnist *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMnist_WriteReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_AP_CTRL, 0);
}

void XMnist_InterruptGlobalEnable(XMnist *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMnist_WriteReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_GIE, 1);
}

void XMnist_InterruptGlobalDisable(XMnist *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMnist_WriteReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_GIE, 0);
}

void XMnist_InterruptEnable(XMnist *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XMnist_ReadReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_IER);
    XMnist_WriteReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_IER, Register | Mask);
}

void XMnist_InterruptDisable(XMnist *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XMnist_ReadReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_IER);
    XMnist_WriteReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_IER, Register & (~Mask));
}

void XMnist_InterruptClear(XMnist *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    //XMnist_WriteReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_ISR, Mask);
}

u32 XMnist_InterruptGetEnabled(XMnist *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XMnist_ReadReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_IER);
}

u32 XMnist_InterruptGetStatus(XMnist *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    // Current Interrupt Clear Behavior is Clear on Read(COR).
    return XMnist_ReadReg(InstancePtr->Control_bus_BaseAddress, XMNIST_CONTROL_BUS_ADDR_ISR);
}

