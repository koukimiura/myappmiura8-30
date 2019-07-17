class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
        t.integer :user_id
        t.integer :chat_id
      t.timestamps
    end
  end
end
