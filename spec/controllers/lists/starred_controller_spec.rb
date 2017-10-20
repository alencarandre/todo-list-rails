require "rails_helper"

# include Devise::TestHelpers

RSpec.describe Lists::StarredController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
  end

  describe '#create' do
    context 'when starred one list' do
      let(:private_list) { FactoryGirl.create(:list, access_type: :private) }
      let(:public_list) { FactoryGirl.create(:list, access_type: :public) }

      it 'gives exception if try to starred a private list' do
        expect{
          post :create, params: { id: private_list.id }, format: :js
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'gives status 200 if starred a public list' do
        post :create, params: { id: public_list.id }, format: :js
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#destroy' do
    context 'when remove starred' do
      let(:private_list) { FactoryGirl.create(:list, access_type: :private) }
      let(:public_list) { FactoryGirl.create(:list, access_type: :public) }

      it 'gives status 200 if remove star from a public list' do
        delete :destroy, params: { id: public_list.id }, format: :js
        expect(response).to have_http_status(200)
      end

      it 'gives exception if the list is private' do
        expect{
          delete :destroy, params: { id: private_list.id }, format: :js
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
