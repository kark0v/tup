ActionController::Routing::Routes.draw do |map|

	map.resources :password_resets, :only => [:create, :edit, :update]

  map.resources :notifications, :only => [], :member => { :comment => :post }
  map.resources :endorsements, :member => { :accept => :put, :refuse => :put }

  map.resources :books, :member => {
		:feature => :put,
		:unfeature => :put,
		:fav => :put,
		:unfav => :delete,
		:add_to_list => :put,
		:edit_list => :put,
		:remove_from_list => :delete
  }, :collection => {
 		:random => :any
	}

  map.resources :books, :shallow => true do |books|
    books.resources :ratings
    books.resources :reviews, :shallow => true  do |reviews|
      reviews.resources :comments
      reviews.resources :votes
    end
  end

  map.resources :reports, :member => {
	  :destroy => :put,
		:set_status => :put
	}
	map.resource :admin, :collection => {
	  :logs => :get,
		:suggestions => :get,
		:endorsements => :get,
		:conversations => :get,
		:books_for_review => :get,
	  :review_book => :get,
	  :publish_book => :post,
	  :reject_book => :get,
	  :rejected_books => :get,
	  :pending_invites => :get,
	  :accept_invite => :get,
	  :sent_invites => :get,
	  :resend_invite => :get
	}

  map.resources :tags

  map.resources :suggestions
	map.resources :listbookss

	map.resource :profile, :member => {
		:endorsements => :get,
		:points => :get,
		:updates => :get,
		:followers => :get,
		:following => :get,
		:blocked => :get,
		:import => :get,
		:export => :get,
		:websites_submissions => :get,
		:websites_reviews => :get,
		:websites_favs => :get,
		:jobs_submissions => :get,
		:jobs_favs => :get,
		:books_submissions => :get,
		:books_reviews => :get,
		:books_lists => :get,
		:books_favs => :get,
		:privacy => :get,
		:notifications => :get,
		:edit_settings => :put,
		:remove => :get,
		:remover => :put
	}

	map.resources :inbox, :collection => {
	  :notifications => :get,
		:suggestions => :get
	}

  #map.resources :conversations, :member => {
	#	:add => :post,
	#	:remove => :post,
	#	:reply_report => :put,
	#	:remover => :put } do |m|
  #  m.resource :message, :only => [ :create ]
  #end

  map.resources :websites, :member => {
		:feature => :put,
		:unfeature => :put,
		:fav => :post,
		:unfav => :post,
  }, :collection => {
 		:random => :any
	}

  map.resources :websites, :shallow => true do |websites|
    websites.resources :ratings
    websites.resources :reviews, :shallow => true  do |reviews|
      reviews.resources :comments
      reviews.resources :votes
    end
  end

  map.resources :reviews, :only => [ :index, :show, :destroy ]
  map.resources :comments, :only => [ :index, :show, :destroy ]

  map.resources :conversation_memberships, :only => [ :create, :destroy ]

  map.resources :jobs, :member => {
		:suggest => :post,
		:feature => :put,
		:unfeature => :put,
		:fav => :post,
		:unfav => :post,
		:open => :put,
		:close => :put
	}, :collection => {
		:rss => :get
	}

  map.resources :people, :member => {
		:block => :put,
		:unblock => :put,
		:follow => :put,
		:unfollow => :put,
		:followers => :get,
		:following => :get,
		:feature => :put,
		:unfeature => :put,
		:fav_books => :get
	}, :collection => {
 		:recruiters => :get,
		:newbies => :get,
		:get_invited => :get
	}

  map.resource :person_session, :collection => { :recover_password => :get }

  map.login     '/login',     :controller => 'person_sessions', :action => 'new'
  map.logout    '/logout',    :controller => 'person_sessions', :action => 'destroy'
  map.signup    '/signup',    :controller => 'people',          :action => 'new'
  map.lostpwd   '/recover_password', :controller => 'person_sessions', :action => 'recover_password'
	map.aboutus   '/aboutus',   :controller => 'home',            :action => 'aboutus'
	map.faq   		'/faq',   		:controller => 'home',            :action => 'faq'
	map.tou       '/tou',       :controller => 'home',            :action => 'tou'
	map.contactus '/contactus', :controller => 'home',            :action => 'contactus'
	map.sendmail  '/sendmail',  :controller => 'home',            :action => 'sendmail'
	map.feedback  '/feedback',  :controller => 'home',            :action => 'sendfeedback'
  map.rss       '/rss/:id',   :controller => 'people',          :action => 'rss'
	map.search	  '/search', 		:controller => 'home',            :action => 'search'
  map.mark_sugg_as_unseen '/inbox/mark_sugg_as_unseen/:id/', :controller => 'inbox', :action => 'mark_sugg_as_unseen'
  map.mark_sugg_as_seen '/inbox/mark_sugg_as_seen/:id/', :controller => 'inbox', :action => 'mark_sugg_as_seen'

  map.resource :account, :controller => "people"


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.root :controller => 'home'
end

