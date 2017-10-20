require 'rails_helper'

feature 'ListsPublic', :js do
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

    context 'can' do
      describe 'access' do
        scenario 'my public lists' do
          my_public_list
          visit '/lists/public'
          expect(page).to have_content(my_public_list.name)
        end

        scenario 'public lists of another user' do
          another_user_public_list
          visit '/lists/public'
          expect(page).to have_content(another_user_public_list.name)
        end
      end

      scenario 'starred a public list' do
        another_user_public_list
        visit 'lists/public'

        within("div.todo-task-list[data-list='#{another_user_public_list.id}']") do
          find('.link-starred-list').click
          expect(page).to have_selector('i.fa-star')
        end
      end
    end

    context 'cannot' do
      describe 'access' do
        scenario 'my private lists' do
          my_private_list
          visit '/lists/public'
          expect(page).to_not have_content(my_private_list.name)
          expect(page).to have_content(I18n.t('lists.no_task_list_found'))
        end

        scenario 'another user private lists' do
          another_user_private_list
          visit '/lists/public'
          expect(page).to_not have_content(another_user_private_list.name)
          expect(page).to have_content(I18n.t('lists.no_task_list_found'))
        end
      end
    end
  end

  context 'without user signed in' do
    scenario 'cannot access public list' do
      my_public_list
      another_user_public_list

      visit '/lists/public'

      expect(page).to_not have_content(user.name)
      expect(page).to_not have_content(another_user.name)
      expect(page).to_not have_content(my_public_list.name)
      expect(page).to_not have_content(another_user_public_list.name)
      expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))
    end
  end
end
