module WebsitesHelper

  def add_screenshot_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :screenshots, :partial => 'screenshot', :object => Screenshot.new
    end
  end

end
