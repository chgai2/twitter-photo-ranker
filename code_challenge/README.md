A module to return and rank all photos, based on number of retweets or comments, from Twitter’s API and Flickr’s API.

Installation/Build/Run

1. Save code_challenge folder to desired directory (Desktop is fine for exhibition)

2. Update ruby to latest version (may need to sudo)

	brew install ruby

3. Install ruby’s Twitter gem (may need to sudo)
	
	gem install twitter

4. Install ruby’s Flickraw gem (may need to sudo)

	gem install flickraw	

5. Change directory to code_challenge directory

6. Run the code_challenge.rb file with Ruby

	ruby code_challenge.rb

7. Results will appear in a csv file named ranked_tweets_comments.csv in code_challenge directory


Explanations

In this challenge, I had to accommodate for the fact that Twitter’s API on stores hashtag search data for 7 days (https://dev.twitter.com/rest/public/search). One way around this could have been to stream data, store it and have the requested data available after a period of time. I did not think that this challenged called for that solution so initially I came up with an approximate solution around the 7 day restraint. My initial solution (output_twitter_retweets_month.rb) was to look at the users who tweeted #dctech in the last 7 days. Then assume that those users (dctechies) are responsible for the dctech hashtags in the last 7 days. After making that assumption I looked at their timelines for the past 30 days and then did analysis on their tweets that were photos with the #dctech hashtag. This module took over 80 mins to run so I contacted HR to see if I should just go with Twitter’s 7 day restriction. When code_challenge is ran it defaults to the 7 day module. It is instructions to change it to the 30 day module (which defaults to check the first 25 user’s timelines to reduce time to about 1 min). The Flickr API search is fairly simple except that their were no photos uploaded or taken wth #dctech hashtag within the last 30 days so I defaulted the search to search for a year back for analysis purposes (the module output_flickr_comments.rb has comments on how to change the dates). For simplicity, I assumed that 1 twitter retweet is equal to 1 Flickr comment.


Known Deficiencies 
- if a user tweeted a photo with the hashtag outside of the 7 day scope and within the 30 day scope their tweet is not counted.
- fetch_all_tweets doesn’t check for 30 days and it unnecessarily checks the entire timeline for some timelines
- Ruby is not my native language so I am not sure it optimized for Ruby.

Third Party Work
I used a few functions from stack exchange and GitHub and it is commented in the code.


