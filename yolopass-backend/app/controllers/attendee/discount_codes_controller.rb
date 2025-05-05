class Attendee::DiscountCodesController < ApplicationController
  def index
    event_id = params[:event_id]
    
    if event_id
      discount_codes = DiscountCode.where(event_id: event_id)
      render json: { codes: discount_codes }
    else
      render json: { error: t('attendee.discount_codes.index.event_id_required') }, status: :bad_request
    end
  end
end
