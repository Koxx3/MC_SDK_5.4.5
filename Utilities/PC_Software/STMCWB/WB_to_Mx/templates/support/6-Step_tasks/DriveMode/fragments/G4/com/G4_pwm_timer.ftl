<#import "../../../../../utils.ftl" as utils>
<#import "../../../../../fp.ftl" as fp>
<#import "../../../../../ui.ftl" as ui>

<#import "../../../../../MC_task/utils/meta_parameters.ftl" as meta>
<#import "../../../../../MC_task/utils/pins_mng.ftl"  as ns_pin>
<#import "../../../../../MC_task/utils/ips_mng.ftl"   as ns_ip>

<#function cs_TIMER_settings motor get_parameter>
    <#import "../../Fx_commons/Fx_pwm_timer_pins.ftl"   as pwm_pins>

    <#local timer = timer_srcs(motor) >
    <#local timer_name = ns_ip.collectIP( timer.name ) >

    <#local general_settings = meta.ip_params_to_str(timer.name, get_parameter(timer, motor)) >

    <#import "../../../../../names_map.ftl" as rr>
    <#local ITR= rr["ITR_TIMx"]>
    <#local timeBase_ITR = ( ITR?is_hash && ITR[WB_LF_TIMER_SELECTION]??)?then(ITR[WB_LF_TIMER_SELECTION], "ITR3")>
    <#local aux_timer_setting = LF_TIMER_settings(motor).settings>

    <#return
        { "settings" :
            { "PWM TIMER settings"                          : general_settings
            , "${timer.name} IRQ"                           : cs_timer_irq(timer.name)
            , "${timer.name} TriggerSource_${timeBase_ITR}" : TriggerSource_ITRx(timer.name timeBase_ITR)
            }
            + aux_timer_setting
        , "GPIOs" : pwm_pins.cs_create_timer_pins(timer)
        }>
</#function>


<#function LF_TIMER_settings motor>

    <#import "../../../../../MC_task/utils/user_constants.ftl" as mcu>

    <#--<#local _define_LF_TIMX_PSC = mcu.define("LF_TIMX_PSC", "21" )>
    <#local _define_LF_TIMX_ARR = mcu.define("LF_TIMX_ARR", "65535" )>-->

    <#local timer = utils._last_word( utils.v("LF_TIMER_SELECTION", motor) ) >
    <#local registered_timer_name = ns_ip.collectIP( timer ) >

    <#local aux_settings_parameters =
    {
     meta.no_chk("Prescaler")        : "LF_TIMER_PSC"
    ,meta.no_chk("PeriodNoDither")   : "LF_TIMER_ARR"


    ,"TIM_MasterOutputTrigger" : "TIM_TRGO_ENABLE"
    ,"TIM_MasterSlaveMode"     : "TIM_MASTERSLAVEMODE_ENABLE"
    }>
    <#local str_aux_settings = meta.ip_params_to_str(timer, aux_settings_parameters ) >

<#-- Virtual Pin -->
    <#local vp_mode   = "Internal"                           >
    <#local vs_signal = "${timer}_VS_ClockSourceINT"    >
    <#local vp_pin    = ns_pin.collectPin("VP_${vs_signal}") >

    <#local str_vp_setting =
    [ "${vp_pin}.Mode=${vp_mode}"
    , "${vp_pin}.Signal=${vs_signal}"
    ]?join("\n") >

    <#return
    { "settings" : { "Low frequency timer settings"              : str_aux_settings
                   , "Low frequency timer Virtual Pin settings"  : str_vp_setting
                   , "${timer} IRQ"                              : lf_timer_irq(timer)
                   }
    , "GPIOs" : []
    }>
</#function>


<#import "../../../../../../config.ftl" as config>

