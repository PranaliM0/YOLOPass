# frozen_string_literal: true

module Admin
  class VenuesController < ApplicationController
    load_and_authorize_resource
    before_action :set_venue, only: %i[show update destroy]

    # GET /venues
    def index
      render json: Venue.all
    end

    # GET /venues/:id
    def show
      render json: @venue
    end

    # POST /venues
    def create
      venue = Venue.new(venue_params)
      if venue.save
        render json: venue, status: :created
      else
        render json: { errors: t('admin.venues.create.venue_not_created') },
               status: :unprocessable_entity
      end
    end

    # PATCH/PUT /venues/:id
    def update
      if @venue.update(venue_params)
        render json: @venue
      else
        render json: { errors: I18n.t('admin.venues.create.venue_not_updated') },
               status: :unprocessable_entity
      end
    end

    # DELETE /venues/:id
    def destroy
      @venue.destroy
      head :no_content
    end

    private

    def set_venue
      @venue = Venue.find(params[:id])
    end

    def venue_params
      params.require(:venue).permit(:name, :location, :capacity, :description)
    end
  end
end
