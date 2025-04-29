class Attendee::DiscountCodesController < ApplicationController
  def index
    # Assuming you have a DiscountCode model with an event_id
    event_id = params[:event_id]
    
    if event_id
      discount_codes = DiscountCode.where(event_id: event_id)
      render json: { codes: discount_codes }
    else
      render json: { error: "Event ID is required" }, status: :bad_request
    end
  end
end
