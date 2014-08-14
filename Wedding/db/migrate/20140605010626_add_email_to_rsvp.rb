class AddEmailToRsvp < ActiveRecord::Migration
  def change
    add_column :rsvps, :attending, :string
  end
end
