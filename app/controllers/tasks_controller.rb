class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user_list, only: [:create, :destroy, :check]

  def create
    @task = @list.tasks.build(task_params)
    @task.save
  end

  def destroy
    @task = @list.tasks.find(params[:id])
    @task.destroy
  end

  def check
    @task = @list.tasks.find(params[:task_id])
    @task.check
    @task.save
  end

  private

  def task_params
    params.require(:task).permit(:name)
  end

  def find_user_list
    @list = List.by_user(current_user.id).find(params[:list_id])
  end

end
