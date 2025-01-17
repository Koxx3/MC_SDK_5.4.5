<#import "../../../mcus/cmns/ioc_Mcu_PCC.ftl" as u >
<@u.ioc_Mcu_PCC
{ "Family"    : "STM32F3"
, "Package"   : "LQFP48"
, "Name"      : "STM32F303C(B-C)Tx"
, "UserName"  : "STM32F303CCTx"
, "Line"      : "STM32F303"
} />
<#global DAC1 = "DAC" >

<#include "../../../mcus/cmns/FreeRTOS_IsAvaliable.ftl">
<#include "../../../mcus/cmns/OSC_IN-OSC_OUT.ftl" >

RCC.ADC12outputFreq_Value=72000000
RCC.ADC34outputFreq_Value=72000000
RCC.AHBFreq_Value=72000000
RCC.APB1CLKDivider=RCC_HCLK_DIV2
RCC.APB1Freq_Value=36000000
RCC.APB1TimFreq_Value=72000000
RCC.APB2Freq_Value=72000000
RCC.APB2TimFreq_Value=72000000
RCC.CortexFreq_Value=72000000
RCC.EnbaleCSS=true
RCC.FCLKCortexFreq_Value=72000000
RCC.FamilyName=M
RCC.HCLKFreq_Value=72000000
RCC.HSEPLLFreq_Value=8000000
RCC.HSE_VALUE=8000000
RCC.HSIPLLFreq_Value=4000000
RCC.HSI_VALUE=8000000
RCC.I2C1Freq_Value=8000000
RCC.I2C2Freq_Value=8000000
RCC.IPParameters=ADC12outputFreq_Value,ADC34outputFreq_Value,TIM1Selection,TIM8Selection,AHBFreq_Value,APB1CLKDivider,APB1Freq_Value,APB1TimFreq_Value,APB2Freq_Value,APB2TimFreq_Value,CortexFreq_Value,EnbaleCSS,FCLKCortexFreq_Value,FamilyName,HCLKFreq_Value,HSEPLLFreq_Value,HSE_VALUE,HSIPLLFreq_Value,HSI_VALUE,I2C1Freq_Value,I2C2Freq_Value,LSE_VALUE,LSI_VALUE,MCOFreq_Value,PLLCLKFreq_Value,PLLMCOFreq_Value,PLLMUL,PLLSourceVirtual,RTCFreq_Value,RTCHSEDivFreq_Value,SYSCLKFreq_VALUE,SYSCLKSourceVirtual,TIM1Freq_Value,TIM2Freq_Value,TIM8Freq_Value,USART1Freq_Value,USART2Freq_Value,USART3Freq_Value,USBFreq_Value,VCOOutput2Freq_Value
RCC.LSE_VALUE=32768
RCC.LSI_VALUE=40000
RCC.MCOFreq_Value=72000000
RCC.PLLCLKFreq_Value=72000000
RCC.PLLMCOFreq_Value=36000000
RCC.PLLMUL=RCC_PLL_MUL9
RCC.PLLSourceVirtual=RCC_PLLSOURCE_HSE
RCC.RTCFreq_Value=40000
RCC.RTCHSEDivFreq_Value=250000
RCC.SYSCLKFreq_VALUE=72000000
RCC.SYSCLKSourceVirtual=RCC_SYSCLKSOURCE_PLLCLK
RCC.TIM1Freq_Value=144000000
RCC.TIM1Selection=RCC_TIM1CLK_PLLCLK
RCC.TIM8Freq_Value=144000000
RCC.TIM8Selection=RCC_TIM8CLK_PLLCLK
RCC.TIM2Freq_Value=72000000
RCC.USART1Freq_Value=72000000
RCC.USART2Freq_Value=36000000
RCC.USART3Freq_Value=36000000
RCC.USBFreq_Value=72000000
RCC.VCOOutput2Freq_Value=8000000
