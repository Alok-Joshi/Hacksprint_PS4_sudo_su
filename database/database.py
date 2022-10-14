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


def is_booked(slot_name,pl_id,layout_id):
    session = Session(engine)
    bookings = session.query(Booking).filter(and_(and_(Booking.layout_id == layout_id,Booking.pl_id == pl_id) , Booking.slot_name == slot_name)).all()
    return len(bookings) != 0

def layout(pl_id):
    """ Returns all the layouts with their respective slots  for a given parking lot """
    session = Session(engine)
    layout_count = session.query(Layout).filter(Layout.pl_id == pl_id).all()

    slots = session.query(Layout,Slot).filter(Layout.pl_id == pl_id).filter(Layout.layout_id == Slot.layout_id).all()
    #pdb.set_trace()
    output = [[] for _ in range(len(layout_count))]
    for i in slots:
        i_layout_id = i["Layout"].layout_id
        i_slot_name = i["Slot"].slot_name

        if(is_booked(i_slot_name,pl_id,i_layout_id)):
            output[i_layout_id].append(0)
        else:
            output[i_layout_id].append(i_slot_name)

    return output

        
        
    print(slots)

def book_slot(slot_name,email,vehicle_rc,layout_id,start_time,end_time,office_id = 1,later = False):
    """ 
    Books the given slot
    return dictionary mentioning if given slot was alloted (selected_slot:False)

    """
    if(not later):
        session = Session(engine)
        #first check if the given slot is available
        db_output = session.query(Booking).filter(Booking.slot_name == slot_name).all()
        if(len(db_output) == 0):
            #this implies this particular slot is not booked yet. Now we book it by updating the booking table
            booked_slot = Booking(slot_name = slot_name,email = email,vehicle_rc = vehicle_rc,layout_id =layout_id, office_id =office_id,start_time = start_time,end_time = end_time)
            session.add(booked_slot)
            session.commit()

            return_dict = {"slot_name":slot_name,"email":email,"vehicle_rc":vehicle_rc,"layout_id":layout_id,"start_time":start_time,"end_time":end_time,"office_id":office_id,"later":later}
            return return_dict

    else:
       session = Session(engine) 
       
       #step 1: first check absolutely free time slots. Those which are not booked FOR ANY TIME SLOT.
       result = engine.execute("select * from slots right outer join booking on (slots.office_id = booking.office_id and slots.slot_name = booking.slot_name and booking.layout_id = slots.layout_id) where b(booking.office_id is NULL and booking.slot_name is NULL and booking.layout_id is NULL);").all()

       if(len(result)>0):
           #this implies there are slots are absolutely free. Allocate any one of this

           selected_slot = tuple(result[0])
           booked_slot = Booking(email = selected_slot[0],vehicle_rc = selected_slot[1], layout_id = selected_slot[2], slot_name = selected_slot[3],office_id = selected_slot[4], start_time = start_time, end_time = end_time)
           session.add(booked_slot)
           return_dict = {"slot_name":selected_slot[3],"email":selected_slot[0],"vehicle_rc":selected_slot[1],"layout_id":selected_slot[2],"start_time":start_time,"end_time":end_time,"office_id":selected_slot[4],"later":later}

           return return_dict
        
       else:
            pass
           #This implies the there is not a single slot which is not booked. Now we need to check the booking table for existing slots which are free in the given time 
           #refer to algo given in the notebook
           #session = Session(engine)
           #db_output = session.query(Booking).filter(Booking


        
        
print(layout(1))


    








    

