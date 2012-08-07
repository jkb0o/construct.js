ns = require('./construct.js')

s = new ns.construct.Struct('thing')

var struct = 1123;
var struct = null;

with ( ns.construct ){
    struct = Struct("attempt_1",
        UBInt8("Age"),
        SBInt16("Hairs"),
        UBInt32("Weight")
    )
}


result = struct.parse('\x01\x32\x21\x00\x00\x00\xff')
console.log(result)


//console.log(struct)
//console.log(struct.parse)