<#function TriggerSource_ITRx timerName ITR>

    <#local sig_mode  = { "ClockSourceITR"      : "TriggerSource_${ITR}"
                        , "ControllerModeReset" : "Reset Mode"
                        , "ClockSourceINT"      : "Internal"
                        } >

    <#local vps = {} >
    <#list sig_mode as signal, mode>
        <#local v_signal = "${timerName?upper_case}_VS_${signal}" >
        <#local vp = "VP_${v_signal}" >
        <#local vps = vps +
            { vp : [ "${vp}.Mode=${mode}"
                   , "${vp}.Signal=${v_signal}"
                   ]
            }>
    </#list>

    <#local settigs = fp.flatten(vps?values) >
    <#local limit = (config.syncTimers_min_num_motors)!100  >
    <#if WB_NUM_MOTORS gte limit >
        <#local registered_vps = fp.map(ns_pin.collectPin, vps?keys) >
        <#return settigs?join("\n") >
    <#else>
        <#return ui._comment( (
            [ "According the \"syncTimers_min_num_motors\" flag in the config file,"
            , "the following instructions will be activated when num-motors >= ${limit}"
            , "Currently you are using ${WB_NUM_MOTORS} motor${ WB_NUM_MOTORS?switch(1, '', 's') }"
            ] + settigs
            )?join("\n") )>
    </#if>
</#function>

<#function cs_timer_irq ip>
    <#local irqs =
        { "TIM1" : "TIM1_BRK_TIM15"
        , "TIM8" : "TIM8_BRK"
        } >

 <#--   <#return ns_ip.ip_irq( irqs[ip], [true, 4, 1, true, false, false, true]) >-->
    <#import "../../../../../names_map.ftl" as rr>
    <#local set_irq_tim_lf = rr["SET_IRQ_TIM_BRK"]!([true, 1, 0, true, false, false, true]) >
    <#return ns_ip.ip_irq( irqs[ip], set_irq_tim_lf) >
</#function>

<#function lf_timer_irq ip>
    <#local irqs =
    { "TIM4" : "TIM4"
     } >
    <#import "../../../../../names_map.ftl" as rr>
    <#local set_irq_tim_lf = [true, 0, 0, true, false, false, true] >
    <#return ns_ip.ip_irq( irqs[ip], set_irq_tim_lf) >
</#function>



