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

def get_jwt_token(email: str):
    return jwt.encode({ "email" : email ,
       'exp' : datetime.datetime.utcnow() + datetime.timedelta(minutes= EXPIRY_TIME)
    }, SECRET_KEY, )

def check_jwt_token(token : str = Header(None)):
    try:
        return jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
    except:
        raise HTTPException(status_code=404, detail="JWT_TOKEN_NOT_FOUND")

@app.get("/bookings/{user_id}", dependencies=[Depends(check_jwt_token)])
def get_bookings(user_id: str):
    return {
        "user_id" : user_id
    }

@app.get("/login", status_code=200)
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
                "token" : get_jwt_token(payload.email)
            }
