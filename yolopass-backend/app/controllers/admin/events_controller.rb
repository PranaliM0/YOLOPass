# frozen_string_literal: true

module Admin
  class EventsController < ApplicationController
    load_and_authorize_resource

    # GET /admin/events
    def index
      events = Event.includes(:organizer).all
      render json: events, each_serializer: EventSerializer, status: :ok
    end

    # DELETE /admin/events/:id
    def destroy
      event = Event.find_by(id: params[:id])
      if event
        event.destroy
        render json: { message: I18n.t('admin.events.destroy.success') }, status: :ok
      else
        render json: { error: I18n.t('admin.events.destroy.not_found') }, status: :not_found
      end
    end
  end
end
