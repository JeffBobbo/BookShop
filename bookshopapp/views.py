#!/usr/bin/python3

from bookshopapp import app
from flask import Flask, render_template, request

from bookshopapp.dbmanager import *

def printAllRows(cur):
  rows = cur.fetchall()
  for row in rows:
    print(str(row[0]) + " ", end="")
    for i in range(1, len(row)):
      print(str(row[i]) + ", ", end="")
    print()

@app.route('/')
def index():
  return render_template('home.html')

@app.route('/displayEmp')
def displayEmp():
  try:
    con = None;
    con = getConnection()
    cur = setup(con)

    #The SQL statement
    cur.execute('SELECT * FROM emp')

    printAllRows(cur)
    return render_template("home.html", msg="Printed all to console")
  except Exception as e:
    return render_template('home.html', msg=e)
  finally:
    if con:
      con.close()
