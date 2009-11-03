# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # TODO: Test the ApplicationHelper.
  def website_home_or_user_home?
    (controller.class == ApplicationController and controller.action_name == "index") or
      (controller.class == UsersController and controller.action_name == "home")
  end

  def website_home_title_or_user_home_title
    current_user ? "Home" : "2 Post It"
  end

  def link_to_website_home_or_user_home
    link_to_unless(website_home_or_user_home?, image_tag("logo.png", :alt => "2 Post It",
      :size => "283x69", :id => "logo"), root_path, :title => website_home_title_or_user_home_title)
  end
end