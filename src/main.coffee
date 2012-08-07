construct = 
    Struct      : Struct,
    UBInt8      : UBInt8,
    UBInt16     : UBInt16,
    UBInt32     : UBInt32,
    SBInt8      : SBInt8,
    SBInt16     : SBInt16,
    SBInt32     : SBInt32,
    BFloat32    : BFloat32,
    BFloat64    : BFloat64


window.construct = construct if window?
exports.construct = construct if exports?
