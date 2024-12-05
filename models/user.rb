require "active_record"

class User < ActiveRecord::Base
  def name
    username
  end

  def id
    uid
  end
end
