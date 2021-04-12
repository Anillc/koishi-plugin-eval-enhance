isDigest = (char) ->
  code = char?.charCodeAt 0
  return 48 <= code <= 57
isLetter = (char) ->
  code = char?.charCodeAt 0
  return 65 <= code <= 90 || 97 <= code <= 122

class Lexer
  pos: -1
  ch: ' '
  constructor: (@input) ->
  read: -> @ch = if @input.length > @pos + 1 then @input[++@pos] else null
  next: ->
    loop if @ch == ' ' then @read() else break
    return null if !@ch
    if isLetter @ch
      id = @ch
      while isLetter @read()
        id += @ch
      return { type: 'id', value: id }
    console.log isDigest @ch
    if isDigest @ch
      num = @ch
      while isDigest @read()
        num += @ch
      return { type: 'number', value: num }
    if @ch == '"' || @ch == '\'' || @ch == '`'
      left = @ch
      str = ''
      loop
        switch @read()
          when left
            @ch = ' '
            return @peek = { type: 'string', value: str }
          when '\\'
            str += @read()
            continue
          when null then throw 'Unexpected EOF'
          else str += @ch
     value = @ch
     @ch = ' '
     return @peek = { type: 'char', value }

module.exports = (initiator, terminator, src) ->
  lexer = new Lexer src
  count = 1
  loop
    break if count == 0
    token = lexer.next()
    throw 'Unexpected EOF' if !token
    count++ if token.type == 'char' && token.value == initiator
    count-- if token.type == 'char' && token.value == terminator
  return { code: src[0..lexer.pos - 1], rest: src.slice lexer.pos + 1 }
