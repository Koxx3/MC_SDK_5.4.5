/**
  * @page STEVAL-HKI001V2 example 
  * 
  * @verbatim
  ******************** (C) COPYRIGHT 2019 STMicroelectronics *******************
  * @file    STEVAL-HKI001V2\Demonstration\CRB\SDK54x-GAPDrive_CRB_ACEPACK_F303_560V.stmcx
  * @author  Motor Control SDK Team
  * @brief   STEVAL-HKI001V2 board with CRB motor example.
  ********************************************************************************
  * This notice applies to any and all portions of this file
  * that are not between comment pairs USER CODE BEGIN and
  * USER CODE END. Other portions of this file, whether 
  * inserted by the user or by software development tools
  * are owned by their respective copyright owners.
  *
  * Copyright (c) 2019 STMicroelectronics International N.V. 
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without 
  * modification, are permitted, provided that the following conditions are met:
  *
  * 1. Redistribution of source code must retain the above copyright notice, 
  *    this list of conditions and the following disclaimer.
  * 2. Redistributions in binary form must reproduce the above copyright notice,
  *    this list of conditions and the following disclaimer in the documentation
  *    and/or other materials provided with the distribution.
  * 3. Neither the name of STMicroelectronics nor the names of other 
  *    contributors to this software may be used to endorse or promote products 
  *    derived from this software without specific written permission.
  * 4. This software, including modifications and/or derivative works of this 
  *    software, must execute solely and exclusively on microcontroller or
  *    microprocessor devices manufactured by or for STMicroelectronics.
  * 5. Redistribution and use of this software other than as permitted under 
  *    this license is void and will automatically terminate your rights under 
  *    this license. 
  *
  * THIS SOFTWARE IS PROVIDED BY STMICROELECTRONICS AND CONTRIBUTORS "AS IS" 
  * AND ANY EXPRESS, IMPLIED OR STATUTORY WARRANTIES, INCLUDING, BUT NOT 
  * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
  * PARTICULAR PURPOSE AND NON-INFRINGEMENT OF THIRD PARTY INTELLECTUAL PROPERTY
  * RIGHTS ARE DISCLAIMED TO THE FULLEST EXTENT PERMITTED BY LAW. IN NO EVENT 
  * SHALL STMICROELECTRONICS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
  * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
  * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
  * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
  * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  ******************************************************************************
  * @endverbatim
  *
  * @par Demonstration description 
  * 
  *  This demonstration presents motor control application running on 
  * a STEVAL-HKI001V2 board 
  *
  * The application features a STGAP1AS used as driver.
  * The addition in this example comparing to the selection of the inverter board in a new project
  * is the usage of the Timer Break input connected to the Pin PA6.
  * 
  *
  * @par Directory contents 
  * 
  * 
  * @par Hardware and Software environment 
  * 
  * This demonstration runs on the following Hardware Setup:
  * 
  *
  * The following software tools are needed to run the application:
  *
  * - ST Motor Control SDK, version 5.4.2 or later
  * - STM32CubeMx, version 5.4.0 or later
  * - STM32Cube FW Package for STM32F3 Series, version 1.11 
  * - IAR EWARM or Keil uVision 5.
  *
  * Note that the current version of this example does not work with STM32CubeIDE 1.0.0.
  *
  * @par How to build it ? 
  * 
  * In order to build the demonstration program, the following is to be done:
  *
  * 1. Open the SDK54x-GAPDrive_CRB_ACEPACK_F303_560V.stmcx file with the STM32 Motor Control Workbench PC software 
  *    tool and save it to another, empty, location.
  *    BEWARE: Do not change the name of the SDK54x-GAPDrive_CRB_ACEPACK_F303_560V.stmcx file, otherwise the example 
  *    will not work properly;
  * 2. Click the Tool -> Generation menu item. This opens a dialog window that lets the users choose
  *    various parameters. Select version 5.4.0 or later for STM32CubeMx, IAR EWARM or Keil MDK Arm 
  *    for the Target toolchain and STM32 FW V1.11 or later for the Firmware Package version. Make 
  *    sure to check the HAL - Hardware Abstraction Layer box for the Drive Type. Then, click on the
  *    UPDATE button.
  * 3. Open the generated project with the target IDE;
  * 4. Build the project and load the resulting binary image into your MCU board;
  * 5. Reset your MCU board;
  * 6. Run the example. 
  * 
  * ******************** (C) COPYRIGHT 2019 STMicroelectronics *******************
  **/