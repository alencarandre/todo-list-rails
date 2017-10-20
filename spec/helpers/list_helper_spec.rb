require 'spec_helper'
require 'support_helper'

RSpec.describe ListHelper do
  include ListHelper
  include FontAwesome::Rails::IconHelper
  include ActionView::Helpers::UrlHelper

  let(:list) do
    list = double
    list.stub(:id).and_return(1)
    list.stub(:starred?).and_return(false)
    list
  end

  before(:each) do
    stub_chain(:current_user, :id).and_return(1)
    stub(:user_signed_in?).and_return(true)
    stub(:url_to_starred).and_return('/link/to/starred')
    stub(:url_to_droplist).and_return('/link/to/drop')
  end

  describe 'private methods' do
    context '.icon_star' do
      it "when starred should return icon fa-star" do
        icon = send(:icon_star, true)
        expect(icon.index('fa-star-o')).to be_falsy
        expect(icon.index('fa-star')).to_not be_falsy
      end

      it 'when not starred should return icon fa-star-o' do
        icon = send(:icon_star, false)
        expect(icon.index('fa-star-o')).to_not be_falsy
      end
    end


    context '.star_title' do
      it 'when starred should return title unstar_this_list' do
        expect(I18n).to receive(:t).with("helpers.list.unstar_this_list").and_return("unstar_this_list")
        send(:star_title, true)
      end

      it 'when not starred should return title star_this_list' do
        expect(I18n).to receive(:t).with("helpers.list.star_this_list").and_return("star_this_list")
        send(:star_title, false)
      end
    end

    context '.starred_set_method' do
      it "when starred shound return :delete" do
        expect(send(:starred_set_method, true)).to eq(:delete)
      end

      it "when not starred shound return :post" do
        expect(send(:starred_set_method, false)).to eq(:post)
      end
    end
  end


  describe 'public methods' do
    context '.link_starred' do
      describe 'should return nothing' do
        it 'when controller_name == mine' do
          stub(:controller_name).and_return('mine')
          expect(link_starred(list)).to be_blank
        end

        it 'when user not signed in and controller_name != mine' do
          stub(:controller_name).and_return('public')
          stub(:user_signed_in?).and_return(false)
          expect(link_starred(list)).to be_blank
        end
      end

      describe 'when controller_name != mine and user signed in' do
        before(:each) do
          stub(:star_title).and_return("title")
          stub(:starred_set_method).and_return("method")
          stub(:icon_star).and_return("icon")
        end

        it 'should return a link to unstar if list.starred? to user' do
          stub(:controller_name).and_return('public')

          # allow(subject).to receive(:link_to)
          #     .with('icon')
          #     .with('link')
          #     .with(remote: true, class: 'link-starred-list', title: 'title', method: 'method')
          #     .and_return('<a />')

          expect(link_starred(list)).to_not be_blank
        end
      end
    end

    context '.link_drop_list' do
      it 'should return nothing when controller_name != "mine"' do
        list.stub(:mine?).and_return(true)
        stub(:controller_name).and_return('public')
        expect(link_drop_list(list)).to be_blank
      end

      it "should return nothing when controller_name == 'mine' and list is not mine" do
        list.stub(:mine?).and_return(false)
        stub(:controller_name).and_return('mine')
        expect(link_drop_list(list)).to be_blank
      end

      it 'should return a link when user is logged and list is mine' do
        list.stub(:mine?).and_return(true)
        stub(:controller_name).and_return("mine")
        expect(link_drop_list(list)).to_not be_blank
      end
    end
  end
end
