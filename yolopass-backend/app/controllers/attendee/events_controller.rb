class Attendee::EventsController < ApplicationController
  before_action :authenticate_user  # This will authenticate the user before any action
  before_action :authorize_attendee

  def show
    event = Event.find(params[:id])
    discount_codes = event.discount_codes
                           .where('expires_at > ? OR expires_at IS NULL', Time.current)
                           .order('discount_type DESC, expires_at ASC')

    # If the event has an attached image, generate a URL for it
    event_image_url = if event.image.attached?
                        url_for(event.image)
                      else
                        "https://source.unsplash.com/600x300/?event"  # Fallback image URL
                      end

    render json: {
      event: event.as_json.merge(image_url: event_image_url),  # Include image_url in the event data
      discount_codes: discount_codes.as_json
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: t('attendees.events.show.event_not_found') }, status: :not_found
  end
end