<#function cs_PWM_TIMER_patameters timer no_outs motor>


    <#local motor_n = (motor == 2)?then ("2","")>

    <#local HALF_PWM_PERIOD = "((PWM_PERIOD_CYCLES${motor_n}) / 2)">

    <#local parameters =
    { "AutoReloadPreload": "TIM_AUTORELOAD_PRELOAD_DISABLE"
    , "AutomaticOutput"  : "TIM_AUTOMATICOUTPUT_DISABLE"

    , meta.blankLn_key() : ""
    , "BreakFilter"      : "${timer.BKIN1_FILTER}"
    , "BreakState"      : "TIM_BREAK_${ (timer.BKIN_MODE=='NONE')?then('DISABLE', 'ENABLE')  }"
    , "BreakPolarity"   : "TIM_BREAKPOLARITY_${utils._last_word( timer.OVERCURR_FEEDBACK_POLARITY ) }"


    , meta.blankLn_key() : ""
    , "Break2Filter"     : "${timer.BKIN2_FILTER}"
    , "Break2State"      : "TIM_BREAK2_${ (timer.BKIN2_MODE=='NONE')?then('DISABLE', 'ENABLE')  }"
    , "Break2Polarity"   : "TIM_BREAK2POLARITY_HIGH"



    <#--,"SourceBRK2DigInputPolarity" : "TIM_BREAKINPUTSOURCE_POLARITY_ENABLE"-->

    <#--,"SourceBRK2DigInput"        : "TIM_BREAKINPUTSOURCE_${ (timer.BKIN2_MODE=='NONE')?then('DISABLE',
    (WB_USE_INTERNAL_OPAMP)?then('DISABLE','ENABLE'))}"-->

    ,"SourceBRK2DigInput"        : "TIM_BREAKINPUTSOURCE_${ (timer.BKIN2_MODE!='EXT_MODE')?then('DISABLE','ENABLE')}"

    , "OffStateRunMode"  : "${ (timer.BKIN2_MODE=='NONE')?then('TIM_OSSR_DISABLE','TIM_OSSR_ENABLE')}"
    , "LockLevel"        : "TIM_LOCKLEVEL_OFF"
    , "ClearInputSource" : "TIM_CLEARINPUTSOURCE_NONE"
    , meta.no_chk("DeadTime") : "((DEAD_TIME_COUNTS${motor_n}) / 2)"



    <#--, "ClearChannel1"    : ""-->
  <#--  , "ClearChannel2"    : ""
    , "ClearChannel3"    : ""
    , "ClearChannel4"    : ""
    , "ClearChannel5"    : ""
    , "ClearChannel6"    : ""-->
    <#--, "ClearInputState"  : "ENABLE"-->
    , "ClockDivision"    : "TIM_CLOCKDIVISION_DIV1"



    , meta.blankLn_key() : ""
    <#--, "OCFastMode_PWM" : "TIM_OCFAST_DISABLE"-->

    , meta.comment_key() : "IDLE_UH_POLARITY"

        <#--ONLY FOR ESC G4-->

    , "OCIdleState_1" : "TIM_OCIDLESTATE_${ utils.polarity(timer.HIGH_SIDE_IDLE_STATE, timer.PHASE_UH_POLARITY) }"
    , "OCIdleState_2" : "TIM_OCIDLESTATE_${ utils.polarity(timer.HIGH_SIDE_IDLE_STATE, timer.PHASE_VH_POLARITY) }"
    , "OCIdleState_3" : "TIM_OCIDLESTATE_${ utils.polarity(timer.HIGH_SIDE_IDLE_STATE, timer.PHASE_WH_POLARITY) }"
    , "OCIdleState_4" : "TIM_OCIDLESTATE_RESET"
  <#--  , "OCIdleState_5" : "TIM_OCIDLESTATE_RESET"
    , "OCIdleState_6" : "TIM_OCIDLESTATE_RESET"-->

    , meta.blankLn_key() : ""
    , "OCPolarity_1"     : "TIM_OCPOLARITY_${ utils._last_word( timer.PHASE_UH_POLARITY ) }"
    , "OCPolarity_2"     : "TIM_OCPOLARITY_${ utils._last_word( timer.PHASE_VH_POLARITY ) }"
    , "OCPolarity_3"     : "TIM_OCPOLARITY_${ utils._last_word( timer.PHASE_WH_POLARITY ) }"
    , "OCPolarity_4"     : "TIM_OCPOLARITY_HIGH"
    <#--, "OCPolarity_5"     : "TIM_OCPOLARITY_HIGH"
    , "OCPolarity_6"     : "TIM_OCPOLARITY_HIGH"-->
    , "OffStateIDLEMode"  : "${ (timer.BKIN2_MODE=='NONE')?then('TIM_OSSI_DISABLE','TIM_OSSI_ENABLE')}"

    <#-- , meta.no_chk("Period"                                ) :  "((PWM_PERIOD_CYCLES${motor_n}) / 2)"-->
   <#-- , meta.no_chk("PeriodNoDither"                        ) :  "((PWM_PERIOD_CYCLES${motor_n}) / 2)"-->
    , meta.no_chk("PeriodNoDither"                        ) :  "PWM_PERIOD_CYCLES${motor_n}"
    , meta.no_chk("Prescaler"                             ) :  "((TIM_CLOCK_DIVIDER${motor_n}) - 1)"
    <#--
    , meta.no_chk("Pulse-PWM\\ Generation1\\ CH1"         ) :  "((PWM_PERIOD_CYCLES${motor_n}) / 4)"
    , meta.no_chk("Pulse-PWM\\ Generation2\\ CH2"         ) :  "((PWM_PERIOD_CYCLES${motor_n}) / 4)"
    , meta.no_chk("Pulse-PWM\\ Generation3\\ CH3"         ) :  "((PWM_PERIOD_CYCLES${motor_n}) / 4)"
    , meta.no_chk("Pulse-PWM\\ Generation4\\ No\\ Output" ) : "(((PWM_PERIOD_CYCLES${motor_n}) / 2) - (HTMIN${motor_n}))"
    , meta.no_chk("Pulse-PWM\\ Generation5\\ No\\ Output" ) : "(((PWM_PERIOD_CYCLES${motor_n}) / 2) + 1)"
    , meta.no_chk("Pulse-PWM\\ Generation6\\ No\\ Output" ) : "(((PWM_PERIOD_CYCLES${motor_n}) / 2) + 1)"
        -->
    , meta.no_chk("RepetitionCounter"                     ) : "0" <#--"(REP_COUNTER${motor_n})"-->


    , "TIM_MasterSlaveMode"      : "TIM_MASTERSLAVEMODE_ENABLE"

    , "TIM_SlaveMode"            : "TIM_SLAVEMODE_RESET"
    }>


    <#if (timer.BKIN2_MODE== "INT_MODE")>
        <#local sense_topology = utils.current_sensing_topology(motor)!"THREE_SHUNT" >
        <#local sense = utils.short_sense(sense_topology)>


        <#--<#local pwm_timer = ns_ip.collectIP( utils._last_word( utils.v("PWM_TIMER_SELECTION", motor)) ) >-->

        <#switch sense>
            <#case "1Sh">
                <#local comps  = ["${utils._last_word(timer.OCP_SELECTION)}"]>
                <#break >

            <#case "3Sh" >
            <#case "3Sh_IR" >
                <#local comps = ["${utils._last_word(timer.OCPA_SELECTION)}"
                                ,"${utils._last_word(timer.OCPB_SELECTION)}"
                                ,"${utils._last_word(timer.OCPC_SELECTION)}"
                                ]>
                <#break >
            <#case "ICS">
                <#local comps = ["${utils._last_word(timer.OCPA_SELECTION)}"
                                ,"${utils._last_word(timer.OCPB_SELECTION)}"
                                ]>
                <#break >
            <#default>
                 <#local comps  = ["${utils._last_word(timer.OCP_SELECTION)}"]>
                <#break >
        </#switch>
        <#list comps as item>
            <#local parameters = parameters +
              { "SourceBRK2${item}"           : "TIM_BREAKINPUTSOURCE_ENABLE"
              , "SourceBRK2${item}Polarity"   : "TIM_BREAKINPUTSOURCE_POLARITY_HIGH"
              }>
        </#list>
    <#else>
        <#--<#local BRK2Dig = ((utils._last_word( timer.OVERCURR_FEEDBACK_POLARITY))== "HIGH")?then("LOW","HIGH") >-->
        <#local BRK2Dig = utils._last_word( timer.OVERCURR_FEEDBACK_POLARITY)>
        <#local parameters = parameters +
        { "SourceBRK2DigInputPolarity":"TIM_BREAKINPUTSOURCE_POLARITY_${BRK2Dig}"}>
    </#if>



    <#if timer.LOW_SIDE_SIGNALS_ENABLING == "LS_PWM_TIMER" >
        <#local parameters = parameters +
        { "OCNPolarity_1"     : "TIM_OCNPOLARITY_${ utils._last_word( timer.PHASE_UL_POLARITY ) }"
        , "OCNPolarity_2"     : "TIM_OCNPOLARITY_${ utils._last_word( timer.PHASE_VL_POLARITY ) }"
        , "OCNPolarity_3"     : "TIM_OCNPOLARITY_${ utils._last_word( timer.PHASE_WL_POLARITY ) }"

        , "OCNIdleState_1"    : "TIM_OCNIDLESTATE_${ utils.polarity(timer.LOW_SIDE_IDLE_STATE, timer.PHASE_UL_POLARITY) }"
        , "OCNIdleState_2"    : "TIM_OCNIDLESTATE_${ utils.polarity(timer.LOW_SIDE_IDLE_STATE, timer.PHASE_VL_POLARITY) }"
        , "OCNIdleState_3"    : "TIM_OCNIDLESTATE_${ utils.polarity(timer.LOW_SIDE_IDLE_STATE, timer.PHASE_WL_POLARITY) }"
        } >
    </#if>


    <#local PWM_Generation_xs                = fp.map_ctx(timer, PWM_Generation_x, 1..3) >
    <#local extra_PWM_Generation_x_No_Output = fp.map_ctx(timer, PWM_Generation_x_No_Output, no_outs) >


    <#local OCMode_Generation_xs                = fp.map_ctx(timer, OCMode_Generation_x, 1..3) >
    <#local extra_OCMode_Generation_x_No_Output = fp.map_ctx(timer, OCMode_Generation_x_No_Output, no_outs) >


    <#return fp.foldl(fp.concat, parameters, PWM_Generation_xs + extra_PWM_Generation_x_No_Output
                                             + OCMode_Generation_xs + extra_OCMode_Generation_x_No_Output)
           + meta.blankLn("")
           + {"Channel" : "TIM_CHANNEL_${ PWM_Generation_xs?size + extra_PWM_Generation_x_No_Output?size}"}
           >
