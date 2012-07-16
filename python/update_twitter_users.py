import os
import os.path
#import twitter
import tweepy
import time

# Load YAML
from yaml import load, dump
try:
  from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
  from yaml import Loader, Dumper

# Rails Environment
if 'RAILS_ENV' in os.environ:
  RAILS_ENV = os.environ['RAILS_ENV']
else:
  RAILS_ENV = 'development'

# Path configuration
RAILS_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')

# Load the database config file
database_yml_file = os.path.join(RAILS_PATH, 'config', 'database.yml')
database_yml_content = open(database_yml_file, 'r').read()
database_config = load(database_yml_content, Loader = Loader)[RAILS_ENV]

# Twitter configuration
TWITTER_CONSUMER_KEY = 'SF8RlPZT7bUW5QI173sJdg'
TWITTER_CONSUMER_SECRET = 'JopN0OyZ7QQVpkO1DUEkQ5g8q5RlF17kHfEsU9NKo'
TWITTER_OAUTH_TOKEN = '144391600-S1sNJxqZI3NaO5zC1NtKGOGi2uWyr05vP9yjAt9k'
TWITTER_OAUTH_SECRET = '4PYb6smt0R9Izj2oFly1w9kHOBbIkpqj9mvV1KkUAPw'

# Connect to the database
import MySQLdb as mdb
import sys

start_time = time.time()

conn = None
try:
	# DB Password fix for dev
	if not database_config['password']:
		database_config['password'] = ''
	
	# Connect to the db and get a cursor
	conn = mdb.connect(database_config['host'], database_config['username'], database_config['password'], database_config['database'])
	cur_master = conn.cursor(mdb.cursors.DictCursor)
	
	# Fetch all the users
	cur_master.execute("SELECT influencers.id as influencer_id, users.twitter_uid as twitter_uid, users.twitter_token as twitter_token, users.twitter_secret as twitter_secret, influencers.first_name as first_name, influencers.last_name as last_name FROM influencers, audiences, users WHERE audiences.influencer_id = influencers.id AND influencers.user_id = users.id ORDER BY audiences.followers asc")
	rows = cur_master.fetchall()
	for row in rows:
		# For each user, first we delete all the followers relationship
		cur = conn.cursor()
		cur.execute("DELETE FROM twitter_followers WHERE twitter_user_id = " + str(row['influencer_id']))
		
		# Auth by the user with twitter
		auth = tweepy.OAuthHandler(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET)
		auth.set_access_token(row['twitter_token'], row['twitter_secret'])
		api = tweepy.API(auth)
		
		# Iterate on every follower_id
		followers_count = 0
		try:
			for follower_id in tweepy.Cursor(api.followers_ids).items():
				followers_count += 1
				# Select the twitter user with the matched twitter_uid
				cur.execute("SELECT id FROM twitter_users WHERE twitter_uid = '" + str(follower_id) + "'")
				if int(cur.rowcount > 0):
					# It exists, fetch the twitter user id
					twitter_user_id = cur.fetchone()[0]
				else:
					# It does't exist, create the record and fetch the twitter user id
					cur.execute("INSERT INTO twitter_users(twitter_uid) VALUE('" + str(follower_id) + "')")
					twitter_user_id = cur.lastrowid
					
				# Create the relationship into the db
				cur.execute("REPLACE INTO twitter_followers(influencer_id, twitter_user_id, created_at, updated_at) VALUES(" + str(row['influencer_id']) + ", " + str(twitter_user_id) + ", now(), now())")
				
			elapsed_time = time.time() - start_time
			print "Tardo %.02f segundos en updatear %d seguidores de %s %s" % (elapsed_time, followers_count, row['first_name'], row['last_name'])
		except Exception, e:
			pass

except Exception, e:
	print "Error %s" % (e)
	raise
finally:
	if conn:
		conn.close()
