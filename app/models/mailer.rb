class Mailer < ActionMailer::Base

  def message_notification(message)
    recipients  message.conversation.people.collect(&:email)
    from        '"The Usability Page <noreply@theusabilitypage.com>"'
    subject     "Re: #{message.conversation.title}"
    body        :message => message
  end

  def contact_message(from, subject, body)
  	@email = from
    recipients		'theusabilitypage@gmail.com'
    from					'"The Usability Page" <noreply@theusabilitypage.com>'
    subject				"[TUP] #{subject}"
    body					body
    content_type	"text/html"
  end
  
  def feedback_message(body)
  	recipients		'theusabilitypage@gmail.com'
  	from					'"The Usability Page" <noreply@theusabilitypage.com>'
  	subject				'[TUP] Feedback'
  	body					body
    content_type	"text/html"
  end
  
  def invite(user, initial_pwd)
  	@user = user
  	@initial_pwd = initial_pwd
  	recipients		user.email
  	from					'"The Usability Page" <noreply@theusabilitypage.com>'
  	subject				"Your The Usability Page invite"
  	body
    content_type	"text/html"
  end
  
  def password_reset_intructions(user)
  	@user = user
  	recipients		user.email
  	from					'"The Usability Page" <noreply@theusabilitypage.com>'
  	subject				'The Usability Page - Password Recovery'
  	body
  	content_type	'text/html'
  end
  
  #########################
  ## Email notifications ##
  #########################
  
  def book_published(book)
  	@book = book
  	recipients		@book.person.email
  	from					'"The Usability Page" <noreply@theusabilitypage.com>'
  	subject				'The Usability Page - Your suggested book has been published!'
  	body
  	content_type	'text/html'
  end
  
  def review_notification(review)
  	@review = review
  	recipients		@review.reviewed_object.person.email
  	from					'"The Usability Page" <noreply@theusabilitypage.com>'
  	subject				"The Usability Page - A review has been made to your #{@review.reviewed_object.class.to_s}"
  	body
  	content_type	'text/html'
  end
  
  def comment_notification(comment)
  	@comment = comment
  	recipients		@comment.review.person.email
  	from					'"The Usability Page" <noreply@theusabilitypage.com>'
  	subject				"The Usability Page - A comment has been made to one of your reviews"
  	body
  	content_type	'text/html'
  end
  
  def follower_notification(follower, followed)
  	@follower = follower  # who started following
  	@followed = followed  # who got followed
  	recipients		followed.email
  	from					'"The Usability Page" <noreply@theusabilitypage.com>'
  	subject				"The Usability Page - #{@follower.name} started following your updates"
  	body
  	content_type	'text/html'
  end
  
  def vote_notification(vote)
  	@vote = vote
  	recipients		@vote.review.person.email
  	from					'"The Usability Page" <noreply@theusabilitypage.com>'
  	subject				"The Usability Page - One of your reviews has received a vote"
  	body
  	content_type	'text/html'
  end
  
  def endorsement_notification(endorsement)
  	@endorsement = endorsement
  	recipients		@endorsement.endorsee.email
  	from					'"The Usability Page" <noreply@theusabilitypage.com>'
  	subject				"The Usability Page - You just got endorsed!"
  	body
  	content_type	'text/html'
  end

end

