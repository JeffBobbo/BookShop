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
  con = psycopg2.connect(connStr)
  return con, con.cursor()
