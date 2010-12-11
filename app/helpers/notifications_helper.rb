module NotificationsHelper

	def message_for_notification(n, op = true)
		msg = "#{link_to n.from.name, :controller => 'people', :action => 'show', :id => n.from.id, :only_path => op }"

		# direct notifications (from -> to)
		if n.from and n.to
			# review of one of my books
			if n.book and n.review
				msg << " #{link_to 'reviewed', :controller => 'books', :action => 'show', :id => n.book_id} your #{link_to 'book', :controller => 'books', :action => 'show', :id => n.book_id}."

			# review of one of my websites
			elsif n.website and n.review
				msg << " #{link_to 'reviewed', :controller => 'websites', :action => 'show', :id => n.website_id} your #{link_to 'website', :controller => 'websites', :action => 'show', :id => n.website_id}."

			# comment on one of my reviews
			elsif n.review and n.comment
				if n.book
					msg << " #{link_to 'commented', :controller => 'books', :action => 'show', :id => n.book_id} your #{link_to 'review', :controller => 'books', :action => 'show', :id => n.book_id}"
				else
					msg << " #{link_to 'commented', :controller => 'websites', :action => 'show', :id => n.website_id} your #{link_to 'review', :controller => 'websites', :action => 'show', :id => n.website_id}"
				end

			# faved one of my books
			elsif n.favorite and n.book
				msg << " added your #{link_to 'book', :controller => 'books', :action => 'show', :id => n.book_id} to his/her #{link_to 'favorites', n.to}."

			# faved one of my websites
			elsif n.favorite and n.website
				msg << " added your #{link_to 'website', :controller => 'websites', :action => 'show', :id => n.website_id} to his/her #{link_to 'favorites', n.to}."

      # someone added a comment to an update of mine
      elsif n.notification
        msg << " commented on your update"

			# someone followed me
			else
			 msg << " is now following you."
			end

    # book review was ok!
		elsif not n.from and n.to

      if n.book
        msg = "Your #{link_to 'book', :controller => 'books', :action => 'show', :id => n.book_id} was successfully reviewed and is now available for the community."
      end

		else # ends if not n.from and n.to

			# someone I follow followed someone
			if n.other
				" is now following #{link_to n.other.name, :controller => 'people', :action => 'show', :id => n.other.id }."

			# someone I follow reviewed a book
			elsif n.book and n.review
				msg << " #{link_to 'reviewed', :controller => 'books', :action => 'show', :id => n.book_id} a #{link_to 'book', :controller => 'books', :action => 'show', :id => n.book_id}."

			# someone I follow reviewed a website
			elsif n.website and n.review
				msg << " #{link_to 'reviewed', :controller => 'websites', :action => 'show', :id => n.website_id} a #{link_to 'website', :controller => 'websites', :action => 'show', :id => n.website_id}."

			# someone I follow faved a book
			elsif n.book and n.favorite
				msg << " added a #{link_to 'book', :controller => 'books', :action => 'show', :id => n.book_id} to his/her #{link_to 'favorites', :controller => 'people', :action => 'fav_books', :id => n.from, :only_path => op }."

			# someone I follow faved a website
			elsif n.website and n.review
				msg << " added a #{link_to 'website', :controller => 'websites', :action => 'show', :id => n.website_id} to his/her #{link_to 'favorites', :controller => 'people', :action => 'fav_websites', :id => n.from, :only_path => op }."

			# someone I follow commented on a review
			elsif n.comment and n.review
				if n.book
					msg << " made a #{link_to 'comment', :controller => 'books', :action => 'show', :id => n.book_id} on a #{link_to 'review', :controller => 'books', :action => 'show', :id => n.book_id}"
				else
					msg << " made a #{link_to 'comment', :controller => 'websites', :action => 'show', :id => n.website_id} on a #{link_to 'review', :controller => 'websites', :action => 'show', :id => n.website_id}"
				end

			# someone I follow added a job proposal
			elsif n.job
				msg << " added a #{link_to 'job proposal', :controller => 'jobs', :action => 'show', :id => n.job_id, :only_path => op }."

			# someone I follow added a book
			elsif n.book
				msg << " added a #{link_to 'book', :controller => 'books', :action => 'show', :id => n.book_id}."

			# someone I follow added a website
			elsif n.website
				msg << " added a #{link_to 'website', :controller => 'websites', :action => 'show', :id => n.website_id}."
			end
		end # else, ends network notifications

		msg << " (#{distance_of_time_in_words_to_now(n.created_at)} ago)."
	end

	##
	def notification_title(n)
		if n.from and n.to
			"Personal update"
		else
			"Network update"
		end
	end

	def notification_guid(n)
	end

end

