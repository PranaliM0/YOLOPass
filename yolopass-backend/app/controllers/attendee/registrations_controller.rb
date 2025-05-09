# frozen_string_literal: true
module Attendee
  class RegistrationsController < ApplicationController
    #authorize! :events_grouped_by_category, :attendees
    load_and_authorize_resource only: [:show]
    before_action :set_event, only: [:create]

    def create
      #byebug
      unless @event
        render json: { error: I18n.t('attendee.registrations.create.event_not_found') },
               status: :not_found and return
      end

      early_bird_valid = @event.early_bird_discount.present? &&
                         @event.early_bird_deadline.present? &&
                         @event.early_bird_deadline.future?

      # Allow discount_code to be nil, and no error if it is missing
      discount_code_param = registration_params[:discount_code]&.strip
      discount_code = nil

      #byebug
      if discount_code_param.present?
        discount_code = DiscountCode.find_by(code: discount_code_param)
      end

      # Base price * number of participants
      base_price = @event.price || 0
      participant_count = registration_params[:number_of_participants].to_i
      total_price = base_price * participant_count

      # Apply discount (priority to early bird, otherwise apply discount code if present)
      discount_percent = if early_bird_valid
                           @event.early_bird_discount
                         elsif discount_code&.percentage?
                           discount_code.amount
                         else
                           0
                         end

      discounted_amount = (total_price * discount_percent.to_f / 100).round(2)
      final_amount = (total_price - discounted_amount).round(2)

      #byebug
      registration = Registration.new(
        event: @event,
        discount_code: discount_code,
        payment_method: registration_params[:payment_method],
        number_of_participants: participant_count,
        amount_paid: final_amount,
        registered_at: Time.current,
        user: @current_user
      )

      participants_data_hash = registration_params[:participants] || {}
      participants_array = participants_data_hash.values

      # Check if participant data size matches the number of participants
      if participants_array.size != participant_count
        render json: { error: "Mismatch in number of participants and provided data" }, status: :unprocessable_entity and return
      end

      # Add participant data to the registration
      participants_array.each do |pdata|
 
        participant = registration.participants.new(pdata.permit(:name, :email, :phone, :id_proof_type, :uploaded_id))

        # Attach uploaded ID if present
        file = pdata[:uploaded_id]
        if file.present? && file.respond_to?(:tempfile)
          participant.uploaded_id.attach(io: file.tempfile, filename: file.original_filename)
        end
      end

      # Save the registration and respond
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
            id_proof_type: p.id_proof_type,
            uploaded_id_url: p.uploaded_id.attached? ? url_for(p.uploaded_id) : nil
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
      #byebug
      event_id = params.dig(:registration, :event_id)
      @event = Event.find_by(id: event_id)
      unless @event
        render json: { error: "Event not found" }, status: :not_found and return
      end
    end
  end
end
