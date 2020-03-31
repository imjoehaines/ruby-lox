class ScannerException < StandardError
  attr_reader :message
  attr_reader :line

  def initialize(message, line)
    @message = message
    @line = line

    super(message)
  end
end
