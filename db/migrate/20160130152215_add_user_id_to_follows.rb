class AddUserIdToFollows < ActiveRecord::Migration
  def change
    add_column :follows, :user_id, :integer
  end
end
