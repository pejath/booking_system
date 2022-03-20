require 'rails_helper'

RSpec.describe AdministratorsController, type: :controller do
  let!(:administrator) { create(:administrator) }

  describe '#show' do
    subject(:http_request) { get :show, params: params }

    context 'with valid params' do
      let(:params) { { id: administrator } }

      it 'returns OK' do
        expect(http_request).to have_http_status(:success)
      end

      it 'takes correct administrator' do
        http_request
        expect(assigns(:administrator)).to eq administrator
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

    it 'builds new administrator' do
      http_request
      expect(assigns(:administrator)).to be_a_new(Administrator)
    end

    it 'renders the :new template' do
      expect(http_request).to render_template :new
    end
  end

  describe '#create' do
    subject(:http_request) { post :create, params: params }

    context 'with valid attributes' do
      let(:params) { { administrator: attributes_for(:administrator) } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'creates administrator' do
        expect { http_request }.to change(Administrator, :count).by(1)
      end

      it 'redirects to administrator#show' do
        expect(http_request).to redirect_to(Administrator.last)
      end
    end

    context 'with invalid attributes' do
      let(:params) { { administrator: attributes_for(:invalid_admin) } }

      it 'returns Unprocessable Entity' do
        expect(http_request).to have_http_status(:unprocessable_entity)
      end

      it 'does not save the new administrator in the database' do
        expect { http_request }.to_not change(Administrator, :count)
      end

      it 're-renders the :new template' do
        expect(http_request).to render_template :new
      end
    end
  end

  describe '#update' do
    subject(:http_request) { patch :update, params: params }

    context 'with valid attributes' do
      let(:params) { { id: administrator, administrator: attributes_for(:administrator) } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'redirects to the updated administrator' do
        expect(http_request).to redirect_to administrator
      end

      it "changes administrator's attributes" do
        params[:administrator][:name] = 'Test'
        params[:administrator][:surname] = 'Bill'
        http_request
        administrator.reload
        expect(administrator.name).to eq('Test')
        expect(administrator.surname).to eq('Bill')
      end
    end

    context 'with invalid attributes' do
      let(:params) { { id: administrator, administrator: attributes_for(:invalid_admin) } }

      it 'returns Not Found' do
        params['id'] = -1
        expect(http_request).to have_http_status(:not_found)
      end

      it 're-renders the edit template' do
        http_request
        expect(response).to render_template :edit
      end

      it 'does not change the faculties attributes' do
        email = administrator.email
        params[:administrator][:name] = 'Test'
        params[:administrator][:email] = nil
        http_request
        administrator.reload
        expect(administrator.name).to_not eq('Test')
        expect(administrator.email).to eq(email)
      end
    end
  end

  describe '#destroy' do
    subject(:http_request) { delete :destroy, params: params }

    context 'with valid attributes' do
      let(:params) { { id: administrator } }

      it 'returns Found' do
        expect(http_request).to have_http_status(:found)
      end

      it 'deletes the administrator' do
        expect { http_request }.to change(Administrator, :count).by(-1)
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
