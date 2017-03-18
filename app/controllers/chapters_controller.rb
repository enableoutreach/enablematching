class ChaptersController < ApplicationController 
  before_action :set_chapter, only: [:edit, :show, :update, :destroy]

  def index
    if current_member.admin?
      @chapters=Chapter.all.order('name ASC')
    else
      flash[:notice] = "You are not permitted to view chapters."
      redirect_to member_path(current_member)
    end
  end
  
  def edit
    if current_member.admin? || @chapter.lead==current_member
    else
      flash[:notice] = "You are not permitted to edit chapters."
      redirect_to member_path(current_member)
    end
  end

  def show

  end
  
  def update
    if @chapter.update(name: params[:name])
        redirect_to @chapter, notice: 'Chapter was successfully updated.'
    else
        render :edit
    end
  end
  
  
  def destroy
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
            off.update stage: "Completed"
          else
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
    
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end
    
end
