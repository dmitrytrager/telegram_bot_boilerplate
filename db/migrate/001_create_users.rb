class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, force: true do |t|
      t.bigint :uid
      t.string :username
    end
  end
end
