from fastapi import FastAPI, Header, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import bcrypt
import jwt
import datetime
from database import database

origins = [ '*' ]

app = FastAPI(title="Smart Park API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

SECRET_KEY = "smartparking"
EXPIRY_TIME = 60 * 24 * 7
SALT = bcrypt.gensalt()

class Payload(BaseModel):
    email : str
    password : str | None
    car_rc : str | None

class BookingPayload(BaseModel):
    email : str
    car_rc: str
    pl_id: str
    end_time : datetime.datetime
    start_time : datetime.datetime | None
    slot_name : str | None

def get_jwt_token(email: str):
    return jwt.encode({ "email" : email ,
       'exp' : datetime.datetime.utcnow() + datetime.timedelta(minutes= EXPIRY_TIME)
    }, SECRET_KEY, )

def check_jwt_token(token : str = Header(None)):
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    except:
        raise HTTPException(status_code=404, detail="JWT_TOKEN_NOT_FOUND")

def convert_slot(slot_id: int, layout_id: int):
    if slot_id != 0:
        return str(chr(layout_id + ord('A'))) + str(slot_id)
    else:
        return 0

def convert_layout(layout):
    dic = {}
    for i in range(len(layout)):
        for j in range(len(layout[i])):
            key = "layout"+str(i)
            if key not in dic.keys():
                dic[key] = []
            dic[key].append(convert_slot(layout[i][j], i))
    return dic

def parse_slot(slot_name: str):
    layout_id = ord(slot_name[0]) - ord('A')
    slot_id = int(slot_name[1:])
    return {
        "layout_id" : layout_id,
        "slot_id" : slot_id
    }

def book_slot(email, start_time, end_time, slot_name, later):
    print(email, start_time, end_time, slot_name, later)

def get_layouts(email):
    print(email)

# End_Points
@app.get("/bookings/{email_id}", status_code=200)
def get_upcoming_bookings(email_id: str, token : str  = Header(None)):
    try:
        a = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    except:
        raise HTTPException(status_code=404, detail="JWT_TOKEN_NOT_FOUND")
    if a["email"] != email_id:
        raise HTTPException(status_code=404, detail="Unauthorised Email ID")
    else:
        ub =  database.upcoming_bookings(email_id)
        ub["slot_name"] = convert_slot(ub["slot_name"], ub["layout_id"])
        ub["layout_id"] = str(chr(ub["layout_id"] + ord('A')))
        return ub

@app.post("/bookings", dependencies=[Depends(check_jwt_token)], status_code=200)
def slot_bookings(payload: BookingPayload):
    later = False
    if payload.start_time != None :
        later = True
    if payload.slot_name is not None:
        val = parse_slot(payload.slot_name)
        try:
            database.book_slot(val["slot_id"],
                                  payload.email,
                                  payload.car_rc,
                                  val["layout_id"],
                                  payload.start_time,
                                  payload.end_time,
                                  payload.pl_id,
                                  later)
        except:
            raise HTTPException(status_code=500, detail="Internal Server Error")

    else:
        raise HTTPException(status_code=404, detail="No slot_name Provided!")

@app.get("/bookings/{email_id}", dependencies=[Depends(check_jwt_token)], status_code=200)
def get_booking(email_id: str):
    # return database.get_bookings(email_id)
    print(email_id)

@app.get("/layout/{pl_id}", dependencies=[Depends(check_jwt_token)], status_code=200)
def get_layout(pl_id: str):
    return convert_layout(database.layout(pl_id))

@app.get("/vehicles/{email_id}", dependencies=[Depends(check_jwt_token)], status_code=200)
def get_vehicles(email_id: str):
    d = database.get_car(email_id)
    return {
        "email_id" : email_id,
        "vehicles" : d
    }

@app.post("/login", status_code=200)
def login(payload: Payload):
    if payload.password == None:
        raise HTTPException(status_code=404, detail="No Password Provided")
    else:
        if database.user_exists(payload.email, payload.password):
            return {
                "message" : "Logged In Succesfully",
                "token" : get_jwt_token(payload.email)
            }
        else:
            raise HTTPException(status_code=404, detail="User Not Found")

@app.post("/register/{entity}", status_code = 201)
def register(payload: Payload, entity:str):
    if entity == "user" and payload.password != None :
        if database.user_exists(payload.email, payload.password):
            raise HTTPException(status_code=404, detail="User Already exists")
        else:
            try :
                database.create_user(payload.email, payload.password)
            except:
                raise HTTPException(status_code=501, detail="Internal Server Error")
            return {
                "message" : "User was registered Succesfully",
                "token" : get_jwt_token(payload.email)
            }
    elif entity == "car" and payload.car_rc != None :
        if database.car_exists(payload.email, payload.car_rc):
            raise HTTPException(status_code=404, detail="Car {car} has already been registered!".format(car = payload.car_rc))
        else:
            try :
                database.register_car(payload.email, payload.car_rc)
            except:
                raise HTTPException(status_code=501, detail="Internal Server Error")
            return {
                "message" : "Car was registered to {email} Succesfully!".format(email = payload.email),
            }
