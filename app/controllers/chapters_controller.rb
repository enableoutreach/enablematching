class ChaptersController < ApplicationController 
  before_action :set_chapter, only: [:edit, :show, :update, :claim, :claimsend, :review, :approve, :reject]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = "That chapter is not found"
    redirect_to root_path
  end

  def new
    @chapter = Chapter.new  
  end
  
  def index
    @chapters=Chapter.all.order('name ASC')
  end
  
  def edit
    if current_member.admin? || @chapter.lead==current_member
    else
      flash[:notice] = "You are not permitted to edit chapters."
      redirect_to member_path(current_member)
    end
  end
  
  def update
    if @chapter.update(name: params[:name], lead: params[:lead], email: params[:email], location: params[:location], intake: params[:intake], home: params[:home], donation: params[:donation], active: params[:active]=="true")
        redirect_to @chapter, notice: 'Chapter was successfully updated.'
    else
        render :edit
    end
  end
  
  def create
    @chapter = Chapter.create(name: params[:name], active: false, lead: params[:lead], email: params[:email], location: params[:location], intake: params[:intake], home: params[:home], donation: params[:donation])
    
    if @chapter.valid?
      require 'mail'
        
      options = { :address          => "smtp.gmail.com",
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
      mail.to = 'eNABLE Chapters Team <enablechapters@gmail.com>'
      mail.from = 'eNABLE Matching System <enablechapters@gmail.com>'
      mail.subject = 'New Chapter Application'
      mail.body = 'Click this link to view the application.' << url_for(controller: 'chapters', action: 'review', id: @chapter.id)
        
      mail.deliver do
      end
      
      flash[:notice] = "Your chapter application has been sent."
      redirect_to chapters_path
    else
      render :new
    end
  end
  
  def review
    if current_member.admin?
    else
      flash[:notice] = "Only admins can review chapter applications."
      redirect_to chapters_path
    end  
  end
  
  def reject
    if current_member.admin?
      
      require 'mail'
        
      options = { :address          => "smtp.gmail.com",
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
      mail.to = @chapter.email
      mail.from = 'eNABLE Matching System <enablechapters@gmail.com>'
      mail.subject = 'Your Chapter Application'
      mail.body = 'Your e-NABLE chapters application was rejected.  We have saved your information for future consideration.  You are welcome to update your information below and then contact us at enablechapters@gmail.com to discuss how to proceed. ' << edit_chapter_url
        
      mail.deliver do
      end
      
      flash[:notice] = "Chapter application was rejected."
      redirect_to chapters_path      
    else
      flash[:notice] = "Only admins can review chapter applications."
      redirect_to chapters_path
    end
  end
  
  def approve
    if current_member.admin?
      @chapter.update(active: true)
      
      require 'mail'
        
      options = { :address          => "smtp.gmail.com",
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
      mail.to = @chapter.email
      mail.from = 'eNABLE Matching System <enablechapters@gmail.com>'
      mail.subject = 'Your Chapter Application'
      mail.body = 'Your e-NABLE chapters application was approved.  A bunch of info you need goes here.'
        
      mail.deliver do
      end
      
      flash[:notice] = "Chapter application was approved."
      redirect_to chapters_path      
    else
      flash[:notice] = "Only admins can review chapter applications."
      redirect_to chapters_path
    end
  end
  
  def claimsend
    # send email
  
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
      mail.to = @chapter.email
      mail.from = 'eNABLE Chapters Team <enablechapters@gmail.com>'
      mail.subject = current_member.first_name << ' ' << current_member.last_name << ' requested to lead the ' << @chapter.name << ' chapter'
      mail.body = 'If you agree, click this link.' << url_for(controller: 'chapters', action: 'agree', token: @tok, mem: current_member.id)
        
      mail.deliver do
      end
  
      @chapter.update(token: @tok)
      
      flash[:notice] = "Your request to be assigned as leader of the " << @chapter.name << " chapter has been sent."
      redirect_to @chapter
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
