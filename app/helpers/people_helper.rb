module PeopleHelper

  def render_network_list(title, person)
    render :partial => 'people/sidebar_network',
      :locals => { :network_title => title, :person => person }
  end

end
