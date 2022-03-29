require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  let(:client) { create(:client)}
  let!(:client_request) { create(:request) }

  describe '#index' do
    subject(:http_request) { get :index, params: params }
    context 'with params' do
      let(:params){ {} }
      let(:requests) { create_list(:request, 100) }

      it 'returns requests filtered by status' do
        params[:status] = [1, 2]
        http_request
        expect(assigns[:requests].to_a).to eq(Request.where(status: [1, 2]))
      end

      it 'returns requests filtered by apartment_class' do
        params[:apartment_class] = [1, 2]
        http_request
        expect(assigns[:requests].to_a).to eq(Request.where(apartment_class: [1, 2]))
      end

      it 'returns requests sorted by status' do
        params[:sort_status] = nil
        http_request
        expect(assigns[:requests].to_a).to eq(Request.order(:status))
      end

      it 'returns requests sorted by apartment_class' do
        params[:sort_apartment_class] = nil
        http_request
        expect(assigns[:requests].to_a).to eq(Request.order(:apartment_class))
      end
    end

    context 'without params' do
      let(:params) { {} }
      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(http_request).to render_template :index
      end
    end
  end

  describe '#show' do
    subject(:http_request) { get :show, params: params }

    context 'with valid params' do
      let(:params) { { id: client_request } }

      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'takes correct request' do
        http_request
        expect(assigns(:request)).to eq client_request
      end

      it 'renders the :show template' do
        expect(http_request).to render_template :show
      end
    end

    context 'with invalid params' do
      let(:params) { { id: -1 } }

      it 'returns Not Found' do
        expect(http_request).to have_http_status(:not_found)
      end
    end
  end

  describe '#new' do
    subject(:http_request) { get :new }

    it 'returns OK' do
      expect(http_request).to have_http_status(:success)
    end

    it 'builds new request' do
      http_request
      expect(assigns(:request)).to be_a_new(Request)
    end

    it 'renders the :new template' do
      expect(http_request).to render_template :new
    end
  end

  describe '#edit' do
    subject(:http_request) { get :edit, params: params }

    context 'with valid params' do
      let(:params) { { id: client_request } }
      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'edits request record' do
        http_request
        expect(assigns(:request)).to eq client_request
      end

      it 'renders the :edit template' do
        expect(http_request).to render_template :edit
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
      let(:params) { { request: attributes_for(:request, client_id: create(:client), residence_time: 'P2D') } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'creates request' do
        expect { http_request }.to change(Request, :count).by(1)
      end

      it 'redirects to Requests#show' do
        expect(http_request).to redirect_to request_url(assigns[:request])
      end
    end

    context 'with invalid attributes' do
      let(:params) { { request: attributes_for(:invalid_request) } }

      it 'returns Unprocessable Entity' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end

      it 'does not save the new request in the database' do
        expect { http_request }.to_not change(Request, :count)
      end

      it 're-renders the :new template' do
        expect(http_request).to render_template :new
      end
    end
  end

  describe '#update' do
    subject(:http_request) { patch :update, params: params }

    context 'with valid attributes' do
      let(:params) { { id: client_request, request: attributes_for(:request) } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'redirects to the updated request' do
        expect(http_request).to redirect_to client_request
      end

      it "changes request's attributes" do
        params[:request][:check_in_date] = '2001-01-01'
        params[:request][:number_of_beds] = 11
        http_request
        client_request.reload
        expect(client_request.number_of_beds).to eq(11)
        expect(client_request.check_in_date).to eq('2001-01-01'.to_date)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { id: client_request, request: attributes_for(:invalid_request) } }

      it 'returns Not Found' do
        params['id'] = -1
        expect(http_request).to have_http_status(:not_found)
      end

      it 're-renders the edit template' do
        http_request
        expect(response).to render_template :edit
      end

      it 'does not change the Requests attributes' do
        request_beds = client_request.number_of_beds
        params[:request][:check_in_date] = '0001-01-01 10:00'
        params[:request][:number_of_beds] = -1
        http_request
        client_request.reload
        expect(client_request.check_in_date).to_not eq('0001-01-01 10:00'.to_date)
        expect(client_request.number_of_beds).to eq(request_beds)
      end
    end
  end

  describe '#destroy' do
    subject(:http_request) { delete :destroy, params: params }

    context 'with valid attributes' do
      let(:params) { { id: client_request } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'deletes the request' do
        expect { http_request }.to change(Request, :count).by(-1)
      end

      it 'redirects to #index' do
        expect(http_request).to redirect_to requests_url
      end
    end

    context 'with invalid id' do
      let(:params) { { id: -1 } }

      it 'returns Not Found' do
        expect(http_request).to have_http_status(:not_found)
      end
    end
  end
end
