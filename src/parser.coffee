class Lexer
  pos: -1
  ch: ' '
  peek: null

  constructor: (@input) ->
  read: -> @ch = if @input.length > @pos + 1 then @input[++@pos] else null
  next: ->
    loop if @ch == ' ' then @read() else break
    return null if !@ch
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
