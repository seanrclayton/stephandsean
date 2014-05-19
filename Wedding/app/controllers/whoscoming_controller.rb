class WhoscomingController < ApplicationController
  http_basic_authenticate_with name: "steph", password: "l1lyp4ds"

  def index
    
    @whoscoming = Rsvp.order(:created_at)
  
  respond_to do |format|
    format.html
    format.csv { send_data @whoscoming.as_csv }
  end
  
  @list = Rsvp.all 
  end
  
end
