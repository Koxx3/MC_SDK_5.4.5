<#import "../../../../../ui.ftl" as ui>
<#import "../../../../../utils.ftl" as utils>
<#import "../../../../ADC/adc_overlap.ftl" as adc_ov>

<#import "../../../../utils/meta_parameters.ftl" as meta>
<#import "../../../../utils/pins_mng.ftl"        as ns_pin>
<#import "../../../../utils/ips_mng.ftl"         as ns_ip>

<#import "../../../../ADC/ADC_cs_info.ftl" as info >
<#import "../../../../../fp.ftl" as fp >

<#import "../com/H7_adc.ftl" as ap>

<#function cs_ADC_settings motor>
    <#local timer = utils.v("PWM_TIMER_SELECTION", motor) >

    <#local adc  = ns_ip.collectIP(ADC_PERIPH)>
<#--Add the Cortex config for IP - Call the Macro  CortexMx-->
    <#import "../../../../utils/cortexMx_mng.ftl" as ns_cortex_ip>
    <@ns_cortex_ip.collectCortexIP adc/>

    <#local infs = fp.map_ctx(motor, info.adc_info, ["U","V","W"]) >

    <#local sectionTitle = "${adc} Current Sensing settings" >
    <#local ip_settings  = ns_ip.IP_settings(sectionTitle, adc, ap.cs_adc_parameters(timer, "3Sh", infs)) >
    <#local adc_settings_parameters   = adc_ov.update_ADCs_IPParameters( ip_settings ) >

    <#local installed_recoveries = ap.recovery_4_extra_regular_cnv_and_ScanConvMode(adc, infs[0]) >

    <#return
        { "settings" :
                { sectionTitle : ui._comment("The ${adc} settings section was POSTPONED.\nIt will be part of a cumulative section dedicated to all ADCs")
                , "${adc} IRQ" : ap.cs_adc_irq(adc)
                }
        , "GPIOs"    : fp.map_ctx({"adc" : adc}, ap.cs_create_adc_pins, infs)
        }>
</#function>
