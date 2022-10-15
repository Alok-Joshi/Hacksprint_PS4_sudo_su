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
    start_time : datetime.datetime | None
    end_time : datetime.datetime
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

def convert_layout(layout):
    dic = {}
    for i in range(len(layout)):
        for j in range(len(layout[i])):
            key = "layout"+str(i)
            if key not in dic.keys():
                dic[key] = []
            if layout[i][j] != 0:
                dic[key].append(str(chr(i + ord('A'))) + str(layout[i][j]))
            else:
                dic[key].append(0)

    return dic

def book_slot(email, start_time, end_time, slot_name, later):
    print(email, start_time, end_time, slot_name, later)

def get_bookings(email):
    print(email)

def get_layouts(email):
    print(email)

# End_Points
@app.post("/bookings", dependencies=[Depends(check_jwt_token)], status_code=200)
def slot_bookings(payload: BookingPayload):
    later = False
    if payload.start_time != None :
        later = True
    return book_slot(payload.email,
                       payload.start_time,
                       payload.end_time,
                       payload.slot_name,
                       later)

@app.get("/bookings/{user_id}", dependencies=[Depends(check_jwt_token)], status_code=200)
def get_booking(user_id: str):
    return get_bookings(user_id)

@app.get("/layout/{pl_id}", dependencies=[Depends(check_jwt_token)], status_code=200)
def get_layout(pl_id: str):
    return convert_layout(database.layout(pl_id))

@app.get("/vehicles/{user_id}", dependencies=[Depends(check_jwt_token)], status_code=200)
def get_vehicles(user_id: str):
    d = database.get_car(user_id)
    return {
        "user_id" : user_id,
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
                database.register_car(payload.email, payload.password)
            except:
                raise HTTPException(status_code=501, detail="Internal Server Error")
            return {
                "message" : "Car was registered to {email} Succesfully!".format(email = payload.email),
            }
