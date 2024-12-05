require "active_record"

class Chat < ActiveRecord::Base
  def name
    title
  end

  def id
    uid
  end
end