</#function>


<#function timer_srcs motor>
    <#local timer_name = utils._last_word( utils.v("PWM_TIMER_SELECTION", motor) ) >

    <#local polarities =
        { "UL": utils.v("PHASE_UL_POLARITY", motor), "UH": utils.v("PHASE_UH_POLARITY", motor)
        , "VL": utils.v("PHASE_VL_POLARITY", motor), "VH": utils.v("PHASE_VH_POLARITY", motor)
        , "WL": utils.v("PHASE_WL_POLARITY", motor), "WH": utils.v("PHASE_WH_POLARITY", motor)
        } >

    <#return
        { "name" : timer_name
        , "idx"  : utils._last_char(timer_name)
        , "motor" : motor

        , "polarity" : polarities
        , "PHASE_UL_POLARITY" : polarities.UL, "PHASE_UH_POLARITY" : polarities.UH
        , "PHASE_VL_POLARITY" : polarities.VL, "PHASE_VH_POLARITY" : polarities.VH
        , "PHASE_WL_POLARITY" : polarities.WL, "PHASE_WH_POLARITY" : polarities.WH
        }
        + m_item("LOW_SIDE_SIGNALS_ENABLING"  , motor)
        + m_item("BKIN1_FILTER"               , motor)
        + m_item("BKIN2_FILTER"               , motor)
        + m_item("BKIN2_MODE"                 , motor)
        + m_item("BKIN_MODE"                  , motor)
        + m_item("OVERCURR_FEEDBACK_POLARITY" , motor)
        + m_item("DEAD_TIME_COUNTS"           , motor)

        + m_item("HIGH_SIDE_IDLE_STATE"       , motor)
        + m_item("LOW_SIDE_IDLE_STATE"        , motor)

        + m_item("TIM_CLOCK_DIVIDER"          , motor)
        + m_item("HALF_PWM_PERIOD"            , motor)
        + m_item("HTMIN"                      , motor)
        + m_item("REP_COUNTER"                , motor)
        + m_item("OCPA_SELECTION"             , motor)
        + m_item("OCPB_SELECTION"             , motor)
        + m_item("OCPC_SELECTION"             , motor)
        + m_item("OCP_SELECTION"              , motor)
        >
