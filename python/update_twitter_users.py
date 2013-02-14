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
TWITTER_CONSUMER_KEY = 'Yj1qSpyzySSpDI5ty1dA'
TWITTER_CONSUMER_SECRET = '46XJ47V8ZhhladFLefR5KVWf5sPfpxzZC8kuSpsY'
TWITTER_OAUTH_TOKEN = '1133957107-yKNxj8xHXr9kE4vTwKWh9Qzexk7I3GXjty4VBQ8'
TWITTER_OAUTH_SECRET = 'UPR8I3tl1CpeVUChE0kV3F05f6do8j87FgW53xMU'

# Total update?
total_update = False
try:
	total_update = os.environ['TOTAL_UPDATE']  == '1'
except Exception, e:
	pass


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
	if total_update:
		cur_master.execute("SELECT influencers.id as influencer_id, users.twitter_uid as twitter_uid, users.twitter_token as twitter_token, users.twitter_secret as twitter_secret, influencers.first_name as first_name, influencers.last_name as last_name FROM influencers, audiences, users WHERE audiences.influencer_id = influencers.id AND influencers.user_id = users.id ORDER BY audiences.followers asc")
	else:
		cur_master.execute("select influencers.id as influencer_id from influencers left join twitter_followers on influencers.id = twitter_followers.influencer_id where twitter_followers.twitter_user_id is null")
		influencers_rows = cur_master.fetchall()
		list = []
		for influencer_row in influencers_rows:
			list.append(str(influencer_row['influencer_id']))
		if len(list) > 0:
			cur_master.execute("SELECT influencers.id as influencer_id, users.twitter_uid as twitter_uid, users.twitter_token as twitter_token, users.twitter_secret as twitter_secret, influencers.first_name as first_name, influencers.last_name as last_name FROM influencers, audiences, users WHERE audiences.influencer_id = influencers.id AND influencers.user_id = users.id AND influencers.id in (" + ",".join(list) + ") ORDER BY audiences.followers asc")
		else:
			print "All influencers updated"
	rows = cur_master.fetchall()
	for row in rows:
		start_update_timer = time.time()
		# For each user, first we delete all the followers relationship
		cur = conn.cursor()
		cur_temp = conn.cursor()
		cur_temp.execute("SELECT COUNT(*) FROM twitter_followers WHERE influencer_id = " + str(row['influencer_id']))
		if total_update:
			while cur_temp.fetchone()[0] != 0:
				print "Eliminando 10000 seguidores de %s %s" % (row['first_name'], row['last_name'])
				sys.stdout.flush()
				cur.execute("DELETE FROM twitter_followers WHERE influencer_id = " + str(row['influencer_id']) + " LIMIT 10000")
				conn.commit()
				time.sleep(1)
				cur_temp.execute("SELECT COUNT(*) FROM twitter_followers WHERE influencer_id = " + str(row['influencer_id']))
		
		# Auth by the user with twitter
		auth = tweepy.OAuthHandler(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET)
		auth.set_access_token(row['twitter_token'], row['twitter_secret'])
		api = tweepy.API(auth)
		
		# Iterate on every follower_id
		print "Insertando los seguidores de %s %s" % (row['first_name'], row['last_name'])
		sys.stdout.flush()
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
					cur_temp.execute("REPLACE INTO twitter_users(twitter_uid, created_at, updated_at) VALUE('" + str(follower_id) + "', now(), now())")
					conn.commit()
					twitter_user_id = cur.lastrowid
					
				# Create the relationship into the db
				cur_temp.execute("REPLACE INTO twitter_followers(influencer_id, twitter_user_id, created_at, updated_at) VALUES(" + str(row['influencer_id']) + ", " + str(twitter_user_id) + ", now(), now())")
				
			
			conn.commit()
			elapsed_time = time.time() - start_update_timer
			print "Tardo %d segundos en updatear %d seguidores de %s %s" % (elapsed_time, followers_count, row['first_name'], row['last_name'])
			sys.stdout.flush()			
		except Exception, e:
			print "Exception %s" % e 
			sys.stdout.flush()
			pass
			
	if total_update:
		cur_master.execute("create table temp_ids(id integer) select twitter_users.id from twitter_users left join twitter_followers on twitter_users.id = twitter_followers.twitter_user_id where twitter_followers.influencer_id is null;")
		cur_master.execute("select id from temp_ids")
		rows = cur_master.fetchall()
		for row in rows:
			cur_master.execute("DELETE FROM twitter_users WHERE id = " + str(row['id']))
		conn.commit()
		cur_master.execute("DROP TABLE temp_ids")
		conn.commit()

except Exception, e:
	print "Error %s" % (e)
	sys.stdout.flush()
	raise
finally:
	if conn:
		conn.close()

elapsed_time = time.time() - start_time
print "Tardo %d segundos en updatear todos los seguidores" % (elapsed_time)
sys.stdout.flush()
