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
    @chapter = Chapter.create(name: params[:name], active: false, lead: params[:lead], email: params[:email], location: params[:location], intake: params[:intake], home: params[:home], donation: params[:donation], evidence: params[:evidence])
    
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
        
      #notify eable chapters team
      mail = Mail.new
      mail.to = 'eNABLE Chapters Team <enablechapters@gmail.com>'
      mail.from = 'eNABLE Matching System <enablechapters@gmail.com>'
      mail.subject = 'New Chapter Application'
      mail.body = 'Click this link to view the application.' << url_for(controller: 'chapters', action: 'review', id: @chapter.id)
        
      mail.deliver do
      end
      
      #auto-respond to applicant
      mail = Mail.new
      mail.to = @chapter.email
      mail.from = 'eNABLE Chapters Team <enablechapters@gmail.com>'
      mail.subject = 'New e-NABLE Chapter Application'
      mail.body = "<p>Thank you for contacting us about e-NABLE chapters.</p> \
        <p>If you would like to start your own chapter, please read through the attached Guide to help answer some basic questions.  Once you're ready, you can contact us at enablechapters@gmail.com to take the next steps and we'll be happy to guide you through the rest of the process.</p> \        
        <p>If you would like to help an existing chapter, you can visit our Chapters Map (http://enablingthefuture.org/e-nable-community-chapters/)  to search for a chapter in your area or one that you would like to help out.</p> \
        <p>You can find answers to many of your questions on our community Q&A site: http://enableoutreach.cloud.answerhub.com</p> \        
        <p>We host regular Google Hangout calls for our chapters.  You can learn about  our next call at http://forums.e-nable.me/viewtopic.php?f=19&t=426.  And here is a link to the past calls we've recorded: https://www.youtube.com/playlist?list=PLdY07i6W9ZUUOVDLUTsB872UJK5bqO0_m</p> \        
        <p>Don't hesitate to contact us with any questions or feedback that can help us better serve our chapters and volunteers.</p> \
        <p>Regards,</p><p>e-NABLE Chapters Team</p>"
      mail.content_type = 'text/html; charset=UTF-8'
        
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
      msg="Your e-NABLE chapters application was rejected.  The reviewer left this feedback - '#{CGI::escapeHTML(params[:message][:content])}'.  We have saved your information for future consideration.  You are welcome to update your information by clicking the link below and then contact us at <a href='mailto:enablechapters@gmail.com'>enablechapters@gmail.com</a> to discuss how to proceed. <p><a href='" << edit_chapter_url << "' target='_new'>" << edit_chapter_url << "</a>"
      
      Message.new do |m|
        m.from = params[:message][:from]
        m.to = params[:message][:to]
        m.content = msg
        m.save  
      end
      
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
      mail.content_type = 'text/html; charset=UTF-8'
      mail.body = msg
        
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
      msg = "Hi " << Member.find(@chapter.lead).first_name << \
        ",<br>Congratulations and welcome to the e-NABLE Chapters community! Below are a few comments on your test hand:" << \
        "<ul>" << params[:message][:content] << \
        "</ul><p> You've been added to the e-NABLE community <a target='_blank' href='http://enablingthefuture.org/e-nable-community-chapters/'>chapters map</a>.  You can now take advantage of these chapter benefits:</p><ul><li>Regular video calls with other chapters to keep up-to-date on the latest designs, enhancements and projects</li><li>Access to cash and in-kind grants of filament and other supplies for building devices (please visit <a href='http://www.enableoutreach.org/'>Enable Outreachs website</a> for more details)</li><li>Shipping support and discounts (order from Amazon no matter where you are located!!  Visit <a href='http://www.enableoutreach.org/'>Enable Outreachs website</a> for more details)</li><li>Access to discounts on printers, filament, shipping and more</li><li>Access to our Public Wait List so you can quickly find recipients who need a device (<a href='https://trello.com/b/oWi952BT'>https://trello.com/b/oWi952BT</a>)</li><li>Ability to add your own recipients to the Public Wait List</li></ul><p>Here are some useful links:</p><ul> \
        <li>Note that we are NOT associated with ECF and do not have any information about their operations.  <a target='_blank' href='http://enableoutreach.cloud.answerhub.com/questions/79/what-is-the-difference-between-e-nable-enabling-th.html'>http://enableoutreach.cloud.answerhub.com/questions/79/what-is-the-difference-between-e-nable-enabling-th.html </a></li><li>Link to answers for your most common questions: <a target='_blank' href='http://enableoutreach.cloud.answerhub.com'>http://enableoutreach.cloud.answerhub.com</a></li><li>Link to next chapters call: <a href='http://enableoutreach.cloud.answerhub.com/questions/35/when-is-the-next-chapters-video-call.html'>http://enableoutreach.cloud.answerhub.com/questions/35/when-is-the-next-chapters-video-call.html</a></li><li>Link to our archive of e-NABLE Chapters video calls: <a href='https://www.youtube.com/playlist?list=PLdY07i6W9ZUUOVDLUTsB872UJK5bqO0_m'>https://www.youtube.com/playlist?list=PLdY07i6W9ZUUOVDLUTsB872UJK5bqO0_m</a></li></ul><p>We are always looking for volunteers to help answer emails, setup/host video calls and other fun stuff to support our community of chapters.  Let us know if you or any of your chapter members would like to help us out.</p><p>Regards,</p><p>e-NABLE Chapters Team</p>"
      
      
      Message.new do |m|
        m.from = params[:message][:from]
        m.to = params[:message][:to]
        m.content = msg 
        m.save  
      end
      
      
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
      mail.content_type = 'text/html; charset=UTF-8'
      mail.body = msg
        
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
      mail.subject = current_member.full_name << ' requested to lead the ' << @chapter.name << ' chapter'
      mail.body = current_member.full_name << ' requested to be asssigned as the leader of the ' << @chapter.name << ' chapter in the e-NABLE Matching System (http://matching.e-nable.me).  If you agree, click this link.' << url_for(controller: 'chapters', action: 'agree', token: @tok, mem: current_member.id) << 'If you do not agree, you can ignore this email.'
        
      mail.deliver do
      end
  
      @chapter.update(token: @tok)
      
      flash[:notice] = "Your request to be assigned as leader of the " << @chapter.name << " chapter has been sent."
      redirect_to @chapter
  end
  
  def agree
    @chapter = Chapter.find_by token: params[:token]
    if @chapter && !@chapter.lead.nil?
        Message.new do |m|
          m.from = params[:mem]
          m.to = @chapter.lead
          m.content = "You were replaced by " << Member.find(params[:mem]).full_name << " as leader of " << @chapter.name
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
