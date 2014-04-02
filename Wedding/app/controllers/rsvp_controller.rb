class RsvpController < ApplicationController

  def index

  end

  def new

    @name = params['name']
    @email = params['email']
    @number = params['number']
    @guest = params['guest']
    @guest_joined = @guest.join(",")
    @comments = params['comments']
    object = Rsvp.create(:rsvper => @name, :email => @email, :number => @number, :guests => @guest_joined, :comments => @comments)
    redirect_to thankyou_path(:name => @name)
  end
end
