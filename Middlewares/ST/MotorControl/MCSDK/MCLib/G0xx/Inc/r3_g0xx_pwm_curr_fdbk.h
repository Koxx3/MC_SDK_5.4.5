/**
  ******************************************************************************
  * @file    r3_G0xx_pwm_curr_fdbk.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains all definitions and functions prototypes for the
  *          r3_G0xx_pwm_curr_fdbk component of the Motor Control SDK.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2019 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under Ultimate Liberty license
  * SLA0044, the "License"; You may not use this file except in compliance with
  * the License. You may obtain a copy of the License at:
  *                             www.st.com/SLA0044
  *
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __R3_G0XX_PWMNCURRFDBK_H
#define __R3_G0XX_PWMNCURRFDBK_H

#ifdef __cplusplus
 extern "C" {
#endif /* __cplusplus */

/* Includes ------------------------------------------------------------------*/
#include "pwm_curr_fdbk.h"

/** @addtogroup MCSDK
  * @{
  */

/** @defgroup r3_G0XX_pwm_curr_fdbk
  * @brief PWM G0XX three shunts component of the Motor Control SDK
  *
  * @{
  */

/* Exported constants --------------------------------------------------------*/



/* Exported types ------------------------------------------------------------*/

/** 
  * @brief  R3_G0XX parameters definition
  */
typedef struct
{
  TIM_TypeDef*  TIMx;                  /*!< It contains the pointer to the timer
                                           used for PWM generation. */
  GPIO_TypeDef * pwm_en_u_port;        /*!< phase u enable driver signal GPIO port */
  GPIO_TypeDef * pwm_en_v_port;        /*!< phase v enable driver signal GPIO port */
  GPIO_TypeDef * pwm_en_w_port;        /*!< phase w enable driver signal GPIO port */
  uint32_t      pwm_en_u_pin;          /*!< phase u enable driver signal pin */
  uint32_t      pwm_en_v_pin;          /*!< phase v enable driver signal pin */
  uint32_t      pwm_en_w_pin;          /*!< phase w enable driver signal pin */
  uint32_t ADCConfig[6];               /*!< store ADC sequence for the 6 sectors */
  volatile uint16_t *ADCDataReg1[6];   /*!< store ADC data register 1 address for the 6 sectors */
  volatile uint16_t *ADCDataReg2[6];   /*!< store ADC data register 2 address for the 6 sectors */
  uint16_t hDeadTime;                  /*!< Dead time in number of TIM clock
                                            cycles. If CHxN are enabled, it must
                                            contain the dead time to be generated
                                            by the microcontroller, otherwise it
                                            expresses the maximum dead time
                                            generated by driving network */
  uint16_t hTafter;                    /*!< It is the sum of dead time plus max
                                            value between rise time and noise time
                                            express in number of TIM clocks.*/
  uint16_t hTbefore;                   /*!< It is the sampling time express in
                                            number of TIM clocks.*/
  uint8_t  RepetitionCounter;         /*!< It expresses the number of PWM
                                            periods to be elapsed before compare
                                            registers are updated again. In
                                            particular:
                                            RepetitionCounter= (2* #PWM periods)-1*/
  uint8_t  ADCScandir[6];              /*!< store ADC scan direction for the 6 sectors */
  LowSideOutputsFunction_t LowSideOutputs; /*!< Low side or enabling signals 
                                                generation method are defined 
                                                here.*/ 
  
}R3_1_Params_t;

/**
  * @brief  Handle structure of the r1_G0xx_pwm_curr_fdbk Component
  */
