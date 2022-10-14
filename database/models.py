from sqlalchemy import Column, ForeignKeyConstraint, UniqueConstraint, create_engine
from sqlalchemy import ForeignKey
from sqlalchemy import Integer, DateTime
from sqlalchemy import String
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import relationship


Base = declarative_base()


class User(Base):
      __tablename__ = 'users'

      email = Column(String(100), primary_key = True)
      password = Column(String(255),nullable = True)
      
      def __repr__(self):
          return f"{self.email}  {self.password} "

class Office(Base):
    
      __tablename__ = 'offices'

      oid = Column(Integer, primary_key = True)
      name = Column(String(30))
      city  = Column(String(30))
      state = Column(String(30))

class Layout(Base):

      __tablename__ = 'layouts'

      layout_id = Column(Integer, primary_key = True)
      office_id = Column(Integer, ForeignKey("offices.oid"), nullable = False,primary_key = True)

class Slot(Base):

      __tablename__ = 'slots'

      layout_id = Column(Integer, ForeignKey("layouts.layout_id"),nullable = False,primary_key = True)
      slot_name = Column(Integer, primary_key = True,nullable = False)
      office_id = Column(Integer, ForeignKey("offices.oid"), nullable = False,primary_key = True)



class Vehicle(Base):
      __tablename__ = "vehicles"
      rc = Column(String(20),primary_key = True)
      owner = Column(String(100),ForeignKey("users.email"),nullable = False)
      
      def __repr__(self):
          return f"{self.rc} {self.owner} "
class Booking(Base):

      __tablename__ = 'booking'

      email = Column(String(100), ForeignKey("users.email"),nullable = False, primary_key = True)
      vehicle_rc = Column(String(100),ForeignKey("vehicles.rc"),primary_key = True)
      layout_id = Column(Integer)
      slot_name = Column(Integer)
      office_id = Column(Integer)

      start_time = Column(DateTime)
      end_time = Column(DateTime)
      __table_args__ = (ForeignKeyConstraint([layout_id,slot_name,office_id],[Slot.layout_id,Slot.slot_name,Slot.office_id]),{})


