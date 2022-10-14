from sqlalchemy import and_, create_engine
from sqlalchemy.orm import Session
from models import *
from dotenv import load_dotenv
import bcrypt
import os
import pdb

load_dotenv("db.env")
DB_PROTOCOL = os.getenv("DB_PROTOCOL")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")
DB_HOST = os.getenv("DB_HOST")

SERVER_URL = f"{DB_PROTOCOL}{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"

engine = create_engine(SERVER_URL,pool_size = 20)

def check_hash(db_password,entered_password):
    isSame = bcrypt.checkpw(entered_password.encode("utf-8"), db_password.encode("utf-8")) 
    return isSame

def user_exists(email, password):
    """Checks if the email and password exists in the database. returns true or false. """
    session = Session(engine)
    #pdb.set_trace()
    db_output =  session.query(User).filter(User.email == email).all()
    session.close()
    if(len(db_output)>0):
        return (check_hash(db_output[0].password, password)) 
    else:
        return False

def car_exists(email,vehicle_rc):
    """ Checks if the email has the following vehicle linked to it """

    session = Session(engine)
    db_output = session.query(User,Vehicle).filter(User.email == Vehicle.owner).filter(Vehicle.rc == vehicle_rc).all()
    session.close()
    return len(db_output) == 1

def create_user(email,password):
    """ Creates a new user with email and password. """
    session = Session(engine)
    password = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())
    user_obj = User(email  = email,password = password.decode('utf-8'))
    session.add(user_obj)
    session.commit()


def register_car(email,vehicle_rc):
    """ Creates a new car for a particular email """
    session = Session(engine)
    vehicle_obj = Vehicle(owner = email, rc = vehicle_rc)
    session.add(vehicle_obj)
    session.commit()


print(create_user("Alok@gmail.com","alokalok"))

print(user_exists("Alok@gmail.com","alokalok"))

