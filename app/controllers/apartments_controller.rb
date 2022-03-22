class ApartmentsController < ApplicationController
  before_action :set_hotel
  before_action :set_apartment, only: %i[ show edit update destroy ]

  # GET /hotel/:id/apartments or /hotel/:id/apartments.json
  def index
    @apartments = @hotel.apartments
  end

  # GET /hotel/:id/apartments/1 or /hotel/:id/apartments/1.json
  def show; end

  # GET /hotel/:id/apartments/new
  def new
    @apartment = @hotel.apartments.build
  end

  # GET /hotel/:id/apartments/1/edit
  def edit; end

  # POST /hotel/:id/apartments or /hotel/:id/apartments.json
  def create
    @apartment = @hotel.apartments.build(apartment_params)

    respond_to do |format|
      if @apartment.save
        format.html { redirect_to hotel_apartment_url(@hotel, @apartment), notice: 'Apartment was successfully created.' }
        format.json { render :show, status: :created, location: @apartment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hotel/:id/apartments/1 or /hotel/:id/apartments/1.json
  def update
    respond_to do |format|
      if @apartment.update(apartment_params)
        format.html { redirect_to hotel_apartment_url(@hotel, @apartment), notice: 'Apartment was successfully updated.' }
        format.json { render :show, status: :ok, location: @apartment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hotel/:id/apartments/1 or /hotel/:id/apartments/1.json
  def destroy

    respond_to do |format|
      if @apartment.destroy
        format.html { redirect_to hotel_apartments_url, notice: 'Apartment was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to hotel_apartments_url, notice: 'Something go wrong.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def set_apartment
    @apartment = @hotel.apartments.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def apartment_params
    params.require(:apartment).permit(:hotel_id, :apartment_class, :room_number, :price, :image)
  end
end
