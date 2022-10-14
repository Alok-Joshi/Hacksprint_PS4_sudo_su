from fastapi import FastAPI, Cookie, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import bcrypt
import jwt
import datetime

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

class Payload(BaseModel):
    email : str
    password : str | None
    car_rc : str | None

def user_exists(user_name: str, password: str) -> bool:
    if user_name == "aditya" and password == "password" :
        return True
    else: return False

def car_exists(user_name: str, car_rc: str) -> bool:
    if user_name == "aditya" and car_rc == "ritz" :
        return True
    else: return False

def create_user(email: str, password: str):
    print(f"User Created! {email} {password}", email, password)

def register_car(email: str, car_rc: str):
    print(f"User Created! {email} {car_rc}", email, car_rc)

@app.get("/login/")
async def get_cookie(body: str | None = Cookie(default=None)):
    return body

def get_jwt_token(email: str):
    return jwt.encode({ "email" : email , 'exp' : datetime.datetime.utcnow() + datetime.timedelta(minutes= EXPIRY_TIME)}, SECRET_KEY, )

def check_jwt_token(jwt):
    try:
        return jwt.decode(jwt, SECRET_KEY, algorithms=["HS256"])
    except:
        return None

@app.get("/login")
def login(payload: Payload):
    if payload.password == None:
        raise HTTPException(status_code=404, detail="No Password Provided")
    else:
        if user_exists(payload.email, str(bcrypt.hashpw(payload.password.encode("utf-8"), bcrypt.gensalt()))):
            return get_jwt_token(payload.email)
        else:
            raise HTTPException(status_code=404, detail="User Not Found")

@app.get("/register/{entity}", status_code = 201)
def register(payload: Payload, entity:str):
    if entity == "user" and payload.password != None :
        if user_exists(payload.email, payload.password):
            raise HTTPException(status_code=404, detail="User Already exists")
        else:
            create_user(payload.email, payload.password)
            return get_jwt_token(payload.email)
    elif entity == "car" and payload.car_rc != None :
        if car_exists(payload.email, payload.car_rc):
            raise HTTPException(status_code=404, detail="Car {car} has already been registered!".format(car = payload.car_rc))
        else:
            return { "message" : "Car was registered to {email}".format(email = payload.email) }
