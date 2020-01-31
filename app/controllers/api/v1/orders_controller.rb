class Api::V1::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy, :ship_order]

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
  end

  # GET /orders/1
  # def show
  #   render json: @order
  # end

  # GET /orders/:school_id
  def show_by_school_id
    school = School.find_by_id(params[:school_id])
    if school.present? && school.status == 1
      orders = school.orders
      render json: orders
    else
      payload = {error: "School does not exist", status: 400}, 400
      render :json => payload, :status => :bad_request
    end
  end

  # POST /orders
  def create
    school = School.find_by_id(order_params[:school_id])
    if school.present? && school.status == 1
      #Get recipients by School and status
      recipients = school.recipients.where(id: params[:recipients], status: 1)
      #Validates that the number of recipients is no more than 20
      if recipients.count <= 20
        #Validate if query returned recipients
        if !recipients.empty?
          gifts = Gift.where(id: params[:gifts], active: 1)
          if !gifts.empty?
            todays_orders = school.orders.ORDER_SHIPPED.where(updated_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
            todays_gifts = 0
            todays_orders.each do |order|
              todays_gifts += order.recipients.count * order.gifts.count
              break if todays_gifts > 60
            end

            current_order = recipients.count * gifts.count
            if (current_order + todays_gifts <=60)
              @order = Order.new(order_params.except(:status))
              @order.status=1
              @order.recipients = recipients
              @order.gifts = gifts
              if @order.save
                render json: @order, status: :created, api_v1_order_url: @order
              else
                render json: @order.errors, status: :unprocessable_entity
              end
            else
              payload = {error: "You have reached the limit of 60 gifts sent today. Please try again tomorrow.", status: 400}, 400
              render :json => payload, :status => :bad_request
            end
          else
            payload = {error: "At least one valid gift should be added to the order for it to be created", status: 400}, 400
            render :json => payload, :status => :bad_request
          end
        else
          payload = {error: "At least one valid recipients should be added to the order for it to be created", status: 400}, 400
          render :json => payload, :status => :bad_request
        end
      else
        payload = {error: "You can only create an order for 20 recipients", status: 400}, 400
        render :json => payload, :status => :bad_request
      end
    else
      payload = {error: "School cannot be found or has been deleted", status: 400}, 400
      render :json => payload, :status => :bad_request
    end
  end

  # PATCH/PUT /orders/1
  def update
    if order_params[:status] != "ORDER_CANCELLED"
      if !@order.ORDER_SHIPPED?
        if params.has_key?(:recipients) && !params[:recipients].nil? && !params[:recipients].empty?
          recipients = Recipient.where(id: params[:recipients], status: 1, school_id: @order.school_id)
          #Validate if query returned recipients
          if !recipients.empty?
            @order.recipients.destroy
            @order.recipients = recipients
          end
        end
        if params.has_key?(:gifts) && !params[:gifts].nil? && !params[:gifts].empty?
          gifts = Gift.where(id: params[:gifts], active: 1)
          if !gifts.empty?
            @order.gifts.destroy
            @order.gifts = gifts
          end
        end
        if @order.update(order_params.except(:school_id))
          render json: @order
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      else
        payload = {error: "Order has already beem shipped, for that reason it cannot be updated", status: 400}, 400
        render :json => payload, :status => :bad_request
      end
    else
      payload = {error: "Wrong method. If you wish to cancel the order, please use the 'DELETE' method", status: 400}, 400
      render :json => payload, :status => :bad_request
    end
  end

  # PUT /orders/1/ship
  def ship_order
    if !@order.ORDER_SHIPPED?
      @order.status = "ORDER_SHIPPED"
      logger.info "Notifiation will be sent to recipients for order #{@order.id} for the school #{@order.school.name}" if @order.notification
      if @order.save
        render json: @order
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    else
      payload = {error: "Order has already beem shipped, for that reason it cannot be updated.", status: 400}, 400
      render :json => payload, :status => :bad_request
    end
  end

  # DELETE /orders/1
  def destroy
    # @order.destroy
    if !@order.ORDER_SHIPPED?
      @order.status = "ORDER_CANCELLED"
      if @order.save
        render json: @order
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    else
      payload = {error: "Order has already beem shipped, for that reason it cannot be cancelled.", status: 400}, 400
      render :json => payload, :status => :bad_request
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:school_id, :status, :notification)
    end
end
