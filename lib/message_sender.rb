require "./lib/reply_markup_formatter"
require "./lib/inline_markup_formatter"
require "./lib/app_configurator"

class MessageSender
  def initialize(options)
    @bot = options[:bot]
    @text = options[:text]
    @chat = options[:chat]
    @answers = options[:answers]
    @requests = options[:requests]
    @logger = AppConfigurator.new.logger
  end

  def send
    if reply_markup
      bot.api.send_message(chat_id: chat.id, text: text, reply_markup: reply_markup)
    else
      bot.api.send_message(chat_id: chat.id, text: text)
    end

    logger.debug "sending '#{text}' to #{chat.name.presence || chat.id}"
  rescue StandardError => e
    logger.debug "Exception #{e}"
    # save_error_to_user(e)
  end

  private

  attr_reader :bot, :text, :chat, :answers, :requests, :logger

  def reply_markup
    return InlineMarkupFormatter.new(answers).markup if answers

    ReplyMarkupFormatter.new(requests).markup if requests
  end
end
