# frozen_string_literal: true

module Admin
  class OrganizersController < ApplicationController
    load_and_authorize_resource except: :destroy

    # GET /admin/organizers
    def index
      @organizers = User.where(role: :organizer)
      render json: @organizers, include: :organized_events
    end

    # DELETE /admin/organizers/:id
    def destroy
      organizer = User.find_by(id: params[:id])
      if organizer
        organizer.events.destroy_all   # delete events first
        organizer.destroy              # then delete organizer
        render json: { message: I18n.t('admin.organizers.destroy.success') }, status: :ok
      else
        render json: { error: I18n.t('admin.organizers.destroy.not_found') }, status: :not_found
      end
    end
  end
end
