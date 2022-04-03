require 'rails_helper'

RSpec.describe ApartmentsController, type: :controller do
  let(:hotel) { create(:hotel) }
  let!(:apartment) { create(:apartment, hotel: hotel) }

  describe '#index' do
    subject(:http_request) { get :index, params: params }

    context 'with params' do
      describe 'filtered' do
        let!(:expensive_luxe_class_apartments) { create(:apartment, price: 1000, apartment_class: :Luxe) }
        let!(:cheap_c_class_request) { create(:apartment, price: 100, apartment_class: :C) }
        let!(:average_b_class_request) { create(:apartment, price: 500, apartment_class: :B) }
        let!(:second_average_b_class_request) { create(:apartment, price: 501, apartment_class: :B) }

        describe 'by apartment class' do
          let(:params) { { filter: { apartment_class: [2, 3] } } }

          it 'returns apartments' do
            expect(http_request).to have_http_status(:success)
            expect(assigns[:apartments].to_a).to(include(cheap_c_class_request, expensive_luxe_class_apartments))
            expect(assigns[:apartments].to_a).not_to(include(average_b_class_request, second_average_b_class_request))
          end
        end

        describe 'by price' do
          let(:params) { { filter: { price_begin: {} } } }

          it 'returns apartments with minimal low price' do
            params[:filter] = { price_begin: 101 }
            expect(http_request).to have_http_status(:success)
            expect(assigns[:apartments].to_a).to(include(expensive_luxe_class_apartments, average_b_class_request, second_average_b_class_request))
            expect(assigns[:apartments].to_a).not_to(include(cheap_c_class_request))
          end

          it 'returns apartments with maximal price' do
            params[:filter] = { price_end: 500 }
            expect(http_request).to have_http_status(:success)
            expect(assigns[:apartments].to_a).to(include(cheap_c_class_request, average_b_class_request))
            expect(assigns[:apartments].to_a).not_to(include(expensive_luxe_class_apartments, second_average_b_class_request))
          end

          it 'returns apartments with maximal and maximal price' do
            params[:filter] = { price_begin: 101, price_end: 500 }
            expect(http_request).to have_http_status(:success)
            expect(assigns[:apartments].to_a).to(include(average_b_class_request))
            expect(assigns[:apartments].to_a).not_to(include(expensive_luxe_class_apartments, cheap_c_class_request, second_average_b_class_request))
          end
        end

        describe 'by apartment_class and price' do
          let(:params) { { filter: { apartment_class: [1], price_begin: 101, price_end: 1000 } } }

          it 'returns apartments' do
            expect(http_request).to have_http_status(:success)
            expect(assigns[:apartments].to_a).to(include(average_b_class_request, second_average_b_class_request))
            expect(assigns[:apartments].to_a).not_to(include(expensive_luxe_class_apartments, cheap_c_class_request))
          end
        end
      end

      describe 'sorted' do
        let!(:some_apartments) { create_list(:apartment, 10) }

        describe 'by price' do
          let(:params) { { sort: {} } }

          it 'returns sorted requests' do
            params[:sort][:price] = 'asc'
            expect(http_request).to have_http_status(:success)
            expect(assigns[:apartments].to_a).to eq(Apartment.order(:price_cents))
          end

          it 'returns reverse sorted requests' do
            params[:sort][:price] = 'desc'
            expect(http_request).to have_http_status(:success)
            expect(assigns[:apartments].to_a).to eq(Apartment.order('price_cents desc'))
          end
        end

        describe 'by apartment_class' do
          let(:params) { { sort: {} } }

          it 'returns sorted requests' do
            params[:sort][:apartment_class] = 'asc'
            expect(http_request).to have_http_status(:success)
            expect(assigns[:apartments].to_a).to eq(Apartment.order(:apartment_class))
          end

          it 'returns reverse sorted requests' do
            params[:sort][:apartment_class] = 'desc'
            expect(http_request).to have_http_status(:success)
            expect(assigns[:apartments].to_a).to eq(Apartment.order('apartment_class desc'))
          end
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
