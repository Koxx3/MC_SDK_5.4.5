/**
  ******************************************************************************
  * @file    r3_1_f7xx_pwm_curr_fdbk.h
  * @author  Motor Control SDK Team, ST Microelectronics
  * @brief   This file contains all definitions and functions prototypes for the
  *          r3_1_f7xx_pwm_curr_fdbk component of the Motor Control SDK.
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
  * @ingroup r3_1_f7xx_pwm_curr_fdbk
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __R3_1_F7XX_PWMCURRFDBK_H
#define __R3_1_F7XX_PWMCURRFDBK_H


#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* Includes ------------------------------------------------------------------*/
#include "pwm_curr_fdbk.h"

/** @addtogroup MCSDK
  * @{
  */

/** @addtogroup pwm_curr_fdbk
  * @{
  */

/** @addtogroup r3_1_f7xx_pwm_curr_fdbk
  * @{
  */

#define GPIO_NoRemap_TIM1 ((uint32_t)(0))
#define SHIFTED_TIMs      ((uint8_t) 1)
#define NO_SHIFTED_TIMs   ((uint8_t) 0)

#define NONE    ((uint8_t)(0x00))
#define EXT_MODE  ((uint8_t)(0x01))
#define INT_MODE  ((uint8_t)(0x02))

/* Exported types ------------------------------------------------------- */

/**
  * @brief  r3_1_pwm_curr_fdbk component parameters definition
  */
typedef const struct
{
  TIM_TypeDef * TIMx;                       /*!< It contains the pointer to the timer
                                                 used for PWM generation. It must
                                                 equal to TIM1 if bInstanceNbr is
                                                 equal to 1, to TIM8 otherwise */
  ADC_TypeDef * ADCx;                       /*!< ADC peripheral to be used*/
  GPIO_TypeDef * pwm_en_u_port;             /*!< Channel 1N (low side) GPIO output
                                                 port (if used, after re-mapping).
                                                 It must be GPIOx x= A, B, ...*/
  GPIO_TypeDef * pwm_en_v_port;             /*!< Channel 2N (low side) GPIO output
                                                 port (if used, after re-mapping).
                                                 It must be GPIOx x= A, B, ...*/
  GPIO_TypeDef * pwm_en_w_port;             /*!< Channel 3N (low side)  GPIO output
                                                 port (if used, after re-mapping).
                                                 It must be GPIOx x= A, B, ...*/
  uint32_t ADCConfig[6];                    /*!< store ADC sequence for the 6 sectors */
  volatile uint32_t  *ADCDataReg1[6];       /*!< store ADC data register 1 address for the 6 sectors */
  volatile uint32_t  *ADCDataReg2[6];       /*!< store ADC data register 2 address for the 6 sectors */
  uint16_t pwm_en_u_pin;                    /*!< Channel 1N (low side) GPIO output pin
                                                 (if used, after re-mapping). It must be
                                                 GPIO_Pin_x x= 0, 1, ...*/
  uint16_t pwm_en_v_pin;                    /*!< Channel 2N (low side) GPIO output pin
                                                 (if used, after re-mapping). It must be
                                                 GPIO_Pin_x x= 0, 1, ...*/
  uint16_t pwm_en_w_pin;                    /*!< Channel 3N (low side)  GPIO output pin
                                                 (if used, after re-mapping). It must be
                                                 GPIO_Pin_x x= 0, 1, ...*/
  uint16_t Tafter;                         /*!< It is the sum of dead time plus max
                                                 value between rise time and noise time
                                                 express in number of TIM clocks.*/
  uint16_t Tbefore;                        /*!< It is the sampling time express in
                                                 number of TIM clocks.*/
  uint8_t EmergencyStop;                    /*!< It defines the modality of emergency
                                                 input 2. It must be any of the
                                                 the following:
                                                 NONE - feature disabled.
                                                 INT_MODE - Internal comparator used
                                                 as source of emergency event.
                                                 EXT_MODE - External comparator used
                                                 as source of emergency event.*/
  uint8_t  RepetitionCounter;              /*!< It expresses the number of PWM
                                                 periods to be elapsed before compare
                                                 registers are updated again. In
                                                 particular:
                                                 RepetitionCounter= (2* #PWM periods)-1*/
  LowSideOutputsFunction_t LowSideOutputs;  /*!< Low side or enabling signals
                                                 generation method are defined
                                                 here.*/

} R3_1_Params_t;


/**
  * @brief  This structure is used to handle an instance of the
  *         r3_1_f7xx_pwm_curr_fdbk component.
  */