typedef struct
{
  PWMC_Handle_t _Super;         /*!< Offset of current sensing network  */
  uint32_t PhaseAOffset;       /*!< Offset of Phase A current sensing network  */
  uint32_t PhaseBOffset;       /*!< Offset of Phase B current sensing network  */
  uint32_t PhaseCOffset;       /*!< Offset of Phase C current sensing network  */
  volatile uint32_t ADCTriggerEdge; /*!< edge trigger selection for ADC peripheral.*/
  uint16_t Half_PWMPeriod;      /*!< Half PWM Period in timer clock counts */
  volatile uint16_t ADC1_DMA_converted[2]; /* Buffer used for DMA data transfer after the ADC conversion */
  volatile uint8_t PolarizationCounter;               /*!< Number of conversions performed during the
                                                           calibration phase*/
  uint8_t  CalibSector;       /*!< the space vector sector number during calibration */
  bool ADCRegularLocked;        /*!< When it's true, we do not allow usage of ADC to do regular conversion on systick*/
  bool OverCurrentFlag;         /*!< This flag is set when an overcurrent occurs.*/
  bool OverVoltageFlag;         /*!< This flag is set when an overvoltage occurs.*/
  bool BrakeActionLock;         /*!< This flag is set to avoid that brake action is
                                     interrupted.*/
  R3_1_Params_t const * pParams_str;

}PWMC_R3_1_Handle_t;

/* Exported functions ------------------------------------------------------- */

/**
  * It initializes TIM1, ADC1, GPIO, DMA1 and NVIC for three shunt current
  * reading configuration using STM32G0x.
  */
void R3_1_Init(PWMC_R3_1_Handle_t *pHandle);

/**
  * It stores into the handler the voltage present on the
  * current feedback analog channel when no current is flowin into the
  * motor
  */
void R3_1_CurrentReadingCalibration(PWMC_Handle_t *pHdl);

/**
 * It computes and return latest converted motor phase currents
 */
void R3_1_GetPhaseCurrents(PWMC_Handle_t *pHdl, ab_t* pStator_Currents);

/**
  * Configure the ADC for the current sampling related to sector 1.
  * It means set the sampling point via TIM1_Ch4 value and polarity
  * ADC sequence length and channels.
  */
uint16_t R3_1_SetADCSampPointSectX(PWMC_Handle_t * pHdl );

/**
  * Configure the ADC for the current sampling during calibration.
  * It means set the sampling point via TIMx_Ch4 value and polarity
  * ADC sequence length and channels.
  */
uint16_t R3_1_SetADCSampPointCalibration(PWMC_Handle_t *pHdl);

/**
  * It turns on low sides switches. This function is intended to be
  * used for charging boot capacitors of driving section. It has to be
  * called each motor start-up when using high voltage drivers
  */
void R3_1_TurnOnLowSides(PWMC_Handle_t *pHdl);

/**
  * This function enables the PWM outputs
  */
void R3_1_SwitchOnPWM(PWMC_Handle_t *pHdl);

/**
  * It disables PWM generation on the proper Timer peripheral acting on
  * MOE bit and reset the TIM status
  */
void R3_1_SwitchOffPWM(PWMC_Handle_t *pHdl);

/**
  * Execute a regular conversion.
  * The function is not re-entrant (can't executed twice at the same time)
  * It returns 0xFFFF in case of conversion error.
  */
uint16_t R3_1_ExecRegularConv(PWMC_Handle_t *pHdl, uint8_t bChannel);

/**
  * It is used to check if an overcurrent occurred since last call.
  */
uint16_t R3_1_IsOverCurrentOccurred(PWMC_Handle_t *pHdl);

/**
  * @brief  It contains the TIMx Update event interrupt
  */
void * R3_1_TIMx_UP_IRQHandler( PWMC_R3_1_Handle_t * pHandle );

/**
 * @brief  It contains the OVERCURRENT Break event interrupt
 */
void * R3_1_OVERCURRENT_IRQHandler( PWMC_R3_1_Handle_t * pHandle );

/**
 * @brief  It contains the OVERVOLTAGE Break event interrupt
 */
void * R3_1_OVERVOLTAGE_IRQHandler( PWMC_R3_1_Handle_t * pHandle );

/**
  * @}
  */

/**
  * @}
  */

#ifdef __cplusplus
}
#endif /* __cpluplus */

#endif /*__R3_G0XX_PWMNCURRFDBK_H*/

 /************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
