require "./models/user"
require "./models/chat"
require "./models/allowed_user"
require "./lib/message_sender"
require "./lib/chatgpt_response"
require "./lib/prompt"

require "telegram/bot"

class MessageResponder
  ADMIN = 61_621_754 # me

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @msg_sender = options[:msg_sender] || MessageSender

    return unless options[:track]

    @user = init_user
    @chat = init_chat
  end

  def respond
    case message
    when Telegram::Bot::Types::InlineQuery, Telegram::Bot::Types::Location
      return
    when Telegram::Bot::Types::CallbackQuery
      return
    end

    return unless message.is_a? Telegram::Bot::Types::Message

    on %r{^\/start} do
      answer_with_message(I18n.t("greeting_message"))
    end
  end

  private

  attr_reader :message, :bot, :user, :chat, :msg_sender, :chatgpt

  def on(regex, &block)
    regex =~ message.text
    return unless $~ # rubocop:disable Style/SpecialGlobalVars

    case block.arity
    when 0
      yield
    when 1
      yield ::Regexp.last_match(1)
    when 2
      yield ::Regexp.last_match(1), ::Regexp.last_match(2)
    end
  end

  def answer_with_message(text)
    msg_sender.new(bot: bot, chat: send_to, text: text).send
  end

  def send_to
    if chat&.ready?
      chat.update(last_posted_at: DateTime.now)
      return chat
    end

    user
  end

  def init_user
    user = User.find_or_create_by(uid: message.from.id)
    user.update(username: message.from.username)
    user
  end

  def init_chat
    return unless message.respond_to?(:chat)

    chat = Chat.find_or_create_by(uid: message.chat.id)
    chat.update(title: message.chat.title)
    chat
  end
end
