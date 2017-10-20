class Lists::MineController < ApplicationController
  before_action :authenticate_user!

  def index
    @list = List.new(access_type: :private)

    smart_listing_create(:lists,
          List.by_user(current_user.id).include_tasks.order_create_at_desc,
          partial: "lists/list")
  end

end
