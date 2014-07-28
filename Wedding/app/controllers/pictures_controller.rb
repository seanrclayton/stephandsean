class PicturesController < ApplicationController
  def index
    @images = Dir.glob("app/assets/images/slideshow/*.jpg")  
  end
end
