require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  let!(:client) { create(:client) }

  describe '#show' do
    subject(:http_request) { get :show, params: params }

    context 'with valid params' do
      let(:params) { { id: client } }

      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'takes correct client' do
        http_request
        expect(assigns(:client)).to eq client
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

    it 'builds new client' do
      http_request
      expect(assigns(:client)).to be_a_new(Client)
    end

    it 'renders the :new template' do
      expect(http_request).to render_template :new
    end
  end

  describe '#create' do
    subject(:http_request) { post :create, params: params }

    context 'with valid attributes' do
      let(:params) { { client: attributes_for(:client) } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'creates client' do
        expect { http_request }.to change(Client, :count).by(1)
      end

      it 'redirects to client#show' do
        expect(http_request).to redirect_to(Client.last)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { client: attributes_for(:invalid_client) } }

      it 'returns Unprocessable Entity' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end

      it 'does not save the new client in the database' do
        expect { http_request }.to_not change(Client, :count)
      end

      it 're-renders the :new template' do
        expect(http_request).to render_template :new
      end
    end
  end

  describe '#update' do
    subject(:http_request) { patch :update, params: params }

    context 'with valid attributes' do
      let(:params) { { id: client, client: attributes_for(:client) } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'redirects to the updated client' do
        expect(http_request).to redirect_to client
      end

      it "changes client's attributes" do
        params[:client][:name] = 'Test'
        params[:client][:birthdate] = '2000.01.01'
        http_request
        client.reload
        expect(client.name).to eq('Test')
        expect(client.birthdate).to eq('2000.01.01'.to_date)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { id: client, client: attributes_for(:invalid_client) } }

      it 'returns Not Found' do
        params['id'] = -1
        expect(http_request).to have_http_status(:not_found)
      end

      it 're-renders the edit template' do
        http_request
        expect(response).to render_template :edit
      end

      it 'does not change the faculties attributes' do
        email = client.email
        params[:client][:name] = 'Test'
        params[:client][:email] = nil
        http_request
        client.reload
        expect(client.name).to_not eq('Test')
        expect(client.email).to eq(email)
      end
    end
  end

  describe '#destroy' do
    subject(:http_request) { delete :destroy, params: params }

    context 'with valid attributes' do
      let(:params) { { id: client } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'deletes the client' do
        expect { http_request }.to change(Client, :count).by(-1)
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
