from sqlalchemy import and_, create_engine
from sqlalchemy.orm import Session
from models import *
import pprint
SERVER_URL = "mysql+pymysql://root:password@localhost/feature_db" #hard coded for now
engine = create_engine(SERVER_URL,pool_size = 20)

def user_exists(email, password):
    """Checks if the email and password exists in the database. returns true or false. """
    session = Session(engine)
    db_output =  session.query(User).filter(and_(User.email == email,User.password == password)).all()
    session.close()
    return len(db_output) == 1

def car_exists(email,vehicle_rc):
    """ Checks if the email has the following vehicle linked to it """

    session = Session(engine)
    db_output = session.query(User,Vehicle).filter(User.email == Vehicle.owner).filter(Vehicle.rc == vehicle_rc).all()
    session.close()
    return len(db_output) == 1

def create_user(email,password):
    """ Creates a new user with email and password. """
    session = Session(engine)
    user_obj = User(email  = email,password = password)
    session.add(user_obj)
    session.commit()


def register_car(email,vehicle_rc):
    """ Creates a new car for a particular email """
    session = Session(engine)
    vehicle_obj = Vehicle(owner = email, rc = vehicle_rc)
    session.add(vehicle_obj)
    session.commit()


user_exists("AlokJoshi523@gmail.com","alokalok")



