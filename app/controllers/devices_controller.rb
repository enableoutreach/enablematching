class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = "That device is not found"
    redirect_to root_path
  end

  # GET /devices
  # GET /devices.json
  def index
    if !current_member.admin?
      flash[:notice] = "You are not permitted to edit devices."
      redirect_to member_path(current_member)
    else
      @devices = Device.all
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    if !current_member.admin?
      flash[:notice] = "You are not permitted to add devices."
      redirect_to member_path(current_member)
    else
      @device = Device.new
    end
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(title: params['title'])

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(title: params['title'])
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.fetch(:device, {})
    end
end
