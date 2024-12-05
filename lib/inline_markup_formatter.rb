class InlineMarkupFormatter
  attr_reader :array

  def initialize(array)
    @array = array
  end

  def markup
    kb = array.map do |a|
      Telegram::Bot::Types::InlineKeyboardButton
        .new(text: a[:text], callback_data: a[:callback])
    end

    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end
end
