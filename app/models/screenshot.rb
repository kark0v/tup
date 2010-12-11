class Screenshot < ActiveRecord::Base
  belongs_to :website
  attr_accessor :should_destroy
  
  has_attached_file :photo,
  :default_url => "/images/screenshot.jpg",
  :styles => {
    :full => "350x235>",
    :thumb => "215x145#",
		:small => "150x100#"
  }
	validates_attachment_size :photo, :less_than => 2.megabytes	
	validates_attachment_content_type :photo,
		:content_type => [
			'image/jpeg',
			'image/pjpeg', # for progressive jpeg (IE mine-type for regular jpeg) 
			'image/png',
			'image/x-png', # IE mine-type for PNG
			'image/gif'
	]
  
  def should_destroy?
    should_destroy.to_i == 1
  end
  
end
