#!/usr/bin/python3

import json
import psycopg2

from bookshopapp import app
from bookshopapp import dbmanager

# sha1 hash of "bookshop"
app.secret_key = "aae2dc52f6e3d02c1102517987d816b548bfd3f7"

if __name__ == "__main__":
  app.run(debug = True)
