# coding: utf-8
import os
import sys
import time
import mechanize
import cookielib
from BeautifulSoup import *
import re
import logging
import thread
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy import *
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import mapper
import threading
from Queue import Queue
from datetime import datetime

logging.basicConfig()

logging.getLogger('sqlalchemy.pool').setLevel(logging.INFO)
#logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

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
database_config = load(database_yml_content, Loader=Loader)[RAILS_ENV]


# Database connection with alchemy
if not database_config['password']:
  database_config['password'] = ''
db_connection_info = "mysql://" + database_config['username'] + ':' + database_config['password'] + '@' + database_config['host'] + '/' + database_config['database']
engine = create_engine(db_connection_info, pool_size=50, max_overflow=200)
Session = scoped_session(sessionmaker(bind=engine))

Base = declarative_base()

class TwitterUser(Base):
  __tablename__ = 'twitter_users'

  id = Column(Integer, primary_key=True)
  twitter_uid = Column(String)
  twitter_screen_name = Column(String)
  name = Column(String)
  location = Column(String)
  profile_image_url = Column(String)
  followers = Column(Integer)
  friends = Column(Integer)
  tweets = Column(Integer)
  twitter_country_id = Column(Integer)
  twitter_state_id = Column(Integer)
  male = Column(Boolean)
  female = Column(Boolean)
  sports = Column(Boolean)
  fashion = Column(Boolean)
  music = Column(Boolean)
  movies = Column(Boolean)
  politics = Column(Boolean)
  technology = Column(Boolean)
  travel = Column(Boolean)
  luxury = Column(Boolean)
  created_at = Column(DateTime)
  updated_at = Column(DateTime)
  moms = Column(Boolean)
  teens = Column(Boolean)
  college_students = Column(Boolean)
  young_women = Column(Boolean)
  young_men = Column(Boolean)
  adult_women = Column(Boolean)
  adult_men = Column(Boolean)
  last_sync_at = Column(DateTime)
  invalid_page = Column(Boolean)
  private_tweets = Column(Boolean)

class Keyword(Base):
  __tablename__ = 'keywords'

  id = Column(Integer, primary_key=True)
  name = Column(String)
  keywords = Column(Text)
  created_at = Column(DateTime)
  updated_at = Column(DateTime)

start_time = time.time()

