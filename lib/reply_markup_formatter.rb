class ReplyMarkupFormatter
  attr_reader :array

  def initialize(array)
    @array = array
  end

  def markup
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: keyboard, one_time_keyboard: true)
  end

  private

  def keyboard
    array.map do |a|
      Telegram::Bot::Types::KeyboardButton.new(
        text: a[:text],
        request_contact: a[:request] == "contact",
        request_location: a[:request] == "location",
      )
    end
  end
end
