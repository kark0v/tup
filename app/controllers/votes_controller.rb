class VotesController < ApplicationController

  before_filter :require_user

  def create
    vote_type = false
    review = Review.find(params[:review_id])
    
    if params[:vote] == 'true'
      vote_type = true
    end
    
    if review.voted_by_person?(current_user.id)
      vote = review.votes.find_by_person_id(current_user.id)
			old_vote = vote.vote
      vote.update_attribute(:vote, vote_type)
      vote.save
			
			if old_vote != vote.vote
				vote.update_vote_author_points
			end
    else
      vote = Vote.new(:vote => vote_type)
      vote.person = current_user
      vote.review = review
      vote.save
    end
    
    if review.website_id.nil?
      @book = Book.find(review.book_id)
    else
      @website = Website.find(review.website_id)
    end
    
    @report = Report.new
    
    render :update do |page|
      page.replace_html "votes_review#{review.id}", "Total Votes: #{review.votes.size} 
        ; Result: #{ review.votes_result } #{link_to_remote "+", :url => review_votes_url(vote.review.id, { :vote => true }), :method => :post} 
        #{link_to_remote "-", :url => review_votes_url(vote.review.id, { :vote => false }), :method => :post}
        You voted #{ review.voted_positive?(current_user.id) ? 'positive' : 'negative' }"
      page.replace_html :show_review, :partial => 'reviews/review', :collection => (@website||@book).reviews.active.sort_by { |r| r.votes_result }.reverse
      page.visual_effect :scroll_to, "review#{review.id}"
      page.visual_effect :highlight, "review#{review.id}", :duration => 3
			page.replace_html :notice, 'All right! We got you vote.'
    end
  end
end
