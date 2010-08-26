import structs/[List, ArrayList], text/Buffer
import Expression, Visitor, FunctionCall, Type, VariableDecl,
       VariableAccess, Statement, Node, Scope
import tinker/[Trail, Resolver, Response, Errors]

CallChain: class extends Expression {

    expr : Expression
    calls := ArrayList<FunctionCall> new()

    init: func (=expr, firstCall: FunctionCall) {
        super (expr token)
        calls add(firstCall)
    }

    clone: func -> This {
        copy := new(expr clone(), calls[0] clone())
        calls each(|c| copy calls add(c clone()))
        copy
    }

    accept: func (visitor: Visitor) {
        Exception new("Visiting call chain! That oughta never happen.") throw()
    }

    getType: func -> Type {
        expr ? expr getType() : null
    }

    toString: func -> String {
        b := Buffer new()
        if (expr) {
            b append(expr toString())
        }
        for (call in calls) {
            b append(". "). append(call toString())
        }

        b toString()
    }

    resolve: func (trail: Trail, res: Resolver) -> Response {

        parent := trail peek()
        if(parent instanceOf?(VariableDecl)) {
            //printf("    ==== Callchain is in variableDecl %s\n", parent toString())

            vDecl := parent as VariableDecl
            vAcc := VariableAccess new(vDecl, expr token)

            grandpa := trail peek(2)
            reverse := false
            if(!grandpa instanceOf?(Scope)) {
                trail addBeforeInScope(grandpa as Statement, vDecl)
                grandpa replace(vDecl, vAcc)
                reverse = true
            }

            parent replace(this, expr)

            if(reverse) {
                //printf("Going backwards for %s\n", toString())
                for(call in calls) {
                    call expr = vAcc
                    trail addBeforeInScope(grandpa as Statement, call)
                }
            } else {
                //printf("Going foward for %s\n", toString())
                for(call in calls backward()) {
                    call expr = vAcc
                    trail addAfterInScope(vDecl, call)
                }
            }
            return Response OK
        }

        if(expr instanceOf?(FunctionCall) && parent instanceOf?(Scope)) {
            fCall := expr as FunctionCall
            //printf("  >>> Composite call-chain %s\n", toString())
            expr = fCall expr
            fCall expr = null
            calls add(0, fCall)
        }

        scopeIdx := trail findScope()
        if (scopeIdx == -1) {
            res throwError(InternalError new(token, "Call-chain outside a scope! That doesn't make sense :/"))
            return Response LOOP // in case we're in all-errors mode
        }

        scope := trail get(scopeIdx)
        mark  : Statement
        if(scopeIdx + 1 < trail size()) {
            mark = trail get(scopeIdx + 1) // just before the scope - could be us, could be a call, who knows?
        } else {
            mark = this
        }

        // we need a VariableDecl to store the result of expr and
        // make all our calls on it
        if (!expr instanceOf?(VariableDecl)) {
            expr = VariableDecl new(null, generateTempName("callRoot"), expr, expr token)
        }
        varAcc := VariableAccess new(expr as VariableDecl, expr token)

        if(!trail addBeforeInScope(mark, expr)) {
            res throwError(CouldntAddBeforeInScope new(token, mark, expr, trail))
        }

        for(call in calls) {
            call expr = varAcc
            if(!trail addBeforeInScope(mark, call)) {
                res throwError(CouldntAddBeforeInScope new(token, mark, call, trail))
            }
        }
        if(!trail peek() replace(this, varAcc)) {
            res throwError(CouldntReplace new(token, this, varAcc, trail))
        }

        return Response OK

    }

    replace: func (oldie, kiddo: Node) -> Bool {
        false
    }

}
