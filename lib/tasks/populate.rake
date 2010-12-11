
namespace :db do
  desc "Populates the database with sample data"
  task :populate => :environment do

    Person.destroy_all

    users = YAML.load_file('assets/users.yml')

    users.each do |k, user|
      t = user.delete 'type'

      first_name = user["name"].split(" ").first.downcase.removeaccents
      if first_name == "the"
				person = Person.new user.merge('password' => "usability", 'password_confirmation' => "usability")
			else
				person = Person.new user.merge('password' => first_name, 'password_confirmation' => first_name)
			end
      person.photo = File.open(Dir["#{RAILS_ROOT}/assets/#{first_name}.*"].first)
      person.save!

      case t
        when 'member'
          person.has_role 'tup_member'
        when 'collaborator'
          person.has_role 'collaborator'
      end

    end
  end

  namespace :populate do
    desc 'Create the points'
    task :points => :environment do
      Point.destroy_all

      Point.create(:reason => 'Register', :quantity => 50)
			Point.create(:reason => 'Submit Website', :quantity => 20)
      Point.create(:reason => 'Website Removed', :quantity => -20)
			Point.create(:reason => 'Submit Book', :quantity => 10)
      Point.create(:reason => 'Book Removed', :quantity => -10)
			Point.create(:reason => 'Submit Job', :quantity => 10)
      Point.create(:reason => 'Job Removed', :quantity => -10)
			Point.create(:reason => 'Review Website', :quantity => 10)
      Point.create(:reason => 'Website Review Removed', :quantity => -10)
			Point.create(:reason => 'Review Book', :quantity => 10)
      Point.create(:reason => 'Book Review Removed', :quantity => -10)
			Point.create(:reason => 'Website Featured', :quantity => 10)
			Point.create(:reason => 'Website Unfeatured', :quantity => -10)
			Point.create(:reason => 'Book Featured', :quantity => 10)
			Point.create(:reason => 'Book Unfeatured', :quantity => -10)
			Point.create(:reason => 'Job Featured', :quantity => 10)
			Point.create(:reason => 'Job Unfeatured', :quantity => -10)
			Point.create(:reason => 'Follow', :quantity => 5)
			Point.create(:reason => 'Unfollow', :quantity => -5)
			Point.create(:reason => 'Comment Review Website', :quantity => 5)
      Point.create(:reason => 'Website Comment Review Removed', :quantity => -5)
			Point.create(:reason => 'Comment Review Book', :quantity => 5)
      Point.create(:reason => 'Book Comment Review Removed', :quantity => -5)
			Point.create(:reason => 'Vote Review', :quantity => 2)
			Point.create(:reason => 'Endorse', :quantity => 5)
			Point.create(:reason => 'Get Endorsed', :quantity => 10)
			Point.create(:reason => 'Review Voted Up', :quantity => 5)
			Point.create(:reason => 'Review Voted Down', :quantity => -5)
			Point.create(:reason => 'Review Voted Down to Up', :quantity => 10)
			Point.create(:reason => 'Review Voted Up to Down', :quantity => -10)
			Point.create(:reason => 'Complete Profile', :quantity => 20)
			Point.create(:reason => 'Rate Website', :quantity => 2)
			Point.create(:reason => 'Rate Book', :quantity => 2)

    end
  end

  namespace :populate do
    desc "Populates the database with websites"
    task :websites => :environment do

			Website.destroy_all

			Website.create(:name => 'The Usability Page',
										 :url => 'www.theusabilitypage.com',
										 :description => 'Usability Reviews and Sharing',
										 :person_id => 1,
										 :featured => 1)
			Website.create(:name => 'Readernaut',
										 :url => 'www.readernaut.com',
										 :description => 'Is everything about books',
										 :person_id => 2,
										 :featured => 0)
			Website.create(:name => 'Gmail',
										 :url => 'www.gmail.com',
										 :description => 'Is everything about emails',
										 :person_id => 2,
										 :featured => 0)
			Website.create(:name => 'Twitter',
										 :url => 'www.twitter.com',
										 :description => 'Tweet it!',
										 :person_id => 4,
										 :featured => 0)
			Website.create(:name => 'Hotmail',
										 :url => 'www.hotmail.com',
										 :description => 'Is everything about emails',
										 :person_id => 3,
										 :featured => 0)
			Website.create(:name => 'Delicious',
										 :url => 'www.delicious.com',
										 :description => 'Mark as Favorite!',
										 :person_id => 5,
										 :featured => 0)
			Website.create(:name => 'Google Reader',
										 :url => 'reader.google.com',
										 :description => 'What is new?',
										 :person_id => 1,
										 :featured => 0)
			Website.create(:name => 'Terra',
										 :url => 'www.terra.com.br',
										 :description => 'Latin America Portal',
										 :person_id => 1,
										 :featured => 0)
										 

    end
  end

  namespace :populate do
    desc "Populates the database with jobs"
    task :jobs => :environment do

			Job.destroy_all

			Job.create(:company => 'The Usability Page',
			           :company_website => 'http://www.theusabilitypage.com',
								 :role => 'Lead UX Engineer',
								 :description => 'Lead a group of 20 UX Engineers',
								 :howtoapply => 'By phone at +44 73672457274',
								 :location => 'Porto, Portugal',
                 :deadline_at => 1.month.from_now,
								 :person_id => 5,
								 :featured => 1)
			Job.create(:company => 'Readernaut',
			           :company_website => 'http://www.readernaut.com',
								 :role => 'Designer',
								 :description => 'Design Icons for Readernaut',
								 :howtoapply => 'By phone at +44 73672457274',
								 :location => 'London, United Kingdom',
                 :deadline_at => 1.month.from_now,
								 :person_id => 2,
								 :featured => 0)
			Job.create(:company => 'Gmail',
						     :company_website => 'http://www.gmail.com',
								 :role => 'Beta Tester',
								 :description => 'Is everything about testing functionalities',
								 :howtoapply => 'By phone at +44 73672457274',
								 :location => 'Mountain View, CA, United States of America',
                 :deadline_at => 1.month.from_now,
								 :person_id => 2,
								 :featured => 0)
			Job.create(:company => 'Twitter',
			           :company_website => 'http://twitter.com',
								 :role => 'Usability Researcher',
								 :description => 'Read articles and suggest usability improvements',
								 :howtoapply => 'By phone at +44 73672457274',
								 :location => 'Mountain View, CA, United States of America',
                 :deadline_at => 1.month.from_now,
								 :person_id => 3,
								 :featured => 0)

    end
  end

  namespace :populate do
    desc "Populates the database with books"
    task :books => :environment do

			Book.destroy_all

			Book.create(:title => 'Usability Engineering',
								  :author => 'Jakob Nielsen',
								  :language => 'English',
								  :publisher => 'Morgan Kaufmann',
									:publisher_website => 'http://www.amazon.com/',
								  :isbn => '978-0125184069',
									:amazon => 'http://www.amazon.com/Usability-Engineering-Interactive-Technologies-Nielsen/dp/0125184069',
								  :person_id => 8,
								  :featured => 1)
			Book.create(:title => 'Dont Make me Think',
								  :author => 'Steve Krug',
								  :language => 'English',
								  :publisher => 'Que',
									:publisher_website => 'http://www.amazon.com/',
								  :isbn => '978-0789723109',
									:amazon => 'http://www.amazon.com/Think-Common-Sense-Approach-Usability/dp/0789723107',
								  :person_id => 2,
								  :featured => 0)
			Book.create(:title => 'Designing Web Interfaces: Principles and Patterns for Rich Interactions',
								  :author => 'Bill Scott and Theresa Neil',
								  :language => 'English',
								  :publisher => 'OReilly Media, Inc.',
									:publisher_website => 'http://www.amazon.com/',
								  :isbn => '978-0596516253',
									:amazon => 'http://www.amazon.com/Designing-Web-Interfaces-Principles-Interactions/dp/0596516258',
								  :person_id => 2,
								  :featured => 0)
			Book.create(:title => 'Sketching User Experiences: Getting the Design Right and the Right Design',
								  :author => 'Bill Buxton',
								  :language => 'English',
								  :publisher => 'Morgan Kaufmann',
									:publisher_website => 'http://www.amazon.com/',
								  :isbn => '978-0123740373',
									:amazon => 'http://www.amazon.com/Sketching-User-Experiences-Interactive-Technologies/dp/0123740371',
								  :person_id => 3,
								  :featured => 0)
			Book.create(:title => 'Designing Websites',
								  :author => 'Bill Scott and Theresa Neil',
								  :language => 'English',
								  :publisher => 'OReilly Media, Inc.',
									:publisher_website => 'http://www.amazon.com/',
								  :isbn => '978-0596516253',
									:amazon => 'http://www.amazon.com/Designing-Web-Interfaces-Principles-Interactions/dp/0596516258',
								  :person_id => 4,
								  :featured => 0)
			Book.create(:title => 'Sketching User Models',
								  :author => 'Bill Buxton',
								  :language => 'English',
								  :publisher => 'Morgan Kaufmann',
									:publisher_website => 'http://www.amazon.com/',
								  :isbn => '978-0123740373',
									:amazon => 'http://www.amazon.com/Sketching-User-Experiences-Interactive-Technologies/dp/0123740371',
								  :person_id => 1,
								  :featured => 0)

    end
  end

end
