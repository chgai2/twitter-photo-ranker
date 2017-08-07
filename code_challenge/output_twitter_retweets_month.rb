
require 'twitter'
require 'csv'

class TwitterMonthApi
	def self.initialize_twitter #module from twitter gem's documentation page
		puts "Initializing Twitter's analysis"
		client = Twitter::REST::Client.new do |config|
	  		config.consumer_key = "GTvnHEwckh5HdjVhCHrXhC5X8"
	  		config.consumer_secret = "YCEnOTJ55Kat9aySMbMnX4IbObiOntPtbEWJlEURatzA6aShLZ"
	  		config.access_token = "869602481101254657-B5lPR0aJOSL9LQps6hc3wPdUlRhM2zG"
	  		config.access_token_secret = "XJsm2As76jegYXr3JDfBA7YqGy9fhtEdquDpD1K7xzDwf"
		end
	end

	def self.collect_with_max_id(collection=[], max_id=nil, &block) #module from github user sferik
		response = yield max_id
		collection += response
		response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
	end

	def self.fetch_all_tweets(user, client) #module from github user sferik to collect all tweets from a user's timeline
		collect_with_max_id do |max_id|
			options = {:count => 200, :include_rts => true, result_type: "recent"}
			options[:max_id] = max_id unless max_id.nil?
			client.user_timeline(user, options)
	  	end
	end

	def self.tw_username_timeline(twitter_username, client) #module adapted from github user sferik's tw_username_followers module to overcome rate limiting
	  fetch_all_tweets("#{twitter_username}", client)
	rescue Twitter::Error::TooManyRequests => error
	  p error
	  p 'tw_username_timeline ' + error.rate_limit.reset_in.to_s
	  sleep error.rate_limit.reset_in
	  retry
	end

	def self.generate_dctechies #generates list of everyone who tweeted/retweeted #dctech within last 7 days
		dctech_hashtag = initialize_twitter.search("#dctech", :include_rts => true, :result_type => "recent")
		dctechies = []
		dctech_hashtag.each do |tweet|
			dctechies << tweet.user.screen_name
		end
		puts "dctechies list has been generated"
		dctechies = dctechies.uniq #remove duplicates
	end

	def self.count_user_retweets
		secs_in_month = 2592000
		list_of_hahses_for_csv = []
		generate_dctechies.first(10).each do |user| #remove .first(10)to view analysis for entire group of users who tweeted #dctech 
			user_timeline = tw_username_timeline(user, initialize_twitter) 
			puts "generating timeline for #{user}"
			user_timeline.each do |tweet|
				tweet_time = tweet.created_at
				current_time = Time.new
				diff = current_time - tweet_time
				if secs_in_month > diff #checks if tweet is within a month
					if tweet.text.downcase.include? "#dctech"
						if tweet.media?
							user_data_for_csv = Hash.new #add user data into hash that will be added to list of hashes and then a csv file 
							user_data_for_csv[:user_name] = user
							user_data_for_csv[:url] = tweet.uri.to_s
							user_data_for_csv[:num_of_retweets_comments] = tweet.retweet_count
							user_data_for_csv[:time] = tweet.created_at
							user_data_for_csv[:Flickr_Twitter] = "Twitter"
							list_of_hahses_for_csv << user_data_for_csv
						end
					end
				else
					break
				end
			end
		end
		puts "Twitter's analysis completed"
		list_sorted = list_of_hahses_for_csv.sort_by { |hsh| hsh[:num_of_retweets_comments] }.reverse #organize photos by number of comments, descending order
	end

	def self.count_photo_retweets
		count_user_retweets
	end
end
