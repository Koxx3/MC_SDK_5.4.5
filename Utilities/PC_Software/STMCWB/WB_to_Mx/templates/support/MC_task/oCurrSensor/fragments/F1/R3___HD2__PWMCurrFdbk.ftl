<#macro R3___HD2__PWMCurrFdbk motor device sense> 
<#-- TODO: R3___HD2__PWMCurrFdbk -->
<#local topComment>R3___HD2__PWMCurrFdbk: motor=${motor} device=${device} sense=${sense}</#local>#
    <@ui.comment topComment />
    <#if motor == 2 >
        <@ui.box "TO DO?/Verify" '.' />
        <#return>
    </#if>
    <#import "F103_HD/3Sh/F1_3Sh_tasks.ftl" as ns>
    <#import "../F1/com/F1_cs_tasks.ftl" as all>
    <@all.F1_all_settings ns.get_cs_sub_tasks() motor device sense />


</#macro>