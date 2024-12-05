class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats, force: true do |t|
      t.bigint :uid
      t.string :title
      t.datetime :last_posted_at
    end
  end
end
