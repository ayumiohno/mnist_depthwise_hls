// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2022.1 (64-bit)
// Tool Version Limit: 2022.04
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// ==============================================================
#ifndef XMNIST_H
#define XMNIST_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xmnist_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u64 Control_bus_BaseAddress;
} XMnist_Config;
#endif

typedef struct {
    u64 Control_bus_BaseAddress;
    u32 IsReady;
} XMnist;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XMnist_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XMnist_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XMnist_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XMnist_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XMnist_Initialize(XMnist *InstancePtr, u16 DeviceId);
XMnist_Config* XMnist_LookupConfig(u16 DeviceId);
int XMnist_CfgInitialize(XMnist *InstancePtr, XMnist_Config *ConfigPtr);
#else
int XMnist_Initialize(XMnist *InstancePtr, const char* InstanceName);
int XMnist_Release(XMnist *InstancePtr);
#endif

void XMnist_Start(XMnist *InstancePtr);
u32 XMnist_IsDone(XMnist *InstancePtr);
u32 XMnist_IsIdle(XMnist *InstancePtr);
u32 XMnist_IsReady(XMnist *InstancePtr);
void XMnist_EnableAutoRestart(XMnist *InstancePtr);
void XMnist_DisableAutoRestart(XMnist *InstancePtr);


void XMnist_InterruptGlobalEnable(XMnist *InstancePtr);
void XMnist_InterruptGlobalDisable(XMnist *InstancePtr);
void XMnist_InterruptEnable(XMnist *InstancePtr, u32 Mask);
void XMnist_InterruptDisable(XMnist *InstancePtr, u32 Mask);
void XMnist_InterruptClear(XMnist *InstancePtr, u32 Mask);
u32 XMnist_InterruptGetEnabled(XMnist *InstancePtr);
u32 XMnist_InterruptGetStatus(XMnist *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
