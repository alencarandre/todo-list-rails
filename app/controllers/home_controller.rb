class HomeController < ApplicationController
  layout 'home'

  before_action :define_home

  def index
  end

  private

  def define_home
    redirect_to lists_mine_index_path if user_signed_in?
  end

end
