
require 'flickraw'
require 'csv'

class FlickrApi
	def self.initialize_flickraw #from flickraw's documentation page
		puts "Initializing Flickr's analysis"
		FlickRaw.api_key=""
		FlickRaw.shared_secret=""
	end

	def self.count_photo_comments(months_back = 12) #initialized month back variable to 12 in order to collect data (no dctech hashtag in last 30 days)
		initialize_flickraw

		current_time = Time.new
		secs_in_month = months_back*2592000
		month_back = (current_time - secs_in_month).to_i

		dctech_hashtag_search = flickr.photos.search(:tags => "dctech", :per_page => "500", :min_upload_date => month_back)
		list_of_hahses_for_csv = []
		dctech_hashtag_search.each do |photo|
			info = flickr.photos.getInfo(:photo_id => photo.id)
			user_data_for_csv = Hash.new #add user data into hash that will be added to list of hashes and then a csv file 
			user_data_for_csv[:user_name] = info.owner.username
			user_data_for_csv[:url] = info.urls.url[0].to_s
			user_data_for_csv[:num_of_retweets_comments] = info.comments.to_i
			user_data_for_csv[:time] = Time.parse(info.dates.taken)
			user_data_for_csv[:Flickr_Twitter] = "Flickr"
			list_of_hahses_for_csv << user_data_for_csv
		end	
		puts "Flickr's analysis completed"
		list_sorted = list_of_hahses_for_csv.sort_by { |hsh| hsh[:num_of_retweets_comments] }.reverse #organize photos by number of comments, descending order
	end
end
