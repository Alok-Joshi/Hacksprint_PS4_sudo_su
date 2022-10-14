from models import *
from sqlalchemy_utils import database_exists, create_database,drop_database
from sqlalchemy import  create_engine
from sqlalchemy.orm import Session
from dotenv import load_dotenv
import sys
import os
import pymysql


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

def insert_dummy():
    """ Inserts the neccessary dummy values for testing """
    engine = create_engine(SERVER_URL, echo = True, future = True)
    session = Session(engine)

    parking_lot = ParkingLot(pl_id = 1, name = "Kothrud Parking Lot", city = "Pune",state = "MH")
    sample_layout = Layout(layout_id = 0,pl_id = 1)
    sample_layout1 = Layout(layout_id = 1,pl_id = 1)
    slots_elements = []

    for i in range(1,6):
        slots_elements.append(Slot(layout_id = 0,slot_name = i,pl_id = 1))
    for i in range(1,6):
        slots_elements.append(Slot(layout_id = 1,slot_name = i,pl_id = 1))

    session.add(parking_lot)
    session.commit()
    session.add(sample_layout)
    session.add(sample_layout1)
    session.commit()
    session.add_all(slots_elements)
    session.commit()

if(__name__ == "__main__"):

    if(len(sys.argv)<=1 or len(sys.argv)>2):
        print("invalid input.")

    elif(sys.argv[1] == "reset_db"):
        reset_db()
    elif(sys.argv[1] == "insert_dummy"):
        insert_dummy()
