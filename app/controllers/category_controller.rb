class CategoryController < ApplicationController
  before_filter  :move_to_home
  
  def show
    
  end

  private
  def move_to_home
    flash[:error] = 'Page not found!'
    redirect_to '/', :status => 302
    return false
  end
end
