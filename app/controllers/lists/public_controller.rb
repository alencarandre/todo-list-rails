class Lists::PublicController < ApplicationController
  before_action :authenticate_user!

  def index
    smart_listing_create(:lists,
          List.public_lists.include_tasks.order_create_at_desc,
          partial: "lists/list")
  end
end
