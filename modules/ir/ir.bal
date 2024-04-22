public type Identifier string; // starts with "%" as a convention

public type Function record {|
    string name;
    map<Block> blocks;
    Identifier[] params; // all params are 64-bit integer
    Identifier[] vars; // all vars are 64-bir integer
    // return type is 64-bit integer
|};

// Block is a list of instructions that execute continuously
public type Block record {|
    Insn[] insns;
|};

public type Variable Identifier; // Variables are mutable, ie: you can assign
public type Operand Variable|int;
public type Label string;

public type Insn Return|Add|LessThan|JumpIf|Subtract|Call;

// Non-Terminals

public type Add record {|
    "add" kind;
    Operand[2] op;
    Variable result;
|};

public type LessThan record {|
    "lessThan" kind;
    Operand[2] op;
    Variable result;
|};

public type Subtract record {|
    "subtract" kind;
    Operand[2] op;
    Variable result;
|};

public type Call record {|
    "call" kind;
    string name;
    Operand[] op;
    Variable result;
|};

// Terminals - these can only appear as the last instruction of a block

public type JumpIf record {|
    "jumpIf" kind;
    Operand[1] op;
    Label ifTrue;
    Label ifFalse;
|};

public type Return record {|
    "return" kind;
    Operand[1] op;
|};
