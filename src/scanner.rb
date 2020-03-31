require_relative 'token'
require_relative 'scanner-exception'

class Scanner
  def initialize(source)
    @source = source
    @tokens = []
    @start = 0
    @current = 0
    @line = 1
  end

  def scan_tokens()
    while (!self.is_at_end()) do
      @start = @current

      self.scan_token()
    end

    @tokens.push(Token.new(Token::EOF, "", nil, @line))

    @tokens
  end

  def scan_token
    character = self.advance()

    case character
    when "("
      self.add_token(Token::LEFT_PARENTHESIS)
    when ")"
      self.add_token(Token::RIGHT_PARENTHESIS)
    when "{"
      self.add_token(Token::LEFT_BRACE)
    when "}"
      self.add_token(Token::RIGHT_BRACE)
    when ","
      self.add_token(Token::COMMA)
    when "."
      self.add_token(Token::DOT)
    when "-"
      self.add_token(Token::MINUS)
    when "+"
      self.add_token(Token::PLUS)
    when ";"
      self.add_token(Token::SEMICOLON)
    when "*"
      self.add_token(Token::STAR)
    when "!"
      self.add_token(matches("=") ? Token::BANG_EQUAL : Token::BANG)
    when "="
      self.add_token(matches("=") ? Token::EQUAL_EQUAL : Token::EQUAL)
    when "<"
      self.add_token(matches("=") ? Token::LESS_EQUAL : Token::LESS)
    when ">"
      self.add_token(matches("=") ? Token::GREATER_EQUAL : Token::GREATER)
    when "/"
      # is this a comment (//)?
      if (self.matches("/")) then
        while self.peek() != "\n" and !self.is_at_end() do
          self.advance()
        end
      else
        self.add_token(Token::SLASH)
      end
    # skip this whitespace
    when " ", "\r", "\t"
      nil
    when "\n"
      @line += 1
    when '"'
      self.string()
    else
      if self.is_digit(character)
        self.number()
      else
        Rlox.error(@line, "Unexpected character '#{character}'")
      end
    end
  end

  def matches(expected)
    return false if self.is_at_end()

    return false if @source[@current] != expected

    @current += 1

    true
  end

  def advance()
    @current += 1

    @source[@current - 1]
  end

  def peek(offset: 0)
    return "\0" if self.is_at_end(offset: offset)

    @source[@current + offset]
  end

  def add_token(type)
    add_token_with_value(type, nil)
  end

  def add_token_with_value(type, literal)
    text = @source[@start..@current - 1]

    @tokens.push(Token.new(type, text, literal, @line))
  end

  def is_at_end(offset: 0)
    @current + offset >= @source.length
  end

  def is_digit(character)
    character >= "0" and character <= "9"
  end

  def string()
    while self.peek() != '"' and !self.is_at_end() do
      if self.peek() == "\n" then
        @line += 1
      end

      self.advance()
    end

    if self.is_at_end() then
      Rlox.error(@line, "Unterminated string")
      return
    end

    # read the value from the source string, minus the quotes
    value = @source[@start + 1..@current - 1]

    # eat the closing "
    self.advance()

    add_token_with_value(Token::STRING, value)
  end

  def number()
    while self.is_digit(self.peek()) do
      self.advance()
    end

    if self.peek() == "." and self.is_digit(self.peek(offset: 1))
      # eat the .
      self.advance()

      while self.is_digit(self.peek()) do
        self.advance()
      end
    end

    value = @source[@start..@current - 1].to_f

    self.add_token_with_value(Token::NUMBER, value)
  end
end
