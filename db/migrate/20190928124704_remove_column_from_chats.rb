class RemoveColumnFromChats < ActiveRecord::Migration[5.0]
  def change
    remove_column :chats, :name, :string 
  end
end
