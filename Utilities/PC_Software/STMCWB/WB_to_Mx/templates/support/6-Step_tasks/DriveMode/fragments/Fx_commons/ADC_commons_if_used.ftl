
<#function ADC_common_parameters ip>
<#import "../../../../MC_task/utils/meta_parameters.ftl"  as meta >
<#import "../../../../utils.ftl" as utils >
    <#return
    { "ClockPrescaler"        : "ADC_CLOCK_SYNC_PCLK_DIV${ ADC_CLOCK_WB_DIV }"
    , "DataAlign"             : "ADC_DATAALIGN_RIGHT"
    , "Resolution"            : "ADC_RESOLUTION_12B"
    , "ContinuousConvMode"    : "DISABLE"
    , "DiscontinuousConvMode" : "DISABLE"
    , "DMAContinuousRequests" : "DISABLE"
    , "EOCSelection"          : "ADC_EOC_SINGLE_CONV"
    , "Overrun"               : "ADC_OVR_DATA_PRESERVED"
    , "LowPowerAutoWait"      : "DISABLE"

    , "master"                : 1

    , meta.blankLn_key():""
    , "EnableAnalogWatchDog1"     : "false"
    , "EnableAnalogWatchDog2"     : "false"
    , "EnableAnalogWatchDog3"     : "false"
    }>
</#function>


