Task
----

You are writing a compiler for a new programming language.
Assume frontend is already implemented and provides you following records as input to your backend.
Your task is to produce the given IR.

Hardcoded version of `codeGen` function is provided in the `main.bal` file.
Modify the `codeGen` function to generate the IR form the input.

Spec
----

Input (source, not important for the task, but for your understanding):
```
def fib(n):
    if n < 2:
        return n
    else:
        return fib(n - 1) + fib(n - 2)
```

Input (form frontend):
```
{ name: "fib",
  params: ["%n"],
  stmts: [ { kind: "if",
             cond: { kind: "lessThan", ops: ["%n", 2] },
             thenStmts: [{ kind: "return", ops: ["%n"] }],
             elseStmts: [{ kind: "return", ops: [
                         { kind: "add", ops: [
                             { kind: "call", name: "fib", ops: [{ kind: "subtract", ops: ["%n", 1] }] },
                             { kind: "call", name: "fib", ops: [{ kind: "subtract", ops: ["%n", 2] }] } ] } ] }] }
```

Expected Output:
```
{ name: "fib",
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
                    { kind: "return", op: ["%result"] } ] } } }
```

Test
----

Run `bal test` to test

Bonus
------

Write a test case for Euclid's algorithm and make it pass