</#function>

<#function m_item item m>
    <#return { item : utils.v(item , m) } >
</#function>


<#function PWM_Generation_x timer idx>
    <#local suffix = (timer.LOW_SIDE_SIGNALS_ENABLING == "LS_PWM_TIMER")?then("\\ CH${idx}N", "") >
    <#return { "Channel-PWM\\ Generation${idx}\\ CH${idx}${ suffix }" : "TIM_CHANNEL_${idx}" } >
</#function>

<#function PWM_Generation_x_No_Output timer idx>
    <#local mode      = "PWM Generation${idx} No Output"     >
    <#local vs_signal = "${timer.name}_VS_no_output${idx}"   >
    <#local vp_pin    = ns_pin.collectPin("VP_${vs_signal}") >

    <#return meta.blankLn("")
        + { "Channel-PWM\\ Generation${idx}\\ No\\ Output" : "TIM_CHANNEL_${idx}" }
        + meta.text( "${vp_pin}.Mode=${mode}" )
        + meta.text( "${vp_pin}.Signal=${vs_signal}")
        >
</#function>

<#function OCMode_Generation_x timer idx>
    <#local suffix = (timer.LOW_SIDE_SIGNALS_ENABLING == "LS_PWM_TIMER")?then("\\ CH${idx}N", "") >
    <#return { "OCMode_PWM-PWM\\ Generation${idx}\\ CH${idx}${ suffix }" : "TIM_OCMODE_PWM1" } >
</#function>

<#function OCMode_Generation_x_No_Output timer idx>
    <#return meta.blankLn("")
     +
     { "OCMode_PWM-PWM\\ Generation${idx}\\ No\\ Output" : "TIM_OCMODE_PWM1" }   >
</#function>
