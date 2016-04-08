#!/usr/bin/python3

import json
import psycopg2

# function to load details for logging into the database from a file
def loginDetails():
  with open("dblogin.json", "r") as f:
    txt = f.read()
    if (txt):
      return json.loads(txt)
  return []

# function construct a connection string and connect to the database.
def getConnection():
  details = loginDetails()
  connStr = "host='" + details["host"] + "' " + "dbname='" + details["name"] + "' " + "user='" + details["login"] + "' " + "password='" + details["password"] + "'"
  return psycopg2.connect(connStr)

# function to get a cursor and set the appropriate search path for us
def setup(con):
  cur = con.cursor()
  cur.execute("SET search_path TO demo")
  return cur;
