class RsvpController < ApplicationController

  def index

  end

  def new

    @name = params['rsvper']
    @email = params['email']
    @number = params['number']
    @guest = params['guest']
    @guest_joined = @guest.join(",")
   
    object = Rsvp.create(:rsvper => @name, :email => @email, :number => @number, :guests => @guest_joined)
  end
end
