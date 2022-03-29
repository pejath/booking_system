require 'rails_helper'

RSpec.describe BillsController, type: :controller do
  let(:hotel) { create(:hotel) }
  let(:request) { create(:request) }
  let(:apartment) { create(:apartment, hotel: hotel) }
  let!(:bill) { create(:bill, apartment: apartment, request: request)}
  describe '#show' do
    subject(:http_request) { get :show, params: params }

    context 'with valid params' do
      let(:params) { { id: bill } }

      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'renders the :show template' do
        expect(http_request).to render_template :show
      end

      it 'gets correct bill' do
        http_request
        expect(assigns(:bill)).to eq bill
      end
    end

    context 'with invalid params' do
      let(:params) { { id: -1 } }

      it 'returns Not Found' do
        expect(http_request).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    subject(:http_request) { post :create, params: params }

    context 'with valid attributes' do
      let(:params) { {  bill: attributes_for(:bill, apartment_id: apartment, request_id: request) } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'creates bill' do
        expect { http_request }.to change(Bill, :count).by(1)
      end

      it 'redirects to bill#show' do
        expect(http_request).to redirect_to bill_url(id: assigns[:bill])
      end
    end

    context 'with invalid attributes' do
      let(:params) { { bill: build(:invalid_bill).attributes } }

      it 'returns Unprocessable Entity' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end

      it 'does not save the new apartment in the database' do
        expect { http_request }.to_not change(Bill, :count)
      end

      it 're-renders the :new template' do
        expect(http_request).to render_template :new
      end
    end
  end

end
