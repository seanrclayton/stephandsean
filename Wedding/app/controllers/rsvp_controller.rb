class RsvpController < ApplicationController

  def index

  end

  def new

    @name = params['rsvper']
    object = RSVP.new(:name => @name, :age => 2)
    object.save
  end
end
