class AddCommentsToRsvps < ActiveRecord::Migration
  def change
    add_column :rsvps, :comments, :text
  end
end
