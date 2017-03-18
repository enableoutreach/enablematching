class ChaptersController < ApplicationController 
  before_action :set_chapter, only: [:edit, :show, :update, :claim, :claimsend]

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
  
  def update
    if @chapter.update(name: params[:name], active: params[:active]=="true")
        redirect_to @chapter, notice: 'Chapter was successfully updated.'
    else
        render :edit
    end
  end
  
  def claimsend
    # send email

    if @chapter.lead    
      require 'mail'
      
      @tok = Digest::SHA1.hexdigest([Time.now, rand].join)
      
      options = { :address              => "smtp.gmail.com",
              :port                 => 587,
              :domain               => 'enableoutreach.org',
              :user_name            => 'enablechapters@gmail.com',
              :password             => ENV['MAIL_PASSWORD'],
              :authentication       => 'plain',
              :enable_starttls_auto => true  }
              
      Mail.defaults do
        delivery_method :smtp, options
      end
        
      mail = Mail.new
      mail.to = Member.find(@chapter.lead).first_name << " " << Member.find(@chapter.lead).last_name << "<" << @chapter.email << ">"
      mail.from = 'eNABLE Chapters Team <enablechapters@gmail.com>'
      mail.subject = current_member.first_name << ' ' << current_member.last_name << ' requested to lead the ' << @chapter.name << ' chapter'
      mail.body = 'If you agree, click this link.' << url_for(controller: 'chapters', action: 'agree', token: @tok, mem: current_member.id)
        
      mail.deliver do
      end
  
      @chapter.update(token: @tok)
      
      flash[:notice] = "Your request to be assigned as leader of the " << @chapter.name << " chapter has been sent."
      redirect_to @chapter
    else
      if @chapter.update(lead: current_member.id)
        flash[:notice] = "You have been assigned as leader of the " << @chapter.name << " chapter."
        redirect_to @chapter
      else
          render :edit
      end
   end
  end
  
  def agree
    @chapter = Chapter.find_by token: params[:token]
    if @chapter
        Message.new do |m|
          m.from = params[:mem]
          m.to = @chapter.lead
          m.content = "You were replaced by " << Member.find(params[:mem]).first_name << " " << Member.find(params[:mem]).last_name << " as leader of " << @chapter.name
          m.save  
        end
        
        @chapter.update(token: '', lead: params[:mem])
        redirect_to @chapter, notice: 'Chapter leader was successfully updated.'
    else
        redirect_to @chapter, notice: 'Chapter leader was NOT successfully updated.'
    end
  end
  
    private
    
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end
    
end
