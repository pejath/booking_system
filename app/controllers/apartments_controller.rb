class ApartmentsController < ApplicationController
  include ApartmentsHelper
  before_action :set_apartment, only: %i[ show edit update destroy ]

  # GET /apartments or apartments.json
  def index
    @apartments = filter_by_params(Apartment.all, filter_params)
    @apartments = sort_by_params(@apartments, sort_params)
  end

  # GET /apartments/1 or /apartments/1.json
  def show; end

  # GET /apartments/new
  def new
    @apartment = Apartment.new
  end

  # GET /apartments/1/edit
  def edit; end

  # POST /apartments or /apartments.json
  def create
    @apartment = Apartment.new(apartment_params)

    respond_to do |format|
      if @apartment.save
        format.html { redirect_to apartment_url(@apartment), notice: 'Apartment was successfully created.' }
        format.json { render :show, status: :created, location: @apartment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apartments/1 or /apartments/1.json
  def update
    respond_to do |format|
      if @apartment.update(apartment_params)
        format.html { redirect_to apartment_url(@apartment), notice: 'Apartment was successfully updated.' }
        format.json { render :show, status: :ok, location: @apartment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @apartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apartments/1 or /apartments/1.json
  def destroy
    respond_to do |format|
      if @apartment.destroy
        format.html { redirect_to apartments_url, notice: 'Apartment was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to apartments_url, notice: 'Something go wrong.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def filter_params
    params.fetch(:filter, {}).permit(:price_begin, :price_end, hotel: [], apartment_class: [])
  end

  def sort_params
    params.fetch(:sort, {}).permit(:price, :apartment_class)
  end

  def set_apartment
    @apartment = Apartment.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def apartment_params
    params.require(:apartment).permit(:hotel_id, :apartment_class, :room_number, :price, :image)
  end
end
