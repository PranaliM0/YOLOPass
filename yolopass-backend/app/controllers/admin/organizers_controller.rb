module Admin
  class OrganizersController < ApplicationController
    before_action :authenticate_user
    before_action :authorize_admin

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
        render json: { message: t('admin.organizers.destroy.success') }, status: :ok
      else
        render json: { error: t('admin.organizers.destroy.not_found') }, status: :not_found
      end
    end    
  end
end
