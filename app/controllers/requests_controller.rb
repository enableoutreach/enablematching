class RequestsController < ApplicationController 
  before_action :set_request, only: [:show, :edit, :update, :destroy, :complete]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = "That request is not found"
    redirect_to root_path
  end
  
  def index
    @requests = Request.where("stage != 'Completed'").order('created_at ASC')
    @match = true
  end

  def create
    @request = Request.new(
      device_id: params[:device][:id], 
      side: params[:side], 
      member_id: current_member.id, 
      shipping_address: params[:shipping_address]
    )

    if is_unique_request(@request)   
      @request.save
      flash[:notice] = "Request successfully created."
      redirect_to @request
    else
      flash[:notice] = "That is a duplicate request."
      redirect_to :controller => 'requests', :action => 'new'
    end
  end

  def show
    @requests = Request.all
    @match = true
  end
  
  def mine
    @requests = Request.where(member_id: current_member.id)
  end
  
  def update
    if @request.update(device_id: params[:device][:id], side: params[:side], shipping_address: params[:shipping_address])
        redirect_to @request, notice: 'Request was successfully updated.'
    else
        render :edit
    end
  end
  
  def complete
    
  end
  
  def destroy #Ruby auto-routes to this from the complete.html.erb form ; could change in routes.rb later
    @offers = Offer.where(request_id: @request.id)
    @request.update stage: "Completed"
    @request.update completed: params[:completed]
    @request.update completionnote: params[:completionnote]
    @offers.each do |off|
        if off.stage == 'Offered'
          off.update stage: "Abandoned"
        end 
        if off.stage == 'Accepted'
          if params[:completed]
            off.update stage: "Completed"          else
            off.update stage: "Incomplete"
          end
        end
        Message.new do |m|
          m.from = @request.member_id
          m.to = off.member_id
          m.content = "<a href=\"#{Rails.application.routes.url_helpers.member_path @request.member_id}\">#{Member.find(@request.member_id).first_name}</a> closed <a href=\"#{Rails.application.routes.url_helpers.request_path @request.id}\">Request ##{@request.id.to_s}</a>, so your offer was abandoned."
          m.save  
        end
    end
    
    flash[:notice] = "Request and associated offers closed"

    Message.new do |m|
      m.from = @request.member_id
      m.to = @request.member_id
      m.content = "You closed <a href=\"#{Rails.application.routes.url_helpers.request_path @request.id}\">Request ##{@request.id.to_s}</a>"
      m.save  
    end
    
    redirect_to :controller => 'requests', :action => 'index'
  end
  
  private
    def is_unique_request(new_request)
      # Thought of ways to define uniqueness, but decided to leave it up to community.  There are many valid reasons for requesting the same device, for the same person (e.g. grew out of it).  But putting time constraints could impact replacement of legitimately broken devices.
      return true
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end
    
end
