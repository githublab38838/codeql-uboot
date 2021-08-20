import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class NetworkByteSwap extends Expr {
    NetworkByteSwap() {
        exists(MacroInvocation invocation | invocation.getMacroName() in 
            ["ntohs", "ntohl", "ntohll"] and this = invocation.getExpr())
    }
}

class Config extends TaintTracking::Configuration {
    Config() {
        this = "NetworkToMemFuncLength"
    }

    override predicate isSource(DataFlow::Node source) {
        source.asExpr() instanceof NetworkByteSwap
    }

    override predicate isSink(DataFlow::Node sink) {
        exists(FunctionCall call | sink.asExpr() = call.getArgument(2) and
            call.getTarget().getName() = "memcpy" and not
            call.getArgument(2).isConstant())
    }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"