class WhoscomingController < ApplicationController
  http_basic_authenticate_with name: "steph", password: "l1lyp4ds"

  def index
  @list = Rsvp.all 
  end
  
end
