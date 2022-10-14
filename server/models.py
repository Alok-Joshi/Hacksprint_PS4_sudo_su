from datetime import date
from sqlalchemy import Column, UniqueConstraint
from sqlalchemy import ForeignKey
from sqlalchemy import Integer, DateTime
from sqlalchemy import String
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import relationship


Base = declarative_base()


class users(Base):
      __tablename__ = 'users'

      uid = Column(Integer, primar_key = True)
      email = Column(String(30), unique = True)
      password = Column(String(30))
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

      __tablename__ = 'layouts'

      layout_id = Column(Integer, ForeignKey("layouts.layout_id"),nullable = False,primary_key = True)
      slot_name = Column(String(30), primary_key = True)



      
class booking(Base):

      __tablename__ = 'booking'

      uid = Column(Integer, ForeignKey("users.uid"),nullable = False, unique = True)
      layout_id = Column(Integer, ForeignKey("layouts.layout_id"),nullable = False)
      slot_name = Column(Integer, ForeignKey("slots.slot_name"), nullable = False)
      start_time = Column(DateTime)
      end_time = Column(DateTime)



