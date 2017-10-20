class ListsController < ApplicationController
  before_action :authenticate_user!

  def create
    @list = List.new(list_params)
    @list.user = current_user
    @list.save
  end

  def destroy
    @list = List.by_user(current_user.id).find(params[:id])
    @list.delete
  end

  private

  def list_params
    params.require(:list).permit(:name, :access_type)
  end
end
