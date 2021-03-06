# typed: strict
# frozen_string_literal: true

module Rlox
  class Token
    extend T::Sig

    sig {returns(String)}
    attr_reader :type

    sig {returns(String)}
    attr_reader :lexeme

    sig {returns(T::nilable(String))}
    attr_reader :literal

    sig {returns(Integer)}
    attr_reader :line

    sig {params(type: String, lexeme: String, literal: T::nilable(String), line: Integer).void}
    def initialize(type, lexeme, literal, line)
      @type = type
      @lexeme = lexeme
      @literal = literal
      @line = line
    end

    sig {returns(String)}
    def to_s
      "#{@type} #{@lexeme} #{@literal}"
    end

    # Single-character tokens
    LEFT_PARENTHESIS = 'T_LEFT_PARENTHESIS'
    RIGHT_PARENTHESIS = 'T_RIGHT_PARENTHESIS'
    LEFT_BRACE = 'T_LEFT_BRACE'
    RIGHT_BRACE = 'T_RIGHT_BRACE'
    COMMA = 'T_COMMA'
    DOT = 'T_DOT'
    MINUS = 'T_MINUS'
    PLUS = 'T_PLUS'
    SEMICOLON = 'T_SEMICOLON'
    SLASH = 'T_SLASH'
    STAR = 'T_STAR'

    # One or two character tokens
    BANG = 'T_BANG'
    BANG_EQUAL = 'T_BANG_EQUAL'
    EQUAL = 'T_EQUAL'
    EQUAL_EQUAL = 'T_EQUAL_EQUAL'
    GREATER = 'T_GREATER'
    GREATER_EQUAL = 'T_GREATER_EQUAL'
    LESS = 'T_LESS'
    LESS_EQUAL = 'T_LESS_EQUAL'

    # Literals
    IDENTIFIER = 'T_IDENTIFIER'
    STRING = 'T_STRING'
    NUMBER = 'T_NUMBER'

    # Keywords
    AND = 'T_AND'
    CLASS = 'T_CLASS'
    ELSE = 'T_ELSE'
    FALSE = 'T_FALSE'
    FUN = 'T_FUN'
    FOR = 'T_FOR'
    IF = 'T_IF'
    NIL = 'T_NIL'
    OR = 'T_OR'
    PRINT = 'T_PRINT'
    RETURN = 'T_RETURN'
    SUPER = 'T_SUPER'
    THIS = 'T_THIS'
    TRUE = 'T_TRUE'
    VAR = 'T_VAR'
    WHILE = 'T_WHILE'

    EOF = 'T_EOF'

    KEYWORDS = T.let({
      'and' => AND,
      'class' => CLASS,
      'else' => ELSE,
      'false' => FALSE,
      'fun' => FUN,
      'for' => FOR,
      'if' => IF,
      'nil' => NIL,
      'or' => OR,
      'print' => PRINT,
      'return' => RETURN,
      'super' => SUPER,
      'this' => THIS,
      'true' => TRUE,
      'var' => VAR,
      'while' => WHILE
    }.freeze, T::Hash[String, String])
  end
end
