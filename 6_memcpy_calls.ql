import cpp

from FunctionCall call, Function func
where
    func.getName() = "memcpy" and
    call.getTarget() = func
select call
    
