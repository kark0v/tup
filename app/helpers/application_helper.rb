# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  include TagsHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def section(page_section)
    content_for(:section) { page_section }
  end

  def search_form(default_value, action, element, header = true)
		render :partial => 'layouts/search', :locals => { :default_value => default_value, :action => action, :element => element, :header => header }
  end

  def report_box(element)
		render :partial => 'layouts/report', :locals => { :element => element }
  end

  def login_box(element)
		render :partial => 'layouts/login', :locals => { :element => element }
  end

  def sendmessage_box(element)
    render :partial => 'people/contact', :locals => { :element => element }
  end

end

