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
    @object = Rsvp.create(:rsvper => @name, :email => @email, :number => @number, :guests => @guest_joined, :comments => @comments)
   
        if @object.errors.any?
          flash.alert = @object.errors.full_messages.join("<br/>").html_safe
          render  :action => 'index'
        else
    redirect_to thankyou_path(:name => @name)
    
    end  

    
  end
  
  def thankyou

  end
end
