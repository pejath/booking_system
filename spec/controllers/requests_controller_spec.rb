require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  let(:client) { create(:client)}
  let!(:client_request) { create(:request, status: :pending, apartment_class: :B) }

  describe '#index' do
    subject(:http_request) { get :index, params: params }
    let!(:request1) { create(:request, status: :in_progress, apartment_class: :Luxe) }
    let!(:request2) { create(:request, status: :pending, apartment_class: :C) }
    let!(:request3) { create(:request, status: :approved, apartment_class: :A) }

    context 'with params' do
      describe 'filtered' do
        describe 'by status' do
          let(:params) { { filter: { status: [1, 2] } } }

          it 'returns filtered requests' do
            expect(http_request).to have_http_status(:success)
            expect(assigns[:requests].to_a).to(match_array([request1, request3]))
          end
        end

        describe 'by apartment_class' do
          let(:params) { { filter: { apartment_class: [0, 1, 3] } } }

          it 'returns filtered requests' do
            expect(http_request).to have_http_status(:success)
            expect(assigns[:requests].to_a).to(match_array([client_request, request1, request3]))
          end
        end

        describe 'by apartment_class and status' do
          let(:params) { { filter: { apartment_class: [3], status: [1] } } }

          it 'returns filtered requests' do
            expect(http_request).to have_http_status(:success)
            expect(assigns[:requests].to_a).to(match_array([request1]))
          end
        end
      end

      describe 'sorted' do
        describe 'by status' do
          let(:params) { { sort: {} } }

          it 'returns sorted requests' do
            params[:sort][:status] = 'asc'
            expect(http_request).to have_http_status(:success)
            expect(assigns[:requests].to_a).to eq([client_request, request2, request1, request3])
          end

          it 'returns reverse sorted requests' do
            params[:sort][:status] = 'desc'
            expect(http_request).to have_http_status(:success)
            expect(assigns[:requests].to_a).to eq([request3, request1, client_request, request2 ])
          end
        end

        describe 'by apartment_class' do
          let(:params) { { sort: {} } }

          it 'returns sorted requests' do
            params[:sort][:apartment_class] = 'asc'
            expect(http_request).to have_http_status(:success)
            expect(assigns[:requests].to_a).to eq([request3, client_request, request2, request1])
          end

          it 'returns reverse sorted requests' do
            params[:sort][:apartment_class] = 'desc'
            expect(http_request).to have_http_status(:success)
            expect(assigns[:requests].to_a).to eq([request1, request2, client_request, request3])
          end
        end
      end

      describe 'filter and sort combination' do
        let(:params) { { sort: {}, filter: {} } }

        it 'returns filtered and sorted requests' do
          params[:sort][:apartment_class] = 'asc'
          params[:filter][:status] = [0, 1]
          expect(http_request).to have_http_status(:success)
          expect(assigns[:requests].to_a).to eq([client_request, request2, request1])
        end

        it 'returns filtered and sorted requests' do
          params[:sort][:apartment_class] = 'desc'
          params[:filter][:status] = [0, 1]
          params[:filter][:apartment_class] = [1, 3]
          expect(http_request).to have_http_status(:success)
          expect(assigns[:requests].to_a).to eq([request1, client_request])
        end
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
