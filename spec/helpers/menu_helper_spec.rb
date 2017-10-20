require "spec_helper"
require 'support_helper'

RSpec.describe MenuHelper do
  include MenuHelper

  context '.choose_menu' do
    it "return 'menu' if user is not logged" do
      stub(:user_signed_in?).and_return(false)
      expect(choose_menu).to eq('menu')
    end

    it "return 'menu_logged' if user is logged" do
      stub(:user_signed_in?).and_return(true)
      expect(choose_menu).to eq('menu_logged')
    end
  end

end
