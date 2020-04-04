# typed: true
# frozen_string_literal: true

require_relative 'token'

class Scanner
  def initialize(source)
    @source = source
    @tokens = []
    @start = 0
    @current = 0
    @line = 1
  end

  def scan_tokens
    until is_at_end?
      @start = @current

      scan_token
    end

    @tokens.push(Token.new(Token::EOF, '', nil, @line))

    @tokens
  end

  private

  def scan_token
    character = advance

    case character
    when '(' then add_token(Token::LEFT_PARENTHESIS)
    when ')' then add_token(Token::RIGHT_PARENTHESIS)
    when '{' then add_token(Token::LEFT_BRACE)
    when '}' then add_token(Token::RIGHT_BRACE)
    when ',' then add_token(Token::COMMA)
    when '.' then add_token(Token::DOT)
    when '-' then add_token(Token::MINUS)
    when '+' then add_token(Token::PLUS)
    when ';' then add_token(Token::SEMICOLON)
    when '*' then add_token(Token::STAR)
    when '!' then add_token(matches?('=') ? Token::BANG_EQUAL : Token::BANG)
    when '=' then add_token(matches?('=') ? Token::EQUAL_EQUAL : Token::EQUAL)
    when '<' then add_token(matches?('=') ? Token::LESS_EQUAL : Token::LESS)
    when '>' then add_token(matches?('=') ? Token::GREATER_EQUAL : Token::GREATER)
    when ' ', "\r", "\t" then nil
    when "\n" then @line += 1
    when '"' then string

    when '/'
      # is this a comment (//)?
      if matches?('/')
        advance while peek != "\n" && !is_at_end?
      # is this a block comment (/*)?
      elsif matches?('*')
        until is_at_end?
          advance

          next unless (peek == '*') && (peek_next == '/')

          # eat the closing "*/"
          advance
          advance

          break
        end
      else
        add_token(Token::SLASH)
      end

    else
      if is_digit?(character)
        number
      elsif is_alpha?(character)
        identifier
      else
        Rlox.error(@line, "Unexpected character '#{character}'")
      end
    end
  end

  def matches?(expected)
    return false if is_at_end?

    return false if @source[@current] != expected

    @current += 1

    true
  end

  def advance
    @current += 1

    @source[@current - 1]
  end

  def peek
    return "\0" if is_at_end?

    @source[@current]
  end

  def peek_next
    return "\0" if @current + 1 >= @source.length

    @source[@current + 1]
  end

  def add_token(type)
    add_token_with_value(type, nil)
  end

  def add_token_with_value(type, literal)
    text = @source[@start..@current - 1]

    @tokens.push(Token.new(type, text, literal, @line))
  end

  def is_at_end?
    @current >= @source.length
  end

  def is_digit?(character)
    character >= '0' && character <= '9'
  end

  def is_alpha?(character)
    (character >= 'a' && character <= 'z') || (character >= 'A' && character <= 'Z') || character == '_'
  end

  def is_alpha_numeric?(character)
    is_digit?(character) || is_alpha?(character)
  end

  def string
    while peek != '"' && !is_at_end?
      @line += 1 if peek == "\n"

      advance
    end

    if is_at_end?
      Rlox.error(@line, 'Unterminated string')
      return
    end

    # read the value from the source string, minus the quotes
    value = @source[@start + 1..@current - 1]

    # eat the closing "
    advance

    add_token_with_value(Token::STRING, value)
  end

  def number
    advance while is_digit?(peek)

    if peek == '.' && is_digit?(peek_next)
      # eat the .
      advance

      advance while is_digit?(peek)
    end

    value = @source[@start..@current - 1].to_f

    add_token_with_value(Token::NUMBER, value)
  end

  def identifier
    advance while is_alpha_numeric?(peek)

    value = @source[@start..@current - 1]

    type = Token::IDENTIFIER

    type = Token::KEYWORDS[value] if Token::KEYWORDS.key?(value)

    add_token(type)
  end
end
