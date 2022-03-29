require 'rails_helper'

RSpec.describe ApartmentsController, type: :controller do
  let(:hotel) { create(:hotel) }
  let!(:apartment) { create(:apartment, hotel: hotel) }

  describe '#index' do
    subject(:http_request) { get :index, params: params }

    context 'without params' do
      let(:params) { {} }

      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(http_request).to render_template :index
      end
    end

    context 'with params' do
      # let(:params) { {apartment_class: nil, price_begin: nil, price_end: nil, hotel: nil, lowest_price: nil, highest_price: nil} }
      let(:params) { {} }
      let!(:apartments) { create_list(:apartment, 10) }
      let!(:special_apartment_1) { create(:apartment, price_cents: 10) }
      let!(:special_apartment_2) { create(:apartment, price_cents: 500) }

      it 'returns apartments sorted from lowest to highest price' do
        params[:lowest_price] = nil
        http_request
        expect(assigns(:apartments)).to eq Apartment.order(:price_cents)
      end

      it 'returns apartments sorted from highest to lowest price' do
        params[:highest_price] = nil
        http_request
        expect(assigns(:apartments)).to eq Apartment.order(:price_cents).reverse_order
      end

      it 'returns apartments filtered by one apartment_class' do
        params[:apartment_class] = ['A']
        http_request
        expect(assigns(:apartments)).to eq Apartment.where(apartment_class: ['A'])
      end

      it 'returns apartments filtered by some apartment_class' do
        params[:apartment_class] = ['A', 'B']
        http_request
        expect(assigns(:apartments)).to eq Apartment.where(apartment_class: ['A', 'B'])
      end

      it 'returns apartments filtered by minimal price' do
        params[:price_begin] = 300
        http_request
        expect(assigns(:apartments)).to eq Apartment.where('price_cents>=?', 30000)
      end

      it 'returns apartments filtered by maximal price' do
        params[:price_end] = 300
        http_request
        expect(assigns(:apartments)).to eq Apartment.where('price_cents<=?', 30000)
      end

      it 'returns apartments filtered by minimal and maximal price' do
        params[:price_begin] = 100
        params[:price_end] = 600
        http_request
        expect(assigns(:apartments).to_a).to eq(Apartment.where('price_cents>=? AND price_cents<=?', 10000, 60000))
      end

      it 'returns apartments filtered by hotel' do
        hotel_id = Apartment.all.sample.hotel_id
        params[:hotel] = [hotel_id]
        http_request
        expect(assigns(:apartments).to_a).to eq Apartment.where(hotel: [hotel_id])
      end
    end

  end

  describe '#show' do
    subject(:http_request) { get :show, params: params }

    context 'with valid params' do
      let(:params) { { id: apartment } }

      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'renders the :show template' do
        expect(http_request).to render_template :show
      end

      it 'gets correct apartment' do
        http_request
        expect(assigns(:apartment)).to eq apartment
      end
    end

    context 'with invalid params' do
      let(:params) { { id: apartment } }

      it 'returns Not Found' do
        params[:id] = -1
        expect(http_request).to have_http_status(:not_found)
      end
    end
  end

  describe '#new' do
    subject(:http_request) { get :new, params: params }

    context 'with valid params' do
      let(:params) { {} }

      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'builds new apartment' do
        http_request
        expect(assigns(:apartment)).to be_a_new(Apartment)
      end

      it 'renders the :new template' do
        expect(http_request).to render_template :new
      end
    end
  end

  describe '#edit' do
    subject(:http_request) { get :edit, params: params }

    context 'with valid params' do
      let(:params) { { id: apartment} }

      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'edits apartment record' do
        http_request
        expect(assigns(:apartment)).to eq apartment
      end

      it 'renders the :edit template' do
        expect(http_request).to render_template :edit
      end
    end

    context 'with invalid id' do
      let(:params) { { id: -1 } }

      it 'returns Not Found' do
        expect(http_request).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    subject(:http_request) { post :create, params: params }

    context 'with valid attributes' do
      let(:params) { {  apartment: attributes_for(:apartment, hotel_id: hotel) } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'creates apartment' do
        expect { http_request }.to change(Apartment, :count).by(1)
      end

      it 'creates apartment' do
        expect { http_request }.to change{ hotel.reload.apartments.size }.by(1)
      end

      it 'redirects to apartments#show' do
        expect(http_request).to redirect_to apartment_url( id: assigns[:apartment])
      end
    end

    context 'with invalid attributes' do
      let(:params) { { apartment: attributes_for(:invalid_apartment) } }

      it 'returns Unprocessable Entity' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end

      it 'does not save the new apartment in the database' do
        expect { http_request }.to_not change(Apartment, :count)
      end

      it 'does not save the new apartment in the database' do
        expect { http_request }.to_not change{ hotel.reload.apartments.size }
      end

      it 're-renders the :new template' do
        expect(http_request).to render_template :new
      end
    end
  end

  describe '#update' do
    subject(:http_request) { patch :update, params: params }

    context 'with valid attributes' do
      let(:params) do
        { id: apartment, apartment: attributes_for(:apartment, hotel_id: hotel) }
      end

      it "changes apartment's attributes" do
        params[:apartment][:apartment_class] = 'A'
        params[:apartment][:price] = 999
        http_request
        apartment.reload
        expect(apartment.apartment_class).to eq('A')
        expect(apartment.hotel_id).to eq(hotel.id)
        expect(apartment.price.fractional).to eq(99900)
        expect(apartment.price.currency).to eq('USD')
      end

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'redirects to the updated apartment' do
        expect(http_request).to redirect_to apartment_url( id: assigns[:apartment])
      end
    end

    context 'with invalid attributes' do
      let(:params) do
        { id: apartment, apartment: attributes_for(:invalid_apartment) }
      end

      it 'does not change the apartments attributes' do
        apartment.update!(apartment_class: 'C')
        apartments_price = apartment.price.fractional
        params[:apartment][:apartment_class] = 'A'
        params[:apartment][:price] = -10
        http_request
        apartment.reload
        expect(apartment.apartment_class).to_not eq('A')
        expect(apartment.hotel_id).to eq(hotel.id)
        expect(apartment.price.fractional).to eq(apartments_price)
      end

      it 'returns Not Found' do
        params[:id] = -1
        expect(http_request).to have_http_status(:not_found)
      end

      it 'returns Unprocessable Entity' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end

      it 're-renders the edit template' do
        expect(http_request).to render_template :edit
      end
    end
  end

  describe '#destroy' do
    subject(:http_request) { delete :destroy, params: params }

    context 'with valid params' do
      let(:params) { { id: apartment } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'deletes the apartment' do
        expect { http_request }.to change(Apartment, :count).by(-1)
      end

      it 'deletes the apartment' do
        expect { http_request }.to change{ hotel.reload.apartments.size }.by(-1)
      end

      it 'redirects to #index' do
        expect(http_request).to redirect_to apartments_path
      end
    end

    context 'with invalid id' do
      let(:params) { { id: -1 } }

      it 'returns Not Found' do
        http_request
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
