DROP SCHEMA public CASCADE;
CREATE SCHEMA IF NOT EXISTS public;


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


--Automate update update_dt
CREATE OR REPLACE FUNCTION trigger_set_updated_dt()
RETURNS TRIGGER AS $$
BEGIN
NEW.update_dt = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;



--Create sequence to generate unique id for booking table
CREATE SEQUENCE booking_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


CREATE TABLE "public"."student"(
  "student_id" varchar primary key not null,
  "password" varchar not null,
  "name" text not null,
  "kulliyyah" text not null,
  "created_dt" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updated_dt" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);


CREATE TABLE "public"."staff"(
  "staff_id" varchar primary key not null,
  "password" varchar not null,
  "name" text not null,
  "role" text not null,
  "created_dt" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  "updated_dt" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "public"."booking"(
  'booking_id' text primary key not null default 'AAA' || nextval('booking_id_seq'::regclass)::TEXT,
  'venue' text not null,
  'name' text not null,
  "status" text default 'Processing',
  'student_id' varchar not null references student (student_id),
  'staff_id' varchar not null references staff (staff_id),
  'created_dt' timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  'updated_dt' timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);


CREATE TABLE "public"."session"(
"session_id" uuid NOT NULL DEFAULT uuid_generate_v4(),
"staff_id" varchar  REFERENCES staff (staff_id),
"student_id" varchar REFERENCES student (student_id)
"ip_address" varchar NOT NULL,
"created_dt" timestamp DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY ("session_id")
)
