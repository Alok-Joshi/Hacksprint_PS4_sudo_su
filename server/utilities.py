from models import Base
from sqlalchemy_utils import database_exists, create_database,drop_database
from sqlalchemy import  create_engine
from dotenv import load_dotenv
import sys
import os


load_dotenv("db.env")

DB_PROTOCOL = os.getenv("DB_PROTOCOL")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")
DB_HOST = os.getenv("DB_HOST")

SERVER_URL = f"{DB_PROTOCOL}{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"


def reset_db():
    """ Drops the existing database, creates the new database with the new schema in models """
    try:
        #pdb.set_trace()
        if database_exists(SERVER_URL):
            drop_database(SERVER_URL)
        
        create_database(SERVER_URL)
        engine = create_engine(SERVER_URL,echo = True,future = True)
        Base.metadata.create_all(bind = engine)

    except Exception as e:
            print(e)

        
if(__name__ == "__main__"):

    if(len(sys.argv)<=1 or len(sys.argv)>2):
        print("invalid input.")

    elif(sys.argv[1] == "reset_db"):
        reset_db()
    else:
        print("Unknown command")


