class TestSender
  def initialize(options)
    @options = options
  end

  def send
    @options[:answers] || @options[:text]
  end
end
