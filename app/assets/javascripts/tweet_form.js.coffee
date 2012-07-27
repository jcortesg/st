#= require charCount


$(document).ready ->
  if $('#tweet_group_tweets_attributes_0_text').size() > 0
    $('#tweet_group_tweets_attributes_0_text').charCount()
    $('#tweet_group_tweets_attributes_1_text').charCount()
    $('#tweet_group_tweets_attributes_2_text').charCount()

  if $('#tweet_text').size() > 0
    $('#tweet_text').charCount()