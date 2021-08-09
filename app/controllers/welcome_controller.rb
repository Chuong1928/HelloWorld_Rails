class WelcomeController < ApplicationController
  def index
    @friends = Friend.all
    p @friends
  end
end
