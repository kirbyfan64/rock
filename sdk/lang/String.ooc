/*  The String class is immutable by default, this means every writing operation
    is done on a clone, which is then returned

    most work done by rofl0r

    */

String: class {

    // accessing this member directly can break immutability, so you should avoid it.
    _buffer: Buffer

    size: SizeT {
        get {
            _buffer size
        }
    }

    init: func { _buffer = Buffer new() }

    init: func ~zeroCopy(dummy: Bool) {_buffer = null}

    init: func ~withBuffer(b: Buffer) { _buffer = b }

    init: func ~withChar(c: Char) { _buffer = Buffer new~withChar(c) }

    /** warning: this function is useful when you directly want to manipulate the underlying
        buffer. which is against the immutability concept, but still useful sometimes */
    init: func ~withCapacity (capa: SizeT) {
        Exception new("it looks as if you want to use String as a Buffer! how about using Buffer instead ? i cant allow it, it would break Strings immutability.") throw()
        _buffer = Buffer new(capa)
    }

    init: func ~withString (s: String) {
        assert( s != null)
        assert( s _buffer != null)
        _buffer = s _buffer clone()
    }

    init: func ~withCStr (s : CString) { _buffer = Buffer new~withCStr(s) }

    init: func ~withCStrAndLength(s : CString, length: SizeT) { _buffer = Buffer new~withCStrAndLength(s, length) }

    length: func -> SizeT { _buffer size }

    equals?: func (other: This) -> Bool {
        other == this
    }

    charAt: func (index: SizeT) -> Char { _buffer charAt(index) }

    clone: func -> This {
        This new~withBuffer( _buffer clone() )
    }

    substring: func ~tillEnd (start: SizeT) -> This { substring(start, size) }

    substring: func (start: SizeT, end: SizeT) -> This{
        result := _buffer clone()
        result substring(start, end)
        result toString()
    }

    times: func (count: SizeT) -> This {
        result := _buffer clone(size * count)
        result times(count)
        result toString()
    }

    append: func ~str(other: This) -> This{
        assert(other != null)
        result := _buffer clone(size + other size)
        result append (other _buffer)
        result toString()
    }

    append: func ~char (other: Char) -> This {
        result := _buffer clone(size + 1)
        result append~char(other)
        result toString()
    }

    append: func ~cStr (other: CString) -> This {
        assert(other != null)
        l := other length()
        result := _buffer clone(size + l)
        result append(other, l)
        result toString()
    }

    prepend: func ~str (other: This) -> This{
        assert(other != null)
        result := _buffer clone()
        result prepend~buf(other _buffer)
        result toString()
    }

    prepend: func ~char (other: Char) -> This {
        assert(other != null)
        result := _buffer clone()
        result prepend~char(other)
        result toString()
    }

    compare: func (other: This, start, length: SizeT) -> Bool {
        _buffer compare(other _buffer, start, length)
    }

    compare: func ~implicitLength (other: This, start: SizeT) -> Bool {
        _buffer compare(other _buffer, start)
    }

    compare: func ~whole (other: This) -> Bool {
        _buffer compare(other _buffer)
    }

    empty?: func -> Bool { _buffer empty?() }

    startsWith?: func (s: This) -> Bool { _buffer startsWith? (s _buffer) }

    startsWith?: func ~char(c: Char) -> Bool { _buffer startsWith?~char(c) }

    endsWith?: func (s: This) -> Bool { _buffer endsWith? (s _buffer) }

    endsWith?: func ~char(c: Char) -> Bool { _buffer endsWith?~char (c) }

    find : func (what: This, offset: SSizeT) -> SSizeT { _buffer find( what _buffer, offset) }

    find : func ~withCase (what: This, offset: SSizeT, searchCaseSensitive : Bool) -> SSizeT {
        _buffer find~withCase( what _buffer, offset, searchCaseSensitive )
    }

    findAll: func ( what : This) -> ArrayList <SizeT> { _buffer findAll( what _buffer ) }

    findAll: func ~withCase ( what : This, searchCaseSensitive: Bool) -> ArrayList <SizeT> {
        _buffer findAll~withCase( what _buffer, searchCaseSensitive )
    }

    replaceAll: func ~str (what, whit : This) -> This {
        replaceAll~strWithCase (what, whit, true)
    }

    replaceAll: func ~strWithCase (what, whit : This, searchCaseSensitive: Bool) -> This {
        result := _buffer clone()
        result replaceAll~bufWithCase (what _buffer, whit _buffer, searchCaseSensitive)
        result toString()
    }

    replaceAll: func ~char(oldie, kiddo: Char) -> This {
        result := _buffer clone()
        result replaceAll~char(oldie, kiddo)
        result toString()
    }

    _bufArrayListToStrArrayList: func ( x : ArrayList<Buffer> ) -> ArrayList<This> {
        result := ArrayList<This> new( x size() )
        for (i in x) result add ( i toString() )
        result
    }

    split: func~withChar(c: Char, maxSplits: SSizeT) -> ArrayList <This> {
        _bufArrayListToStrArrayList( _buffer split~withChar(c, maxSplits) )
    }

    split: func~withStringWithoutMaxSplits(s: This) -> ArrayList <This> {
        _bufArrayListToStrArrayList( _buffer split ( s _buffer, -1) )
    }

    split: func~withCharWithoutMaxSplits(c: Char) -> ArrayList <This> {
        _bufArrayListToStrArrayList( _buffer split~withCharWithoutMaxSplits(c) )
    }

    split: func~withStringWithEmpties( s: This, empties: Bool) -> ArrayList <This> {
        _bufArrayListToStrArrayList( _buffer split~withBufWithEmpties (s _buffer, empties ) )
    }

    split: func~withCharWithEmpties(c: Char, empties: Bool) -> ArrayList <This> {
        _bufArrayListToStrArrayList( _buffer split~withCharWithEmpties( c , empties ) )
    }

    split: func ~str (delimiter: This, maxSplits: SSizeT) -> ArrayList <This> {
        _bufArrayListToStrArrayList( _buffer split~buf ( delimiter _buffer, maxSplits ) )
    }

    toLower: func -> This {
        result := _buffer clone()
        result toLower()
        result toString()
    }

    toUpper: func  -> This{
        result := _buffer clone()
        result toUpper()
        result toString()
    }

    indexOf: func ~charZero (c: Char) -> SSizeT { _buffer indexOf~charZero(c) }

    indexOf: func ~char (c: Char, start: SizeT) -> SSizeT { _buffer indexOf~char(c, start) }

    indexOf: func ~stringZero (s: This) -> SSizeT { _buffer indexOf~bufZero (s _buffer) }

    indexOf: func ~buf (s: This, start: Int) -> SSizeT { _buffer indexOf~buf(s _buffer, start) }

    contains?: func ~char (c: Char) -> Bool { _buffer contains?~char (c) }

    contains?: func ~string (s: This) -> Bool { _buffer contains?~buf (s _buffer) }

    trimMulti: func ~pointer (s: Char*, sLength: SizeT) -> This {
        result := _buffer clone()
        result trimMulti(s, sLength)
        result toString()
    }

    trimMulti: func ~string(s : This) -> This {
        result := _buffer clone()
        result trimMulti(s _buffer)
        result toString()
    }

    trim: func~pointer(s: Char*, sLength: SizeT) -> This {
        result := _buffer clone()
        result trim~pointer(s, sLength)
        result toString()
    }

    trim: func ~string(s : This) -> This {
        result := _buffer clone()
        result trim~buf(s _buffer)
        result toString()
    }

    trim: func ~char (c: Char) -> This {
        result := _buffer clone()
        result trim~char(c)
        result toString()
    }

    trim: func ~whitespace -> This {
        result := _buffer clone()
        result trim~whitespace()
        result toString()
    }

    trimLeft: func ~space -> This {
        result := _buffer clone()
        result trimLeft~space()
        result toString()
    }

    trimLeft: func ~char (c: Char) -> This {
        result := _buffer clone()
        result trimLeft~char(c)
        result toString()
    }

    trimLeft: func ~string (s: This) -> This {
        result := _buffer clone()
        result trimLeft~buf(s _buffer)
        result toString()
    }

    trimLeft: func ~pointer (s: Char*, sLength: SizeT) -> This {
        result := _buffer clone()
        result trimLeft~pointer(s, sLength)
        result toString()
    }

    trimRight: func ~space -> This {
        result := _buffer clone()
        result trimRight~space()
        result toString()
    }

    trimRight: func ~char (c: Char) -> This {
        result := _buffer clone()
        result trimRight~char(c)
        result toString()
    }

    trimRight: func ~string (s: This) -> This{
        result := _buffer clone()
        result trimRight~buf( s _buffer )
        result toString()
    }

    trimRight: func ~pointer (s: Char*, sLength: SizeT) -> This{
        result := _buffer clone()
        result trimRight~pointer(s, sLength)
        result toString()
    }

    reverse: func -> This {
        result := _buffer clone()
        result reverse()
        result toString()
    }

    count: func (what: Char) -> SizeT { _buffer count (what) }

    count: func ~string (what: This) -> SizeT { _buffer count~buf(what _buffer) }

    first: func -> Char { _buffer first() }

    lastIndex: func -> SSizeT { _buffer lastIndex() }

    last: func -> Char { _buffer last() }

    lastIndexOf: func (c: Char) -> SSizeT { _buffer lastIndexOf(c) }

    print: func { _buffer print() }

    println: func { if(_buffer != null) _buffer println() }

    toInt: func -> Int                       { _buffer toInt() }
    toInt: func ~withBase (base: Int) -> Int { _buffer toInt~withBase(base) }
    toLong: func -> Long                        { _buffer toLong() }
    toLong: func ~withBase (base: Long) -> Long { _buffer toLong~withBase(base) }
    toLLong: func -> LLong                         { _buffer toLLong() }
    toLLong: func ~withBase (base: LLong) -> LLong { _buffer toLLong~withBase(base) }
    toULong: func -> ULong                         { _buffer toULong() }
    toULong: func ~withBase (base: ULong) -> ULong { _buffer toULong~withBase(base) }
    toFloat: func -> Float                         { _buffer toFloat() }
    toDouble: func -> Double                       { _buffer toDouble() }
    toLDouble: func -> LDouble                     { _buffer toLDouble() }

    iterator: func -> BufferIterator<Char> {
        _buffer iterator()
    }

    forward: func -> BufferIterator<Char> {
        _buffer forward()
    }

    backward: func -> BackIterator<Char> {
        _buffer backward()
    }

    backIterator: func -> BufferIterator<Char> {
        _buffer backIterator()
    }

    format: final func ~ str (...) -> This {
        result := clone()
        list:VaList
        fmt := result _buffer

        va_start(list, this)
        length := vsnprintf(null, 0, (fmt data), list)
        va_end(list)

        copy := Buffer new~withSize(length, false)

        va_start(list, this )
        vsnprintf((copy data), length + 1, (fmt data), list)
        va_end(list)
        This new~withBuffer(copy)
    }

    printf: final func ~str (...) -> This {
        assert(false)
        Exception new("cant set Buffer size after this call. please use format instead") throw()
        result := clone()
        list: VaList

        va_start(list, this )
        vprintf((result _buffer data), list)
        va_end(list)
        return result
    }

     printfln: final func ~str (...) -> This {
        assert(false)
        Exception new("cant set Buffer size after this call. please use format instead") throw()
        result := append('\n')
        list: VaList

        va_start(list, this )
        vprintf((result _buffer data), list)
        va_end(list)
        return result
    }

    toCString: func -> CString { _buffer data as CString }

}

