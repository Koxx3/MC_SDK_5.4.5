<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp>

<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../utils/pins_mng.ftl"  as ns_pin>
<#import "../../../../utils/ips_mng.ftl"   as ns_ip>

<#import "../com/G4_pwm_timer.ftl" as cmns>

<#function cs_PWM_TIMER_patameters timer motor>
    <#local motor_n = (motor == 2)?then ("2","")>
    <#return cmns.cs_PWM_TIMER_patameters(timer, 4..6, motor) +
        { "CounterMode"              : "TIM_COUNTERMODE_CENTERALIGNED3"
        , "TIM_MasterOutputTrigger"  : "TIM_TRGO_RESET"
        , "TIM_MasterOutputTrigger2" : "TIM_TRGO2_OC5REF_RISING_OC6REF_RISING"
        , meta.no_chk("PulseNoDither_4"                       ) : "(((PWM_PERIOD_CYCLES${motor_n}) / 2) - (HTMIN${motor_n}))"
        }>

<#--
    <#list 4..6 as idx>
        <#local mode      = "PWM Generation${idx} No Output" >
        <#local vs_signal = "${timer.name}_VS_no_output${idx}" >
        <#local vp_pin    = ns_pin.collectPin("VP_${vs_signal}") >

        <#local parameters = parameters +
            { "Channel-PWM\\ Generation${idx}\\ No\\ Output" : "TIM_CHANNEL_${idx}" }
            + meta.text( "${vp_pin}.Mode=${mode}" )
            + meta.text( "${vp_pin}.Signal=${vs_signal}")
            >
    </#list>
-->
</#function>

