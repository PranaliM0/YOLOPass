# frozen_string_literal: true

module Attendee
  class PaymentsController < ApplicationController
    load_and_authorize_resource

    def show
      @payment = Payment.find(params[:id])
    end

    def update
      @payment = Payment.find(params[:id])

      # Here you would handle actual payment gateway confirmation
      if payment_successful? # custom method
        @payment.update(status: 'completed')
        @payment.registration.update(payment_status: 'completed', registered_at: Time.current)
        redirect_to success_path, notice: 'Payment successful! Registration completed.'
      else
        @payment.update(status: 'failed')
        redirect_to failure_path, alert: 'Payment failed. Please try again.'
      end
    end

    private

    def payment_successful?
      # You can simulate success for now or check payment gateway response
      true
    end
  end
end
