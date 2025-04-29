class Organizer::DiscountCodesController < ApplicationController
  before_action :authenticate_user
  before_action :set_discount_code, only: [:show]

  def index
    if params[:event_id].present?
      @discount_codes = DiscountCode.where(event_id: params[:event_id])
      render json: @discount_codes
    else
      render json: { error: 'Event ID is missing' }, status: :bad_request
    end
  end

  def create
    @discount_code = DiscountCode.new(discount_code_params)
    @event = Event.find_by(id: params[:event_id])

    if @event.nil?
      return render json: { error: 'Event not found' }, status: :not_found
    end

    @discount_code.event = @event

    if @discount_code.save
      render json: { message: 'Discount code created successfully.' }, status: :created
    else
      render json: { errors: @discount_code.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @discount_code = DiscountCode.find_by(event_id: params[:event_id], id: params[:id])
    if @discount_code
      render json: @discount_code
    else
      render json: { error: "Discount code not found" }, status: :not_found
    end
  end

  def update
    if @discount_code.update(discount_code_params)
      render json: @discount_code, status: :ok
    else
      render json: { errors: @discount_code.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @discount_code.destroy
    head :no_content
  end

  private

  def set_discount_code
    @discount_code = DiscountCode.find_by(id: params[:id], event_id: params[:event_id])
    if @discount_code.nil?
      render json: { error: 'Discount code not found for this event.' }, status: :not_found
    end
  end

  def discount_code_params
    params.require(:discount_code).permit(:code, :discount_type, :amount, :expires_at, :max_uses, :event_id)
  end
end
