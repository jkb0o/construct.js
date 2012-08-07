class Stream
    
    constructor: (buffer=1024) ->
        @pos = 0
        if buffer instanceof ArrayBuffer
            @buffer = buffer
        else if typeof buffer == 'number'
            @buffer = new ArrayBuffer(buffer)
            consol.log 4
        else
            throw new Error 'Bad type of buffer for stream'

        @view = new DataView @buffer

    read: (length) ->
        data = @buffer.slice @pos, @pos + length
        @position += length
        return data

    readUint8: () ->
        @pos += 1
        @view.getUint8 @pos-1

    readUint16: () ->
        @pos += 2
        @view.getUint16 @pos-2

    readUint32: () ->
        @pos += 4
        @view.getUint32 @pos-4
    
    readInt8: () ->
        @pos += 1
        @view.getInt8 @pos-1

    readInt16: () ->
        @pos += 2
        @view.getInt16 @pos-2

    readInt32: () ->
        @pos += 4
        @view.getInt32 @pos-4

    readFloat32: () ->
        @pos += 4
        @view.getFloat32 @pos-4

    readFloat64: () ->
        @pos += 8
        @view.getFloat64 @pos-8
        

class Construct

    FLAG_COPY_CONTEXT          : 0x0001
    FLAG_DYNAMIC               : 0x0002
    FLAG_EMBED                 : 0x0004
    FLAG_NESTING               : 0x0008

    slots: ['name', 'conflags']

    constructor: () ->
        if !Construct.__clone__
            @.__init__.apply(@, arguments)

    __cloning__: false

    __init__: ( name, flags=0 ) ->
        @name = name
        @conflags = flags

    __getstate__: () ->
        attrs = {}
        slots = @slots
        parent = @constructor.__super__
        while parent && parent.slots
            slots = slots.concat parent.slots
            parent = parent.constructor && parent.constructor.__super__
        
        for key in slots
            attrs[key] = @[key]

        attrs

    __setstate__: (attrs) ->
        for key, val in attrs
            @[key] = val

    
    _setFlag: (flag) ->
        @conflags |= flag

    _clearFlag: (flag) ->
        @conflags &= ~flag

    _inheritFlags: (subcons) ->
        for sc in subcons
            @conflags |= sc.conflags

    _isFlag: (flag) ->
        Boolean @conflags & flag

    clone: () ->
        Construct.__cloning__ = true
        copy = new @constructor()
        Construct.__cloning__ = false
        copy.__setstate__ @__getstate__
            
    parse: (data) ->
        stream = null
        if data instanceof ArrayBuffer
            stream = new Stream(data)
        else if typeof data == 'string'
            buffer = new ArrayBuffer(data.length)
            view = new Uint8Array(buffer)
            for pos in [0..data.length]
                view[pos] = data.charCodeAt(pos)
            stream = new Stream(buffer)
        else
            throw new Error("Method `parse` recieve ArrayBuffer or String")
            
        @parse_stream stream

    parse_stream: (stream) ->
        @_parse(stream, {})

    _parse: (stream, ctx) ->
        throw new Error("Not implemented")

    build: (data) ->
        throw new Error("Method `build` not implemented, use build_stream instead")

    build_stream: (obj, stream) ->
        @_build(obj, stream, {})

    _build: (obj, stream, ctx) ->
        throw new Error("Not implemented")

    sizeof: (ctx) ->
        ctx ||= {}
        return @size_of(ctx)

    _sizeof: (ctx) ->
        throw new Error("Not implemented")
        


class StructClass extends Construct
    slots: ['subcons', 'nested']
    nested: true

    __init__: ( name, subcons) ->
        super name
        @subcons = subcons
        @_inheritFlags subcons
        @_clearFlag(@FLAG_EMBED)

    _parse: (stream, ctx) ->
        if ctx['<obj>']
            obj = ctx['<obj>']
            delete ctx['<obj>']
        else
            obj = {}
            if @nested
                ctx = { '_' : ctx }
        
        for sc in @subcons
            if sc.conflags & @FLAG_EMBED
                ctx['<obj>'] = obj
                sc._parse stream, ctx
            else
                subobj = sc._parse stream, ctx
                if sc.name?
                    obj[sc.name] = subobj
                    ctx[sc.name] = subobj
        
        return obj

    _build: (obj, stream, ctx) ->
        if ctx['<unnested>']
            delete ctx['<unnested>']
        else if @nested
            ctx = { '_': ctx }
        for sc in @subcons
            if sc.conflags & @FLAG_EMBED
                ctx['<unnested>'] = true
                subobj = obj
            else if !sc.name
                subobk = null
            else
                subobj = obj[sc.name]
                ctx[sc.name] = subobj
            sc._build subobj, stream, ctx

    _sizeof: (ctx) ->
        if @nested
            ctx = { '_': ctx }
        sum = 0
        for sc in subcons
            sum += sc._sizeif(ctx)

        


            


class StaticField extends Construct
    slots: ['length']

    __init__: (name, length) ->
        super name
        @length = length

    _sizeof: (ctx) ->
        @length

class FormatField extends StaticField
    slots: ['format', 'writer', 'reader']
    formats: {
        Uint8: 1, Int8: 1,
        Uint16: 2, Int16: 2,
        Uint32: 4, Int32: 4, Float32: 4,
        Float64: 8
    }

    __init__: (name, format) ->
        @format = format
        @reader = 'read' + @format
        @writer = 'write' + @format
        super name, @formats[format]

    _parse: (stream, ctx) ->
        stream[@reader]()

    _build: (obj, stream, ctx) ->
        stream[@writer] obj
        
        
