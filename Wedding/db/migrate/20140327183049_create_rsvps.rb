class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.string :rsvper
      t.string :email
      t.string :number
      t.text :guests

      t.timestamps
    end
  end
end
