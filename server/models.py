from datetime import date
from sqlalchemy import Column, ForeignKeyConstraint, UniqueConstraint, create_engine
from sqlalchemy import ForeignKey
from sqlalchemy import Integer, DateTime
from sqlalchemy import String
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import relationship


Base = declarative_base()


class users(Base):
      __tablename__ = 'users'

      uid = Column(Integer, primary_key = True)
      email = Column(String(30), unique = True)
      password = Column(String(30),nullable = True)
      office_id = Column(Integer, ForeignKey("offices.oid"),nullable = False)


class offices(Base):
    
      __tablename__ = 'offices'

      oid = Column(Integer, primary_key = True)
      name = Column(String(30))
      city  = Column(String(30))
      state = Column(String(30))

class layouts(Base):

      __tablename__ = 'layouts'

      layout_id = Column(Integer, primary_key = True)
      office_id = Column(Integer, ForeignKey("offices.oid"), nullable = False,primary_key = True)

class slots(Base):

      __tablename__ = 'slots'

      layout_id = Column(Integer, ForeignKey("layouts.layout_id"),nullable = False,primary_key = True)
      slot_name = Column(Integer, primary_key = True,nullable = False)



      
class booking(Base):

      __tablename__ = 'booking'

      uid = Column(Integer, ForeignKey("users.uid"),nullable = False, primary_key = True)
      layout_id = Column(Integer)
      slot_name = Column(Integer)
      start_time = Column(DateTime)
      end_time = Column(DateTime)
      __table_args__ = (ForeignKeyConstraint([layout_id,slot_name],[slots.layout_id,slots.slot_name]),{})



if(__name__  == "__main__"):
    engine = create_engine("mysql+pymysql://root:password@localhost/feature_db",echo = True, future = True) #TODO: hardcoded for now, shall be changed later
    Base.metadata.create_all(bind =engine)
