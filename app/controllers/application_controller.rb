class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_member!
  
  def after_sign_in_path_for(resource)
    url_for(current_member)
  end

  def states
    render json: CS.states(params[:country]).sort_by{ |id, name| name }.to_json
  end
  
  def cities
    render json: CS.cities(params[:state]).sort_by{ |id, name| name }.to_json
  end
  
end
