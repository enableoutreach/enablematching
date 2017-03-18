class ChaptersController < ApplicationController 
  before_action :set_chapter, only: [:edit, :show, :update]

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
    if @chapter.update(name: params[:name], active: params[:active]=="true")
        redirect_to @chapter, notice: 'Chapter was successfully updated.'
    else
        render :edit
    end
  end
  
    private
    
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end
    
end
