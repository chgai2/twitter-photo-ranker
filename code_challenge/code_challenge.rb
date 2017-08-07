require './output_flickr_comments'
require './output_twitter_retweets_week'
require './output_twitter_retweets_month'

def combine_flickr_twitter(twitter = TwitterApi) #change variable to TwitterMonthApi for 30 day analysis
	flickr_twitter_data = FlickrApi.count_photo_comments + twitter.count_photo_retweets
	list_sorted = flickr_twitter_data.sort_by { |hsh| hsh[:num_of_retweets_comments] }.reverse #organize photos by number of comments/tweets, descending order
end

def add_data_to_csv(data)
	CSV.open("ranked_tweets_comments.csv", "wb") do |csv|
		csv << data.first.keys
		data.each do |hash|
			csv << hash.values
		end
	end
end

def output_to_csv
	add_data_to_csv(combine_flickr_twitter)
	puts "Analysis file is located in current directory and labeled ranked_tweets_comments.csv"
end

output_to_csv