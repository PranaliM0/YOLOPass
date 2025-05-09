# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    load_and_authorize_resource

    def index
      users = User.all
      render json: users, each_serializer: UserSerializer
    end

    # GET /admin/event_registrations
    def event_registrations
      events = Event.includes(registrations: :user).all
      render json: events, each_serializer: EventSerializer
    end

    # GET /admin/unregistered_users
    def unregistered_users
      registered_user_ids = Registration.select(:user_id).distinct.pluck(:user_id)
      users = User.where(role: 'attendee')
                  .where.not(id: registered_user_ids)

      render json: users, each_serializer: UserSerializer
    end

    # Cannot delete admin
    def destroy
      user = User.find(params[:id])

      if user.admin?
        render json: { error: I18n.t('admin.users.destroy.success') }, status: :unprocessable_entity
      else
        user.destroy
        render json: { message: I18n.t('admin.users.destroy.cannot_delete_admin') }
      end
    end

    private

    def organizers
      organizers = User.where(role: 'organizer').includes(organizer: :events)
      render json: organizers, each_serializer: UserSerializer
    end
  end
end
