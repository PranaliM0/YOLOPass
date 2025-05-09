# frozen_string_literal: true

module Attendee
  class DiscountCodesController < ApplicationController
    load_and_authorize_resource :event
    load_and_authorize_resource :discount_code, through: :event, shallow: true

    def index
      event_id = params[:event_id]

      if event_id
        discount_codes = DiscountCode.where(event_id: event_id)
        render json: { codes: discount_codes }
      else
        render json: { error: I18n.t('attendee.discount_codes.index.event_id_required') },
               status: :bad_request
      end
    end
  end
end
