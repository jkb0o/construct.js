Struct = (name, subcons...) ->
    new StructClass(name, subcons)

UBInt8 = (name) ->
    new FormatField(name, "Uint8")

UBInt16 = (name) ->
    new FormatField(name, "Uint16")

UBInt32 = (name) ->
    new FormatField(name, "Uint32")

SBInt8 = (name) ->
    new FormatField(name, "Int8")

SBInt16 = (name) ->
    new FormatField(name, "Int16")

SBInt32 = (name) ->
    new FormatField(name, "Int32")

BFloat32 = (name) ->
    new FormatField(name, "Float32")

BFloat64 = (name) ->
    new FormatField(name, "Float64")
