module MenuHelper
  def choose_menu
    return 'menu_logged' if user_signed_in?
    'menu'
  end
end
