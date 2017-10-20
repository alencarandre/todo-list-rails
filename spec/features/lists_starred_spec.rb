require 'rails_helper'

feature 'ListsStarred', :js do
  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }

  let(:my_public_list) { FactoryGirl.create(:list, user: user, access_type: :public) }
  let(:my_private_list) { FactoryGirl.create(:list, user: user, access_type: :private) }
  let(:another_user_public_list) { FactoryGirl.create(:list, user: another_user, access_type: :public) }
  let(:another_user_private_list) { FactoryGirl.create(:list, user: another_user, access_type: :private) }

  context 'with user signed in' do
    before(:each) do
      visit '/users/sign_in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '123456'
      click_button 'Log in'
    end

    describe 'can' do
      scenario 'access my starred lists' do
        another_user_public_list.starred_lists.by_user(user.id).create
        visit 'lists/starred'
        expect(page).to have_content(another_user.name)
        expect(page).to have_content(another_user_public_list.name)
      end
    end

    describe 'cannot' do
      scenario 'starred list of another user' do
        my_public_list.starred_lists.by_user(another_user.id).create
        visit 'lists/starred'
        expect(page).to_not have_content(user.name)
        expect(page).to_not have_content(my_public_list.name)
        expect(page).to have_content(I18n.t('lists.no_task_list_found'))
      end
    end
  end

  context 'without user signed in' do
    scenario 'cannot access starred list' do
      visit '/lists/starred'
      expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))
    end
  end
end
