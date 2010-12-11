class String
	
	def normalize_url
		if self.match(/^(http:\/\/|ftp:\/\/|https:\/\/)/)
			self
		else
			if self.present?
				"http://#{self}"
			else
				""
			end
		end
	end
	
	def to_class
		Kernel.const_get(self.singularize.capitalize)
	end
	
end
