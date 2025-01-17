<#import "../../../../../../ui.ftl" as ui >
<#import "../../../../../../fp.ftl" as fp >
<#import "../../../../../../utils.ftl" as utils>
<#import "../../../../../../MC_task/utils/ips_mng.ftl" as ns_ip>
<#import "../../../Fx_commons/cs_cmn_settings.ftl" as cmn_sets >

<#macro R1_x_G4_all_settings motor device sense>
    <@curr_sense_ADC    motor/><@ui.hline ' '/>
    <@curr_sense_OCP    motor/><@ui.hline ' '/>
    <@curr_sense_TIMER  motor/><@ui.hline ' '/>
<#--
    <@curr_sense_DMA                                        motor/><@ui.hline ' '/>
-->
    <@cmn_sets.curr_sense_GENETATE_CONSOLIDATED_PIN_SETTING motor/><@ui.hline ' '/>
    <@cmn_sets.curr_sense_SINCRONIZATION_TIMERs             motor/>
</#macro>

<#macro curr_sense_OCP motor>
    <#import "../../com/G4_ocp.ftl" as ns_ocp >
    <@cmn_sets.curr_sense_OCP ns_ocp.cs_over_current_prot(motor, [""]) />
    <#--<#local config = ns_ocp.cs_over_current_prot(motor, [""]) >
    <@cmn_sets.curr_sense_OCP config />-->
</#macro>

<#macro curr_sense_TIMER motor>
    <#import "../../com/G4_pwm_timer.ftl" as cmns_tmr>
    <#import "R1_x_G4_pwm_timer.ftl" as tmr >
    <#local config = cmns_tmr.cs_TIMER_settings(motor, tmr.cs_PWM_TIMER_patameters) >
  <#--  <#local config = extra_TIM_UP_IRQ_settings(cmns_tmr.timer_srcs(motor), config) >-->
    <@cmn_sets.curr_sense_TIMER config />
</#macro>

<#function extra_TIM_UP_IRQ_settings timer config>
    <#local irq_name = timer.name?switch
    ( "TIM1", "TIM1_UP_TIM16"
    , "TIM8", "TIM8_UP"
    , "")
    >
    <#if irq_name?has_content >
        <#import "../../../../../../names_map.ftl" as rr>
        <#local set_irq_tim = rr["SET_IRQ_TIM"]!([true, 0, 0, false, false, false, true]) >
        <#local tim_up_IRQ = ns_ip.ip_irq( irq_name, set_irq_tim ) >
    <#--<#local tim_up_IRQ = ns_ip.ip_irq( irq_name, [true, 0, 0, false, false, false, true]) >-->

        <#local settings = config.settings
        + { "Extra ${timer.name}_UP IRQ ([Ticket 64499]Change policy Irq and priority)" : tim_up_IRQ }>
        <#local config = config + {"settings": settings} >
    </#if>

    <#return config >
</#function>

<#function dma_req_extra_fields idx>
    <#return
    { "mem_inc"      : ["DISABLE"  , "ENABLE" ][idx]
    , "allignment"   : ["HALFWORD", "BYTE"    ][idx]
    , "mode"         : ["CIRCULAR", "NORMAL"  ][idx]
    }>
</#function>


<#import "../../../Fx_commons/DMA_Settings.ftl" as dma>
<#macro curr_sense_DMA motor>
    <#local collected_reqs = dma.collectDMA_requests( _curr_sense_DMA(motor) ) >
    <@ui.comment "DMA settings for motor M${motor} was postponed, see below" />
</#macro>
<#function _curr_sense_DMA motor>
    <#local ip = ns_ip.collectIP( utils.mx_name( utils._last_word(USART_SELECTION) ) ) >

   <#-- <#local pwm_timer = ns_ip.collectIP( utils._last_word( utils.v("PWM_TIMER_SELECTION", motor) ) ) >-->
<#-- TODO: DMA settings strictly depends on Timer (DMA_Request and channel) ==> so we need have to maintain a table for mapping devices
           the following table comes from datasheet but so we are no more agnostic on the device...
           what if mx can share an XML file containing such info?
-->
<#--    <#local table = {"TIM1" : [ {"dma_request": "TIM1_CH4", "channel": "DMA1_Channel1" } + dma_req_extra_fields(0)
                           &lt;#&ndash;   , {"dma_request": "TIM1_UP"          , "channel": "DMA1_Channel6" } + dma_req_extra_fields(1)&ndash;&gt;
                              ]
                    ,"TIM8" : [ &lt;#&ndash;{"dma_request": "TIM8_CH4/TRIG/COM", "channel": "DMA2_Channel2" } + dma_req_extra_fields(0),&ndash;&gt;
                               {"dma_request": "TIM8_CH4"      , "channel": "DMA2_Channel1" } + dma_req_extra_fields(0)
                              ]
                    }>-->
    <#local table = {"USART2" : [ {"dma_request": "USART2_TX", "channel": "DMA1_Channel1", "priority": "LOW"  } + dma_req_extra_fields(1)  ]

    }>

    <#--<#return table[pwm_timer]![] />-->
    <#return table[ip]![] />
</#function>


<#macro curr_sense_ADC motor internal_opamp=false>
    <#import "R1_x_G4_adc.ftl" as ns_adc >
    <#local config = ns_adc.cs_ADC_settings(motor) >
    <@cmn_sets.curr_sense_ADC config />
</#macro>

