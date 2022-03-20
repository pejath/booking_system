require 'rails_helper'

RSpec.describe HotelsController, type: :controller do
  let!(:hotel) { create(:hotel) }

  describe '#index' do
    subject(:http_request) { get :index }

    it 'returns OK' do
      expect(http_request).to have_http_status(:success)
    end

    it 'renders the :index template' do
      expect(http_request).to render_template :index
    end
  end

  describe '#show' do
    subject(:http_request) { get :show, params: params }

    context 'with valid params' do
      let(:params) { { id: hotel } }

      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'takes correct hotel' do
        http_request
        expect(assigns(:hotel)).to eq hotel
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

    it 'builds new hotel' do
      http_request
      expect(assigns(:hotel)).to be_a_new(Hotel)
    end

    it 'renders the :new template' do
      expect(http_request).to render_template :new
    end
  end

  describe '#edit' do
    subject(:http_request) { get :edit, params: params }

    context 'with valid params' do
      let(:params) { { id: hotel } }
      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'edits hotel record' do
        http_request
        expect(assigns(:hotel)).to eq hotel
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
      let(:params) { { hotel: attributes_for(:hotel) } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'creates hotel' do
        expect { http_request }.to change(Hotel, :count).by(1)
      end

      it 'redirects to Hotels#show' do
        expect(http_request).to redirect_to hotel_path(assigns[:hotel])
      end
    end

    context 'with invalid attributes' do
      let(:params) { { hotel: attributes_for(:invalid_hotel) } }

      it 'returns Unprocessable Entity' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end

      it 'does not save the new hotel in the database' do
        expect { http_request }.to_not change(Hotel, :count)
      end

      it 're-renders the :new template' do
        expect(http_request).to render_template :new
      end
    end
  end

  describe '#update' do
    subject(:http_request) { patch :update, params: params }

    context 'with valid attributes' do
      let(:params) { { id: hotel, hotel: attributes_for(:hotel) } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'redirects to the updated hotel' do
        expect(http_request).to redirect_to hotel
      end

      it "changes hotel's attributes" do
        params[:hotel][:name] = 'Best'
        params[:hotel][:rating] = '5'
        http_request
        hotel.reload
        expect(hotel.name).to eq('Best')
        expect(hotel.rating).to eq(5)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { id: hotel, hotel: attributes_for(:invalid_hotel) } }

      it 'returns Not Found' do
        params['id'] = -1
        expect(http_request).to have_http_status(:not_found)
      end

      it 're-renders the edit template' do
        http_request
        expect(response).to render_template :edit
      end

      it 'does not change the Hotels attributes' do
        hotel_name = hotel.name
        params[:hotel][:name] = 'Test'
        params[:hotel][:rating] = -1
        http_request
        hotel.reload
        expect(hotel.name).to_not eq('Test')
        expect(hotel.name).to eq(hotel_name)
      end
    end
  end

  describe '#destroy' do
    subject(:http_request) { delete :destroy, params: params }

    context 'with valid attributes' do
      let(:params) { { id: hotel } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'deletes the hotel' do
        expect { http_request }.to change(Hotel, :count).by(-1)
      end

      it 'redirects to #index' do
        expect(http_request).to redirect_to hotels_url
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
