import ballerina/io;
import codegen.ir;

public type Function record {|
    string name;
    string[] params;
    Stmt[] stmts;
|};

public type Stmt IfStmt|ReturnStmt;

public type IfStmt record {|
    "if" kind;
    Expr cond;
    Stmt[] thenStmts;
    Stmt[] elseStmts;
|};

public type ReturnStmt record {|
    "return" kind;
    Expr op;
|};

public type Expr LessThan|Add|Subtract|Call|Literal|Ref;

public type LessThan record {|
    "lessThan" kind;
    Expr[] ops;
|};

public type Add record {|
    "add" kind;
    Expr[] ops;
|};

public type Subtract record {|
    "subtract" kind;
    Expr[] ops;
|};

public type Call record {|
    "call" kind;
    string name;
    Expr[] ops;
|};

public type Literal int;

public type Ref string; // string with "%"

public function main() {
    ir:Function f = codeGen({
        name: "fib",
        params: ["%n"],
        stmts: [
            { kind: "if",
                      cond: { kind: "lessThan", ops: ["%n", 2] },
                        thenStmts: [{ kind: "return", op: "%n" }],
                        elseStmts: [{ kind: "return", op: { kind: "add",
                            ops: [
                                { kind: "call", name: "fib", ops: [{ kind: "subtract", ops: ["%n", 1] }] },
                                { kind: "call", name: "fib", ops: [{ kind: "subtract", ops: ["%n", 2] }] } ] } } ] }] });
    io:println(f);
}

public function codeGen(Function f) returns ir:Function {
    return { name: "fib",
  params: ["%n"],
  vars: ["%lessThan2", "%nSub1", "%nSub2", "%fib1", "%fib2", "%result"],
  blocks: { "entry": {
                insns: [
                    { kind: "lessThan", op: ["%n", 2], result: "%lessThan2" },
                    { kind: "jumpIf", op:["%lessThan2"], ifTrue: "ifCase", ifFalse: "elseCase" } ] },
            "ifCase": {
                insns: [
                    { kind: "return", op: ["%n"] } ] },
            "elseCase": {
                insns: [
                    { kind: "subtract", op: ["%n", 1], result: "%nSub1" },
                    { kind: "subtract", op: ["%n", 2], result: "%nSub2" },
                    { kind: "call", name:"fib", op: ["%nSub1"], result: "%fib1" },
                    { kind: "call", name:"fib", op: ["%nSub2"], result: "%fib2" },
                    { kind: "add", op: ["%fib1", "%fib2"], result: "%result" },
                    { kind: "return", op: ["%result"] } ] } } };
};
