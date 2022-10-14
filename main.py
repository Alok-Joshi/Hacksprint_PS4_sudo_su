from fastapi import FastAPI, Cookie, HTTPException, Depends, Response
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
SALT = bcrypt.gensalt()

class Payload(BaseModel):
    email : str
    password : str | None
    car_rc : str | None

def user_exists(user_name: str, password: str) -> bool:
    s = bcrypt.hashpw("password".encode("utf-8"), SALT)
    s = s.decode()
    b = bcrypt.checkpw(password.encode("utf-8"), s.encode("utf-8"))
    if user_name == "aditya" and b:
        return True
    else: return False

def car_exists(user_name: str, car_rc: str) -> bool:
    if user_name == "aditya" and car_rc == "ritz" :
        return True
    else: return False

def create_user(email: str, password: str):
    print(email, password)

def register_car(email: str, car_rc: str):
    print(f"User Created! {email} {car_rc}", email, car_rc)

@app.get("/login/")
async def get_cookie(body: str | None = Cookie(default=None)):
    return body

def get_jwt_token(email: str):
    return jwt.encode({ "email" : email , 'exp' : datetime.datetime.utcnow() + datetime.timedelta(minutes= EXPIRY_TIME)}, SECRET_KEY, )

def check_jwt_token(jwt_key : str = Cookie(None)):
    try:
        return jwt.decode(jwt_key, SECRET_KEY, algorithms=["HS256"])
    except:
        raise HTTPException(status_code=404, detail="JWT_TOKEN_NOT_FOUND")

@app.get("/bookings/{user_id}", dependencies=[Depends(check_jwt_token)])
def get_bookings(user_id: str):
    return {
        "user_id" : user_id
    }

@app.get("/login", status_code=200)
def login(payload: Payload, response: Response):
    if payload.password == None:
        raise HTTPException(status_code=404, detail="No Password Provided")
    else:
        if user_exists(payload.email, payload.password):
            response.set_cookie(key="jwt_key", value=get_jwt_token(payload.email))
            return { "message" : "Logged In Succesfully" }
        else:
            raise HTTPException(status_code=404, detail="User Not Found")

@app.post("/register/{entity}", status_code = 201)
def register(payload: Payload, entity:str, response : Response):
    if entity == "user" and payload.password != None :
        if user_exists(payload.email, payload.password):
            raise HTTPException(status_code=404, detail="User Already exists")
        else:
            create_user(payload.email, payload.password)
            response.set_cookie(key="jwt_key", value=get_jwt_token(payload.email))
            return { "message" : "User was registered Succesfully" }
    elif entity == "car" and payload.car_rc != None :
        if car_exists(payload.email, payload.car_rc):
            raise HTTPException(status_code=404, detail="Car {car} has already been registered!".format(car = payload.car_rc))
        else:
            return { "message" : "Car was registered to {email}".format(email = payload.email) }
