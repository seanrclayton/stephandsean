class Rsvp < ActiveRecord::Base
  validates :rsvper, length: {  minimum: 2,
    too_short: "Your name has to have more than 2 characters" } 
end
