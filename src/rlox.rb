require_relative 'scanner'

class Rlox
  @had_error = false

  def run_file(path)
    contents = File.read(path)

    run(contents)

    if @had_error
      exit 65
    end
  end

  def run_prompt()
    loop do
      print "> "
      $stdout.flush

      input = gets

      run(input)

      @had_error = false
    end
  end

  def run(source)
    scanner = Scanner.new(source)

    tokens = scanner.scan_tokens()

    tokens.each do |token|
      puts token
    end
  end

  def self.error(line, message)
    self.report(line, "", message)
  end

  def self.report(line, where, message)
    puts "[line #{line}] Error #{where}: #{message}"

    @had_error = true
  end
end
