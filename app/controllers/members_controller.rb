class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  
  # GET /members
  # GET /members.json
  def index
    if current_member.admin?
      @members = Member.all.order('first_name ASC')
    else
      flash[:notice] = "You are not permitted to view members."
      redirect_to member_path(current_member)
    end
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @requests = Request.where(member_id: @member.id)
    @youroffers = Offer.where(member_id: @member.id)
  end
  
  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  def login

   @member = Member.find_by email: params[:member][:email] 

   if @member.nil? 
       redirect_to root_url # this should become a redirect or AJAX call so user stays on home page whole time
   else 
       redirect_to :action => "show", :id => @member.id
   end
  end

  
  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.update active: false
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.fetch(:member, {})
      params.require(:member).permit(:first_name, :last_name, :city, :country)
    end
end
