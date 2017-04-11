class OffersController < ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy, :accept, :decline]
  
  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = "That offer is not found"
    redirect_to root_path
  end

  def create
    @offer = Offer.new(request_id: params[:request_id], member_id: current_member.id)

    begin    
      @offer.save
      @request = Request.find(@offer.request_id)
      flash[:notice] = "Offer successfully created."
      Message.new do |m|
        m.from = @offer.member_id
        m.to = @request.member_id
        m.content = "An offer from <a href=\"#{Rails.application.routes.url_helpers.member_path @offer.member_id}\">#{Member.find(@offer.member_id).first_name}</a> was made on your <a href=\"#{Rails.application.routes.url_helpers.request_path @request.id}\">Request ##{@request.id.to_s}</a>"
        m.save  
      end 
      Message.new do |m|
        m.to = @offer.member_id
        m.from = Member.find_by(first_name: "System").id
        m.content = "You made an offer on  <a href=\"#{Rails.application.routes.url_helpers.request_path @request.id}\">Request ##{@request.id.to_s}</a>"
        m.save  
      end
      
      redirect_to @offer
      
    rescue ActiveRecord::RecordNotUnique => e
      flash[:notice] = "That is a duplicate offer."
      redirect_to :controller => 'requests', :action => 'index'
    end
  end
  
  def edit
    flash[:notice] = "You do not have permission to edit offers."
    redirect_to current_member  
  end
  
  def destroy
    @request = Request.find(@offer.request_id)
    @offer.destroy
    flash[:notice] = "Offer revoked"

    if @request.stage == "Matched"
      @request.update stage: "Open"
    end

    Message.new do |m|
      m.from = Member.find_by(first_name: "System").id
      m.to = @request.member_id
      m.content = "The offer from <a href=\"#{Rails.application.routes.url_helpers.member_path @offer.member_id}\">#{Member.find(@offer.member_id).first_name}</a> on <a href=\"#{Rails.application.routes.url_helpers.request_path @request.id}\">Request ##{@request.id.to_s}</a> was revoked"
      m.save  
    end
    Message.new do |m|
      m.to = @offer.member_id
      m.from = Member.find_by(first_name: "System").id
      m.content = "You revoked your offer on  <a href=\"#{Rails.application.routes.url_helpers.request_path @request.id}\">Request ##{@request.id.to_s}</a>"
      m.save  
    end
    
    redirect_to :controller => 'requests', :action => 'index'
  end
  
  def accept
    @offer.update stage: "Accepted"
    @request = Request.find(@offer.request_id)
    @request.update stage: "Matched"
    flash[:notice] = "Offer accepted"

    Message.new do |m|
        m.to = @offer.member_id
        m.from = @request.member_id
        m.content = "Your offer on <a href=\"#{Rails.application.routes.url_helpers.request_path @request.id}\">Request ##{@request.id.to_s}</a> was accepted (include link to WHAT NEXT doc)"
        m.save  
      end
    
    redirect_to :controller => 'requests', :action => 'index'
  end
  
  def decline
    @offer.update stage: "Declined"
    @request = Request.find(@offer.request_id)
    @request.update stage: "Open"
    flash[:notice] = "Offer declined"

    Message.new do |m|
        m.to = @offer.member_id
        m.from = @request.member_id
        m.content = "Your offer on <a href=\"#{Rails.application.routes.url_helpers.request_path @request.id}\">Request ##{@request.id.to_s}</a> was declined (include link to WHAT NEXT doc)"
        m.save  
      end
    
    redirect_to :controller => 'requests', :action => 'index'
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

end
