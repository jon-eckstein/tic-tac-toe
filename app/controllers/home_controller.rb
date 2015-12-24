class HomeController < ApplicationController

  def index
    g = Game.new(3)
    session[:game] = g
    session[:offense] = params[:offense] == "true"
  end

end