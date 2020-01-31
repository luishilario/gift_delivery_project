class Api::V1::SchoolsController < ApplicationController
  before_action :set_school, only: [:show, :update, :destroy]

  # GET /schools
  def index
    @schools = School.all

    render json: @schools
  end

  # GET /schools/1
  def show
    render json: @school
  end

  # POST /schools
  def create
    #validate if name and address is present
    if (!school_params.has_key?(:name) || school_params[:name].nil? || school_params[:name].blank? || !school_params.has_key?(:address) || school_params[:address].nil? || school_params[:address].blank?)
      payload = {error: "School cannot be added. It must have a 'name' and an 'address'", status: 400}, 400
      render :json => payload, :status => :bad_request
    else
      @school = School.new(school_params)
      if @school.save
        render json: @school, status: :created, location: api_v1_school_url(@school)
      else
        render json: @school.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /schools/1
  def update
    #Initialize attributes with update params
    attributes = school_params
    #validate if name and address is present
    if (!attributes.has_key?(:name) || attributes[:name].nil? || attributes[:name].blank? || !attributes.has_key?(:address) || attributes[:address].nil? || attributes[:address].blank?)
      #return error in case if true
      payload = {error: "School cannot be updated. It must have a 'name' and an 'address'", status: 400}, 400
      render :json => payload, :status => :bad_request
    else
      #Check if status attrinute is given
      if(attributes.has_key?(:status))
        attributes[:status] = 1
      end
      if @school.update(attributes)
        render json: @school
      else
        render json: @school.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /schools/1
  def destroy
    # Instead of destroying we need to do a logic deletion
    # @school.destroy

    #Logic deletion
    @school.status = 0
    if @school.save
      render json: @school
    else
      render json: @school.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def school_params
      params.require(:school).permit(:name, :address, :phone, :status)
    end
end
