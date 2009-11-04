# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # TODO: Test the ApplicationHelper.
  def page_description(description)
    content_for(:page_description) { description }
  end

  def page_keyword(keyword)
    content_for(:page_keyword) { keyword }
  end

  def page_title(page_title)
    content_for(:page_title) { page_title }
  end
  
  def website_home_or_user_home?
    (controller.class == ApplicationController and controller.action_name == "index") or
      (controller.class == UsersController and controller.action_name == "home")
  end

  def website_home_title_or_user_home_title
    current_user ? "Home" : "2 Post It"
  end

  def image_tag_to_logo
    if controller.class == UsersController and controller.action_name == "home"
      image_tag "logo.png", :alt => "2 Post It", :size => "283x69", :id => "logo"
    else
      image_tag "logo.png", :alt => "2 Post It", :size => "283x69"
    end
  end
  
  def link_to_website_home_or_user_home
    link_to_unless(website_home_or_user_home?, image_tag_to_logo,
      root_path, :title => website_home_title_or_user_home_title)
  end
end