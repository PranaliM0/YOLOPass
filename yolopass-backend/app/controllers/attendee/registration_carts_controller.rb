# frozen_string_literal: true

module Attendee
  class RegistrationCartsController < ApplicationController
    load_and_authorize_resource

    # GET /attendee/cart
    def index
      # Retrieve all pending cart items for the current user
      cart_items = @current_user.registration_carts.includes(:event).where(payment_status: 'pending')

      render json: cart_items.map { |cart|
        {
          registration_id: cart.id,
          event_id: cart.event.id,
          event_name: cart.event.name,
          amount_to_pay: cart.total_amount, # Ensure this method is defined on your cart model
          number_of_participants: cart.number_of_participants,
          discount_code: cart.discount_code.present? ? cart.discount_code : nil, # Include discount code if applicable
          participants: fetch_participants(cart), # Assuming participants are linked to registration cart
          payment_status: cart.payment_status
        }
      }
    end

    # POST /attendee/cart
    def create
      # Create a new registration cart for the current user
      cart = @current_user.registration_carts.new(cart_params)

      if cart.save
        render json: { message: 'Added to cart', cart_id: cart.id }, status: :created
      else
        render json: { error: cart.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    # Method to fetch participants for a given cart, if applicable
    def fetch_participants(cart)
      cart.registration.participants.map do |participant|
        {
          name: participant.name,
          email: participant.email,
          phone: participant.phone,
          id_proof_type: participant.id_proof_type,
          uploaded_id: participant.uploaded_id.attached? ? url_for(participant.uploaded_id) : nil # Assuming you want a URL to the uploaded ID
        }
      end
    end

    # Define the cart parameters for registration cart creation
    def cart_params
      params.require(:registration_cart).permit(:event_id, :number_of_participants, :discount_code)
    end
  end
end
