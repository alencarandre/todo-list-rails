class Lists::StarredController < ApplicationController
  before_action :authenticate_user!
  before_action :find_list, only: [:create, :destroy]
  before_action :find_starred_list, only: [:destroy]

  def index
    smart_listing_create(:lists,
          current_user.starred_lists.include_tasks.order_create_at_desc,
          partial: "lists/list")
  end

  def create
    @list.starred_lists.find_or_create_by(user_id: current_user.id)
  end

  def destroy
    @starred_lists.delete(@starred_lists.all) if @starred_lists.any?
  end

  private

  def find_starred_list
    @starred_lists = @list.starred_lists.by_user(current_user.id)
  end

  def find_list
    @list = List.public_lists.find(params[:id])
  end

end
