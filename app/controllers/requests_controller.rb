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

  def new
    @request = Request.new  
  end
  
  def create
    @request = Request.create(
      device_id: params[:device][:id], 
      side: params[:side], 
      member_id: current_member.id, 
      shipping_address: params[:shipping_address],
      colors: params[:colors],
      measurements: params[:measurements],
      photos: params[:photos]
    )
    
    if @request.valid? 
      Message.new do |m|
        m.from = Member.find_by(first_name: "System").id
        m.to = @request.member_id
        m.content = "You created <a href=\"#{Rails.application.routes.url_helpers.request_path @request.id}\">Request ##{@request.id.to_s}</a>."
        m.save  
      end
      flash[:notice] = "Request successfully created."
      redirect_to @request
    else
      render :new
    end
  end

  def show
    @requests = Request.all
    @match = true
  end
  
  def edit
    if @request.member_id == current_member.id || current_member.admin?
    else
      flash[:notice] = "You are not permitted to edit this request."
      redirect_to @request
    end  
  end
  
  def mine
    @requests = Request.where(member_id: current_member.id).order('created_at DESC')
  end
  
  def update
    if @request.update(colors: params[:colors], measurements: params[:measurements], photos: params[:photos], device_id: params[:device][:id], side: params[:side], evidence: params[:evidence], shipping_address: params[:shipping_address])
        redirect_to @request, notice: 'Request was successfully updated.'
    else
        render :edit
    end
  end
  
  def complete
    if (@request.member_id == current_member.id || current_member.admin?) && @request.stage!="Completed"
    else
      flash[:notice] = "You are not permitted to mark this request as complete."
      redirect_to @request
    end 
  end

#Ruby auto-routes to this from the complete.html.erb form ; could change in routes.rb later  
def destroy 
    if params[:evidence].blank?
      @request.errors.add(:evidence, "Please provide evidence before marking this request complete.")
      render :complete
    else
      if @request.update(stage: "Completed", evidence: params[:evidence])
        @offers = Offer.where(request_id: @request.id)
        @offers.each do |off|
            if off.stage == 'Offered'
              off.update stage: 'Abandoned'
            
              Message.new do |m|
                m.from = Member.find_by(first_name: "System").id
                m.to = off.member_id
                m.content = "<a href='#{Rails.application.routes.url_helpers.member_path @request.member_id}'>#{Member.find(@request.member_id).first_name}</a> closed <a href='#{Rails.application.routes.url_helpers.request_path @request.id}'>Request ##{@request.id.to_s}</a>, so your offer was abandoned."
                m.save  
              end
            end 
            
            if off.stage == 'Accepted'
              off.update stage: 'Completed' 
           
              Message.new do |m|
                m.from = Member.find_by(first_name: "System").id
                m.to = off.member_id
                m.content = "Congratulations!  <a href='#{Rails.application.routes.url_helpers.member_path @request.member_id}'>#{Member.find(@request.member_id).first_name}</a> marked <a href='#{Rails.application.routes.url_helpers.request_path @request.id}'>Request ##{@request.id.to_s}</a> as complete.  Please click <a href='#{Rails.application.routes.url_helpers.new_review_path}?for=#{@request.member_id.to_s}'>here</a> to leave a review for #{Member.find(@request.member_id).first_name}."
                m.save  
              end
              
              Message.new do |m|
                m.from = Member.find_by(first_name: "System").id
                m.to = @request.member_id
                m.content = "You closed <a href='#{Rails.application.routes.url_helpers.request_path @request.id}'>Request ##{@request.id.to_s}</a>.  Please click <a href='#{new_review_path}?for=#{off.member_id.to_s}'>here</a> to leave a review for #{Member.find(off.member_id).first_name}."
                m.save  
              end
            end
        end
        
        flash[:notice] = "Request and associated offers closed"
        
        redirect_to requests_path
        else
          render :complete
      end
    end
end
  
private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end
end
