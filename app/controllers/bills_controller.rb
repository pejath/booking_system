class BillsController < ApplicationController
  before_action :set_bill, only: [:show]
  before_action :authenticate_user!, only: :create
  # GET /bill/1 or /bill/1.json
  def show; end

  # POST /bills or /bills.json
  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to bill_path(@bill), notice: 'Bill was successfully created.' }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_bill
    @bill = Bill.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bill_params
    params.require(:bill).permit(:request_id, :apartment_id, :status)
  end
end

