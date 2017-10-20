require 'rails_helper'

feature 'ListsMine', :js do
  let(:user) { FactoryGirl.create(:user) }
  let(:my_list) { FactoryGirl.create(:list, user: user) }
  let(:task) { FactoryGirl.create(:task, list: my_list, status: :not_done) }
  let(:task_done) { FactoryGirl.create(:task, list: my_list, status: :done) }

  context 'with user signed in' do
    before(:each) do
      visit '/users/sign_in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: '123456'
      click_button 'Log in'
    end

    describe 'create' do
      scenario 'public lists' do
        visit '/lists/mine'

        within("div.new-task-list-container") do
          click_button 'New list'
        end

        within("div.new-task-list-form-container") do
          fill_in 'list_name', with: 'Public Test List'
          select 'Public', from: 'list_access_type'
          click_button 'Create'
        end

        within("div.todo-task-list") do
          expect(page).to have_content(user.name)
          expect(page).to have_content('Public Test List')
        end
      end

      scenario 'private list' do
        visit '/lists/mine'

        within("div.new-task-list-container") do
          click_button 'New list'
        end

        within("div.new-task-list-form-container") do
          fill_in 'list_name', with: 'Private Test List'
          select 'Private', from: 'list_access_type'
          click_button 'Create'
        end

        within("div.todo-task-list") do
          expect(page).to have_content(user.name)
          expect(page).to have_content('Private Test List')
          expect(page).to have_selector("i[class='fa fa-key']")
          expect(page).to_not have_selector("a.link-starred-list")
        end
      end

      scenario 'tasks' do
        my_list
        visit '/lists/mine'

        within("div.todo-task-list[data-list='#{my_list.id}']") do
          fill_in 'task_name', with: 'Task one'
          click_button 'Add'

          expect(page).to have_content('Task one')

          fill_in 'task_name', with: 'Task two'
          click_button 'Add'

          expect(page).to have_content('Task two')
        end
      end
    end

    describe 'delete' do
      scenario 'list' do
        my_list
        visit '/lists/mine'

        within("div.todo-task-list[data-list='#{my_list.id}']") do
          find('.link-drop-list').click
        end

        find('.swal2-confirm').click #sweetalert2
        expect(page).to_not have_content(my_list.name)
        expect(page).to have_content(I18n.t('lists.no_task_list_found'))
      end

      scenario 'task' do
        task
        visit '/lists/mine'

        within("div.todo-task-list[data-list='#{my_list.id}']") do
          within("li[data-task='#{task.id}']") do
            find('.link-drop-task').click
          end
        end

        find('.swal2-confirm').click #sweetalert2
        expect(page).to_not have_content(task.name)
      end
    end

    describe 'mark task as' do
      scenario 'starred' do
        task
        visit '/lists/mine'

        within("div.todo-task-list[data-list='#{my_list.id}']") do
          find("li[data-task='#{task.id}']").click
          expect(page).to have_selector("li.checked[data-task='#{task.id}']")
        end
      end

      scenario 'not starred' do
        task_done
        visit '/lists/mine'

        within("div.todo-task-list[data-list='#{my_list.id}']") do
          find("li.checked[data-task='#{task_done.id}']").click
          expect(page).to_not have_selector("li.checked[data-task='#{task_done.id}']")
          expect(page).to have_selector("li[data-task='#{task_done.id}']")
        end
      end
    end
  end

  context 'without user signed in' do
    scenario 'cannot access private list' do
      visit '/lists/mine'
      expect(page).to have_content(I18n.t("devise.failure.unauthenticated"))
    end
  end

end
