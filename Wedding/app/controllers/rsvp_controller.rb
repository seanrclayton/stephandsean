class RsvpController < ApplicationController

  def index

  end

  def new

    @name = params['rsvper']
    @email = params['email']
    @number = params['number']
    @guest = params['guest']
   
    object = RSVP.new(:name => @name, :email => @email, :number => @number, :guest => @guest)
    object.save
  end
end
