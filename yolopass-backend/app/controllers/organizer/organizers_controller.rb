# frozen_string_literal: true

# app/controllers/organizer/organizers_controller.rb
module Organizer
  class OrganizersController < ApplicationController
    load_and_authorize_resource class: 'User', only: :profile

    def profile
      if @current_user.role == 'organizer'
        summary = {
          total: Event.where(user_id: @current_user.id).count,
          open: Event.where(user_id: @current_user.id, status: 'Open').count,
          closed: Event.where(user_id: @current_user.id, status: 'Closed').count,
          participants: Registration.joins(:event).where(events: { user_id: @current_user.id }).count
        }

        render json: {
          organizer: {
            id: @current_user.id,
            name: @current_user.name,
            email: @current_user.email,
            role: @current_user.role
          },
          summary: summary
        }
      else
        render json: { error: I18n.t('organizer.organizers.profile.not_authorized') },
               status: :unauthorized
      end
    end
  end
end
