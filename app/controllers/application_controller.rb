class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_member!
  
  def after_sign_in_path_for(resource)
    url_for(current_member)
  end


  
end