#conn = None
try:
  session = Session()

  # Query all the keywords
  record = session.query(Keyword.keywords).filter(Keyword.name == 'sports').first()
  keywords_sports = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'fashion').first()
  keywords_fashion = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'music').first()
  keywords_music = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'movies').first()
  keywords_movies = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'politics').first()
  keywords_politics = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'technology').first()
  keywords_technology = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'travel').first()
  keywords_travel = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'luxury').first()
  keywords_luxury = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'moms').first()
  keywords_moms = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'teens').first()
  keywords_teens = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'college_students').first()
  keywords_college_students = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'young_women').first()
  keywords_young_women = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'young_men').first()
  keywords_young_men = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'adult_women').first()
  keywords_adult_women = record[0]
  record = session.query(Keyword.keywords).filter(Keyword.name == 'adult_men').first()
  keywords_adult_men = record[0]

  # Compile all the regular expressions
  keywords = '|'.join(keywords_sports.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_sports = re.compile(keywords)
  keywords = '|'.join(keywords_fashion.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_fashion = re.compile(keywords)
  keywords = '|'.join(keywords_music.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_music = re.compile(keywords)
  keywords = '|'.join(keywords_movies.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_movies = re.compile(keywords)
  keywords = '|'.join(keywords_politics.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_politics = re.compile(keywords)
  keywords = '|'.join(keywords_technology.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_technology = re.compile(keywords)
  keywords = '|'.join(keywords_travel.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_travel = re.compile(keywords)
  keywords = '|'.join(keywords_luxury.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_luxury = re.compile(keywords)
  keywords = '|'.join(keywords_moms.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_moms = re.compile(keywords)
  keywords = '|'.join(keywords_teens.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_teens = re.compile(keywords)
  keywords = '|'.join(keywords_college_students.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_college_students = re.compile(keywords)
  keywords = '|'.join(keywords_young_women.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_young_women = re.compile(keywords)
  keywords = '|'.join(keywords_young_men.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_young_men = re.compile(keywords)
  keywords = '|'.join(keywords_adult_women.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_adult_women = re.compile(keywords)
  keywords = '|'.join(keywords_adult_men.split(','))
  if keywords.endswith('|'):
    keywords = keywords[:-1]
  regex_adult_men = re.compile(keywords)

  # Thread Class
  class FetchThread(threading.Thread):
    def __init__(self, queue):
      self.queue = queue
      threading.Thread.__init__(self)

    def run(self):
      self.tsession = Session()
      try:
        while True:
          #print "Items en queue: %d" % self.queue.qsize()

          twitter_user_id = self.queue.get()
          twitter_user = self.tsession.query(TwitterUser).filter(TwitterUser.id == twitter_user_id).first()

          # Mechanize setup
          cookies = cookielib.CookieJar()
          opener = mechanize.build_opener(mechanize.HTTPCookieProcessor(cookies))
          opener.addheaders = [("User-agent",
                                "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6; en-us) AppleWebKit/533.4 (KHTML, like Gecko) Version/4.1 Safari/533.4")
            , ]
          mechanize.install_opener(opener)

          # Load the twitter page
          page = None
          try:
            page = mechanize.urlopen("http://mobile.twitter.com/" + twitter_user.twitter_screen_name)
          except mechanize.HTTPError, e:
            if e.code == 404:
              print "%s con página inválida" % twitter_user.twitter_screen_name
              #sys.stdout.flush()
              twitter_user.invalid_page = True
            pass
          except Exception, e:
            print "ERROR: %s" % (e.message)
            #sys.stdout.flush()
            #twitter_user.invalid_page = True
            pass

          if page and twitter_user.invalid_page == False:
            html = page.read()

            # Parse the page
            soup = BeautifulSoup(html)

            # Check that the tweets are not private
            if soup.find('div', 'protected'):
              #print "%s con tweets privados" % twitter_user.twitter_screen_name
              #sys.stdout.flush()
              twitter_user.private_tweets = True
            else:
              # Get the tweets on text
              divs = soup.findAll('div', 'tweet-text')
              tweets = []
              for div in divs:
                tweets.append(div.text)

              tweets_text = ','.join(tweets)

              # Downcase all the tweets
              tweets_text = tweets_text.lower()

              # Search for keywords on tweets
              if regex_sports.search(tweets_text):
                twitter_user.sports = True
              if regex_fashion.search(tweets_text):
                twitter_user.fashion= True
              if regex_music.search(tweets_text):
                twitter_user.music = True
              if regex_movies.search(tweets_text):
                twitter_user.movies = True
              if regex_politics.search(tweets_text):
                twitter_user.politics = True
              if regex_technology.search(tweets_text):
                twitter_user.technology = True
              if regex_travel.search(tweets_text):
                twitter_user.travel = True
              if regex_luxury.search(tweets_text):
                twitter_user.luxury = True
              if regex_moms.search(tweets_text):
                twitter_user.moms = True
              if regex_teens.search(tweets_text):
                twitter_user.teens = True
              if regex_college_students.search(tweets_text):
                twitter_user.college_students = True
              if regex_young_women.search(tweets_text):
                twitter_user.young_women = True
              if regex_young_men.search(tweets_text):
                twitter_user.young_men = True
              if regex_adult_women.search(tweets_text):
                twitter_user.adult_women = True
              if regex_adult_men.search(tweets_text):
                twitter_user.adult_men = True
              twitter_user.last_sync_at = datetime.now()
              twitter_user.private_tweets = False
              twitter_user.invalid_page = False
              print "%s actualizado" % twitter_user.twitter_screen_name

          # Save the result
          self.tsession.commit()
          self.queue.task_done()
          sys.stdout.flush()
      finally:
        if self.tsession:
          self.tsession.remove()
          self.tsession = None
        print "Thread terminado"
        sys.stdout.flush()

    print "Chequeando usuarios de twitter"
  sys.stdout.flush()
  while session.query(func.count(TwitterUser)).filter(TwitterUser.last_sync_at == None, TwitterUser.private_tweets == False).all() > 0:
    start = time.time()

    print "Fetch de 10000 usuarios de twitter"
    sys.stdout.flush()
    twitter_users = session.query(TwitterUser.id).filter(TwitterUser.last_sync_at == None, TwitterUser.private_tweets == False).limit(10000).all()

    print "Creando el queue de objetos"
    queue = Queue()
    sys.stdout.flush()
    for twitter_user in twitter_users:
      queue.put(twitter_user.id)

    print "Creando hilos"
    sys.stdout.flush()
    for i in range(100):
      t = FetchThread(queue)
      t.setDaemon(True)
      t.start()

    print "Esperando hijos"
    sys.stdout.flush()

    queue.join()

    # Close all the sessions and start a new one
    Session.close_all()
    session = Session()


    print "Tardo %d segundos en updatear 10000 usuarios" % (time.time() - start)
    sys.stdout.flush()

except Exception, e:
  print "Error %s" % (e)
  sys.stdout.flush()
  raise
finally:
  #if conn:
  #  conn.close()
  if session:
    session.close()

elapsed_time = time.time() - start_time
print "Tardo %d segundos en updatear todos los seguidores" % (elapsed_time)
sys.stdout.flush()
