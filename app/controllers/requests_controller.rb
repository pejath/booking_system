class RequestsController < ApplicationController
  include RequestsHelper
  before_action :set_request, only: %i[ show edit update destroy ]

  # GET /requests or /requests.json
  def index
    @requests = filter_by_params(Request.all, filter_params)
    @requests = sort_by_params(@requests, sort_params)
  end

  # GET /requests/1 or /requests/1.json
  def show; end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit; end

  # POST /requests or /requests.json
  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if @request.save
        format.html { redirect_to request_url(@request), notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1 or /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to request_url(@request), notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    respond_to do |format|
      if @request.destroy
        format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to requests_url, notice: 'Something go wrong.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = Request.find(params[:id])
  end

  def filter_params
    params.fetch(:filter, {}).permit(apartment_class: [], status: [])
  end

  def sort_params
    params.fetch(:sort, {}).permit(:apartment_class, :status)
  end

    # Only allow a list of trusted parameters through.
  def request_params
    params.require(:request).permit(:client_id, :apartment_class, :number_of_beds, :eviction_date, :check_in_date, :status)
    params[:request][:status] = :pending if current_user.role != :admin
  end
end
