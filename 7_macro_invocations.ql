import cpp

from Macro macro, MacroInvocation invocation
where
    macro.getName() in ["ntohs", "ntohl", "ntohll"] and
    invocation.getMacro() = macro
select invocation
