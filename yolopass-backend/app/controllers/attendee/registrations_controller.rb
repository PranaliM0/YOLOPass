class Attendee::RegistrationsController < ApplicationController
  before_action :authenticate_user
  before_action :authorize_attendee
  before_action :set_event, only: [:create]

  def create
    unless @event
      render json: { error: "Event not found" }, status: :not_found
      return
    end

    early_bird_valid = @event.early_bird_discount.present? &&
                       @event.early_bird_deadline.present? &&
                       @event.early_bird_deadline.future?

    discount_code_param = registration_params[:discount_code]&.strip
    discount_code = DiscountCode.find_by(code: discount_code_param) if discount_code_param.present?

    if discount_code_param.present? && discount_code.nil?
      render json: { error: "Invalid discount code" }, status: :unprocessable_entity
      return
    end

    # Base price * number of participants
    base_price = @event.price || 0
    participant_count = registration_params[:number_of_participants].to_i
    total_price = base_price * participant_count

    # Apply discount (priority to early bird)
    discount_percent = if early_bird_valid
                        @event.early_bird_discount
                      elsif discount_code&.percentage?
                        discount_code.amount
                      else
                        0
                      end


    discounted_amount = (total_price * discount_percent.to_f / 100).round(2)
    final_amount = (total_price - discounted_amount).round(2)

    registration = Registration.new(
      event: @event,
      discount_code: discount_code,
      payment_method: registration_params[:payment_method],
      number_of_participants: participant_count,
      amount_paid: final_amount,
      registered_at: Time.current,
      user: @current_user
    )

    participants_data = registration_params[:participants] || {}
    participants_data.each do |_, pdata|
      participant = registration.participants.new(pdata.permit(:name, :email, :phone, :id_proof_type, :uploaded_id))
      if pdata[:uploaded_id].present? && pdata[:uploaded_id] != "undefined"
        file = pdata[:uploaded_id]
        if file.respond_to?(:tempfile)
          participant.uploaded_id.attach(io: file.tempfile, filename: file.original_filename)
        end
      end
    end

    if registration.save
      render json: {
        registration_id: registration.id,
        discount_applied: discount_percent,
        amount_paid: final_amount
      }, status: :created
    else
      Rails.logger.error "Registration Save Error: #{registration.errors.full_messages.join(', ')}"
      render json: { errors: registration.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    registration = Registration.includes(:participants).find(params[:id])

    render json: {
      id: registration.id,
      event_id: registration.event_id,
      payment_method: registration.payment_method,
      number_of_participants: registration.number_of_participants,
      discount_code: registration.discount_code&.code,
      amount_paid: registration.amount_paid,
      participants: registration.participants.map do |p|
        {
          id: p.id,
          name: p.name,
          email: p.email,
          phone: p.phone,
          id_proof_type: p.id_proof_type
          # uploaded_id_url: url_for(p.uploaded_id) if p.uploaded_id.attached?
        }
      end
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Registration not found' }, status: :not_found
  end

  private

  def registration_params
    params.require(:registration).permit(
      :event_id, :discount_code, :payment_method, :number_of_participants,
      participants: [:name, :email, :phone, :id_proof_type, :uploaded_id]
    )
  end

  def set_event
    event_id = params.dig(:registration, :event_id)
    @event = Event.find_by(id: event_id)
    unless @event
      render json: { error: "Event not found" }, status: :not_found
    end
  end
end
