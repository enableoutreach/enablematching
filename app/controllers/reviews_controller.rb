class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = "That review is not found"
    redirect_to root_path
  end
  
  rescue_from ActiveRecord::RecordNotUnique do
    flash[:notice] = "That is a duplicate review."
    redirect_to new_review_path<<"?for="<<params[:for]
  end
        
        
  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    if params[:for] && Member.find(params[:for]).valid?
      @review = Review.new  
      @review.for = params[:for]
    else
      flash[:notice] = "There was an error with your review.  Please contact the administrator for help."
      redirect_to root_path
    end
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.create(for: params[:for], by: params[:by], rating: params[:rating], title: params[:title], content: params[:content], target_type: params[:target_type])
    
    if @review.valid?  
        flash[:notice] = "Review successfully created."
        redirect_to @review
    else
      render :new
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end
end
