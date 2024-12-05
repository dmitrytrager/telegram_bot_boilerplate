require "minitest/autorun"
require "ostruct"
require "telegram/bot"
require_relative "./test_sender"
require_relative "./test_chatgpt"
require_relative "../lib/message_responder"

class TestMessageResponder < Minitest::Test
  def setup
    AppConfigurator.new.configure
    @message = generate_message("/start")
  end

  def test_on_start
    responder = MessageResponder.new(
      message: @message,
      msg_sender: TestSender,
    )

    assert_equal "", responder.respond
  end
end
