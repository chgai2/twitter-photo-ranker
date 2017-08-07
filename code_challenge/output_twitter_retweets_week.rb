
require 'twitter'
require 'csv'

class TwitterApi
	def self.initialize_twitter #module from twitter gem's documentation page
		puts "Initializing Twitter's analysis"
		client = Twitter::REST::Client.new do |config|
	  		config.consumer_key = "GTvnHEwckh5HdjVhCHrXhC5X8"
	  		config.consumer_secret = "YCEnOTJ55Kat9aySMbMnX4IbObiOntPtbEWJlEURatzA6aShLZ"
	  		config.access_token = "869602481101254657-B5lPR0aJOSL9LQps6hc3wPdUlRhM2zG"
	  		config.access_token_secret = "XJsm2As76jegYXr3JDfBA7YqGy9fhtEdquDpD1K7xzDwf"
		end
	end

	def self.count_photo_retweets
		secs_in_month = 2592000
		list_of_hahses_for_csv = []
		dctech_hashtag = initialize_twitter.search("#dctech", :include_rts => true, :result_type => "recent")
		dctech_hashtag.each do |tweet|
			tweet_time = tweet.created_at
			current_time = Time.new
			diff = current_time - tweet_time
			if secs_in_month > diff #check that tweet is within a month
				if tweet.media?
					user_data_for_csv = Hash.new #add user data into hash that will be added to list of hashes and then a csv file 
					user_data_for_csv[:user_name] = tweet.user.screen_name
					user_data_for_csv[:url] = tweet.uri.to_s
					user_data_for_csv[:num_of_retweets_comments] = tweet.retweet_count
					user_data_for_csv[:time] = tweet.created_at
					user_data_for_csv[:Flickr_Twitter] = "Twitter"
					list_of_hahses_for_csv << user_data_for_csv
				end
			else
				break
			end
		end
		puts "Twitter's analysis completed"
		list_sorted = list_of_hahses_for_csv.sort_by { |hsh| hsh[:num_of_retweets_comments] }.reverse #organize photos by number of comments, descending order
	end
end