operator implicit as (s: String) -> Char* {
    if (s == null) return null
    assert(s _buffer != null)
    s _buffer data
}

operator implicit as (c: Char*) -> String {
    if (c == null) {
        b: String = null
        return b
    }
    assert(c != null)
    return c ? String new (c as CString, strlen(c)) : null
}

operator implicit as (c: CString) -> String {
    if (c == null) {
        b: String = null
        return b
    }
    return c ? String new (c, strlen(c)) : null
}

operator implicit as (s: String) -> CString {
    if (s == null) return null
    assert(s _buffer != null)
    s _buffer data as CString
}



operator == (str1: String, str2: String) -> Bool {
    if (str1 == null && str2 != null) return false
    if (str2 == null && str1 != null) return false
    if (str1 == null && str2 == null) return true
    return str1 _buffer  ==  str2 _buffer
}

operator != (str1: String, str2: String) -> Bool {
    !(str1 == str2)
}

operator [] (string: String, index: SizeT) -> Char {
    assert (string != null)
    string _buffer [index]
}

operator []= (string: String, index: SizeT, value: Char) {
    Exception new(String, "Writing to a String breaks immutability! use a Buffer instead!" format(index, string length())) throw()
}

operator [] (string: String, range: Range) -> String {
    assert (string != null)
    string substring(range min, range max)
}

