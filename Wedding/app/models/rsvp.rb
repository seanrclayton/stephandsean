require 'csv'

class Rsvp < ActiveRecord::Base
  validates :rsvper, length: {  minimum: 2,
    too_short: "Your name has to have more than 2 characters" } 
  validates :number, length: {  minimum: 10,
    too_short: "We need your full number including the area code" } 

  def self.as_csv
  CSV.generate do |csv|
    csv << column_names
    all.each do |item|
      csv << item.attributes.values_at(*column_names)
    end
  end
end

end