typedef struct
{
  PWMC_Handle_t _Super;     /*!< base component handler  */
  uint32_t PhaseAOffset;   /*!< Offset of Phase A current sensing network  */
  uint32_t PhaseBOffset;   /*!< Offset of Phase B current sensing network  */
  uint32_t PhaseCOffset;   /*!< Offset of Phase C current sensing network  */
  uint32_t ADC_ExternalTriggerInjected;  /*!< external ADC trigger source */
  uint32_t ADCTriggerEdge;               /* external ADC trigger edge */
  uint16_t Half_PWMPeriod;  /*!< Half PWM Period in timer clock counts */
  uint8_t  CalibSector;    /*!< the space vector sector number during calibration */
  volatile uint8_t PolarizationCounter; /*!< Number of conversions performed during the
                                              calibration phase*/
  bool OverCurrentFlag;     /*!< This flag is set when an overcurrent occurs.*/
  bool OverVoltageFlag;     /*!< This flag is set when an overvoltage occurs.*/
  bool BrakeActionLock;     /*!< This flag is set to avoid that brake action is
                                 interrupted.*/
  R3_1_Params_t const *pParams_str;

} PWMC_R3_1_Handle_t;

/* Exported functions ------------------------------------------------------- */

/*  It initializes peripherals for current reading and PWM generation
 *  in three shunts configuration using STM32F302x8 *****/
void R3_1_Init( PWMC_R3_1_Handle_t * pHandle );

/* It disables PWM generation on the proper Timer peripheral acting on
 * MOE bit
 */
void R3_1_SwitchOffPWM( PWMC_Handle_t * pHdl );

/**
  * It enables PWM generation on the proper Timer peripheral acting on MOE
  * bit
  */
void R3_1_SwitchOnPWM( PWMC_Handle_t * pHdl );

/**
  * It turns on low sides switches. This function is intended to be
  * used for charging boot capacitors of driving section. It has to be
  * called each motor start-up when using high voltage drivers
  */
void R3_1_TurnOnLowSides( PWMC_Handle_t * pHdl );

/**
  * It computes and return latest converted motor phase currents motor
  */
void R3_1_GetPhaseCurrents( PWMC_Handle_t * pHdl, ab_t * pStator_Currents );

/**
  * It measures and stores into handler component variables the offset voltage on Ia and
  * Ib current feedback analog channels when no current is flowing into the
  * motor
  */
void R3_1_CurrentReadingCalibration( PWMC_Handle_t * pHdl );

/**
  * Configure the ADC for the current sampling during calibration.
  * It means set the sampling point via TIMx_Ch4 value and polarity
  * ADC sequence length and channels.
  */
uint16_t R3_1_SetADCSampPointCalibration( PWMC_Handle_t * pHdl);

/**
  * Configure the ADC for the current sampling related to sector 1.
  * It means set the sampling point via TIMx_Ch4 value and polarity
  * ADC sequence length and channels.
  */
uint16_t R3_1_SetADCSampPointSectX( PWMC_Handle_t * pHdl);

/**
  * It contains the TIMx Update event interrupt
  */
void * R3_1_TIMx_UP_IRQHandler( PWMC_R3_1_Handle_t * pHdl );

/**
  * It contains the TIMx break2 event interrupt
  */
void * R3_1_BRK_IRQHandler( PWMC_R3_1_Handle_t * pHdl );

/**
  * It contains the TIMx break1 event interrupt
  */
void * R3_1_BRK2_IRQHandler( PWMC_R3_1_Handle_t * pHdl );

/**
  * It is used to check if an overcurrent occurred since last call.
  */
uint16_t R3_1_IsOverCurrentOccurred( PWMC_Handle_t * pHdl );

/**
  * It is used to enable the PWM mode during RL Detection Mode.
  */
void R3_1_RLDetectionModeEnable( PWMC_Handle_t * pHdl );

/**
  * It is used to disable the PWM mode during RL Detection Mode.
  */
void R3_1_RLDetectionModeDisable( PWMC_Handle_t * pHdl );

/**
  * It is used to set the PWM dutycycle during RL Detection Mode.
  */
uint16_t R3_1_RLDetectionModeSetDuty( PWMC_Handle_t * pHdl, uint16_t hDuty );

/**
  * It computes and return latest converted motor phase currents motor
  * during RL detection phase
  */
void R3_1_RLGetPhaseCurrents( PWMC_Handle_t * pHdl, ab_t * pStator_Currents );

/**
  * It turns on low sides switches. This function is intended to be
  * used for charging boot capacitors of driving section. It has to be
  * called each motor start-up when using high voltage drivers.
  * This function is specific for RL detection phase.
  */
void R3_1_RLTurnOnLowSides( PWMC_Handle_t * pHdl );

/**
  * It enables PWM generation on the proper Timer peripheral
  * This function is specific for RL detection phase.
  */
void R3_1_RLSwitchOnPWM( PWMC_Handle_t * pHdl );

/**
  * It disables PWM generation on the proper Timer peripheral acting on
  * MOE bit
  */
void R3_1_RLSwitchOffPWM( PWMC_Handle_t * pHdl );
/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

#ifdef __cplusplus
}
#endif /* __cpluplus */

#endif /*__R3_1_F7XX_PWMNCURRFDBK_H*/

/******************* (C) COPYRIGHT 2019 STMicroelectronics *****END OF FILE****/