operator * (string: String, count: Int) -> String {
    assert (string != null)
    return string times(count)
}

operator + (left, right: String) -> String {
    assert ((left != null) && (right != null))
    left append( right )
}

operator + (left: String, right: CString) -> String {
    assert ((left != null) && (right != null))
    left append(right)
}

operator + (left: String, right: Char) -> String {
    assert ((left != null))
    left append(right)
}

operator + (left: Char, right: String) -> String {
    assert ((right != null))
    right prepend(left)
}

// constructor to be called from string literal initializers
makeStringLiteral: func (str: CString, strLen: SizeT) -> String {
    result := String new~zeroCopy(false)
    result _buffer = Buffer new~stringLiteral(str, strLen, true)
    result
}

// lame static function to be called by int main, so i dont have to metaprogram it
import structs/ArrayList

strArrayListFromCString: func (argc: Int, argv: Char**) -> ArrayList<String> {
    result := ArrayList<String> new ()
    for (i in 0..argc)  result add( argv[i] as CString toString() )
    result
}

/* damn, there's one probelm left. rock makes
source/rock/rock.ooc:4:12 ERROR No such function strArrayListFromCString(Int, String*)
 i make this quick hack here
 */
strArrayListFromCString: func~hack (argc: Int, argv: String*) -> ArrayList<String> {
    strArrayListFromCString(argc, argv as Char**)
}


