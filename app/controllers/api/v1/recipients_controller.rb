class Api::V1::RecipientsController < ApplicationController
  before_action :set_recipient, only: [:show, :update, :destroy]

  # GET /recipients
  def index
    @recipients = Recipient.all

    render json: @recipients
  end

  # GET /recipients/:school_id
  def show_by_school_id
    school = School.find_by_id(params[:school_id])
    if school.present? && school.status == 1
      recipients = school.recipients
      render json: recipients
    else
      payload = {error: "School does not exist", status: 400}, 400
      render :json => payload, :status => :bad_request
    end
  end

  #Route is deactivated
  # GET /recipients/1
  def show
    render json: @recipient
  end

  # POST /recipients
  def create
    #validate if name and address is present
    if (!recipient_params.has_key?(:name) || recipient_params[:name].nil? || recipient_params[:name].blank? || !recipient_params.has_key?(:address) || recipient_params[:address].nil? || recipient_params[:address].blank?)
      payload = {error: "School must have a Name and an Address", status: 400}, 400
      render :json => payload, :status => :bad_request
    else
      school = School.find_by_id(recipient_params[:school_id])
      if school.present? && school.status == 1
        @recipient = Recipient.new(recipient_params)
        if @recipient.save
          render json: @recipient, status: :created, api_v1_recipient_url: @recipient
        else
          render json: @recipient.errors, status: :unprocessable_entity
        end
      else
        payload = {error: "School cannot be found or has been deleted", status: 400}, 400
        render :json => payload, :status => :bad_request
      end
    end
  end

  # PATCH/PUT /recipients/1
  def update
    attributes = recipient_params.except(:status)
    #validate if name and address is present
    if (!attributes.has_key?(:name) || attributes[:name].nil? || attributes[:name].blank? || !attributes.has_key?(:address) || attributes[:address].nil? || attributes[:address].blank?)
      payload = {error: "School must have a Name and an Address", status: 400}, 400
      render :json => payload, :status => :bad_request
    else
      if @recipient.update(attributes)
        render json: @recipient
      else
        render json: @recipient.errors, status: :unprocessable_entity
      end
    end
  end

  # DELETE /recipients/1
  def destroy
    # Instead of destroying we need to do a logic deletion
    # @recipient.destroy

    #Logic deletion
    @recipient.status = 0
    if @recipient.save
      render json: @recipient
    else
      render json: @recipient.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipient
      @recipient = Recipient.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def recipient_params
      params.require(:recipient).permit(:name, :address, :phone, :school_id)
    end
end
