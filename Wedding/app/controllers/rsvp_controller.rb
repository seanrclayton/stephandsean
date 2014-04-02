class RsvpController < ApplicationController

  def index

  end

  def new

    @name = params['rsvper']
    @email = params['email']
    @number = params['number']
    @guest = params['guest']
   
    object = RSVP.new(:name => @name, :age => 2)
    object.save
  end
end
