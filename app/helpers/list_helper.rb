module ListHelper
  def link_starred(list)
    starred = list.starred?(current_user.try(:id))
    return unless controller_name != 'mine' && user_signed_in?
    link_to(icon_star(starred), url_to_starred(list),
        remote: true,
        class: 'link-starred-list',
        title: star_title(starred),
        method: starred_set_method(starred))
  end

  def link_drop_list(list)
    return unless list.mine?(current_user.try(:id)) && controller_name == 'mine'
    link_to(fa_icon('trash'), url_to_droplist(list),
        class: 'link-drop-list',
        remote: true,
        method: :delete,
        data: { confirm: I18n.t("lists.mine.are_you_sure")})
  end

  private

  def icon_star(starred)
    fa_icon(starred ? "star" : "star-o")
  end

  def star_title(starred)
    return I18n.t("helpers.list.unstar_this_list") if starred
    I18n.t("helpers.list.star_this_list")
  end

  def starred_set_method(starred)
    return :delete if starred
    :post
  end

  def url_to_starred(list)
    lists_starred_path(list.id)
  end

  def url_to_droplist(list)
    list_path(list)
  end

end
