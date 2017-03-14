class HomeController < ApplicationController
  skip_before_action :authenticate_member!
  
  def index
    @members = Member.all
  end
end
