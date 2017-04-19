class Members::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = "That member is not found"
    redirect_to root_path
  end

  def create
    build_resource(registration_params)
  
    if resource.save
      Message.new do |m|
        m.from = Member.find_by(first_name: "System").id
        m.to = resource.id
        m.content = "Welcome to our community!  Before you make any offers to help recipients, please complete a <a href='http://enablingthefuture.org/upper-limb-prosthetics/' target='_new'>test hand</a> and claim your <a href='https://credly.com/claim/101276' target='_new'>Credly badge</a>."
        m.save  
      end
      
      Message.new do |m|
        m.from = Member.find_by(first_name: "System").id
        m.to = resource.id
        m.content = "*e-NABLE Code of Conduct*\nThe e-NABLE community is fueled by mutual respect, support, and goodwill. For that reason, community culture is critical. So please keep the following guidelines in mind.\n* Demonstrate respect for others at all times\n* Embrace a spirit of sharing\n* Question arguments, not motives\n* Offer solutions as well as diagnoses\nIf you feel that some pattern of activity endangers community effectiveness or morale, feel free to communicate privately with the moderators. If necessary, the moderators will remove offending members or posts from the community."
        m.save  
      end
      
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        respond_with resource, :location => after_sign_up_path_for(resource)
      end
    else
      resource.clean_up_passwords
      respond_with resource
    end
  end  
 
  def edit
    @member = Member.find(params[:id])
    
    if !(current_member.admin? || @member==current_member)
      flash[:notice] = "You are not permitted to edit member profiles."
      redirect_to member_path(current_member)
    end
  end

  private

  def registration_params
    params.require(:member).permit(:email, :first_name, :last_name, 
      :city, :state, :country, :id, :password, :password_confirmation)
  end



  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :city, :state, :country, :id])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
