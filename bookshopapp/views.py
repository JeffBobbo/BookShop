#!/usr/bin/python3

from bookshopapp import app
from flask import Flask, render_template, request, redirect, url_for

from bookshopapp.dbmanager import *

@app.route("/")
def index():
  return render_template("index.html")

# categories page, countains task 3 and forms for tasks 1 and 2
@app.route("/categories")
def categories():
  try:
    con, cur = getConnection()

    # this is task three, combined with some extra stuff
    # we want everything from the category
    # and we want the count of books in each category
    # and the average price
    # also union, because we want to include books which have no category
    cur.execute("""SELECT * FROM
  (SELECT
    Category.*,
    COUNT(Book.CategoryID) AS count,
    CAST(COALESCE(AVG(Price), 0.0) AS decimal(10,2)) AS average_price
  FROM Category LEFT JOIN Book ON Category.CategoryID = Book.CategoryID
  GROUP BY Category.CategoryID ORDER BY Category.CategoryID
  ) AS a
  UNION
  (SELECT
     NULL,
    'Uncategorized',
    'N/A',
    Count(Book.CategoryID),
    CAST(COALESCE(AVG(Price), 0.0) AS decimal(10,2))
 FROM Book WHERE CategoryID IS NULL)
  UNION
  (SELECT
    NULL,
    'Totals',
    'N/A',
    Count(Book.BookID),
    CAST(COALESCE(SUM(Price), 0.0) AS decimal(10,2))
  FROM Category LEFT JOIN Book ON Category.CategoryID = Book.CategoryID)
ORDER BY CategoryID""")

    head = [desc[0] for desc in cur.description]
    rows = cur.fetchall()

    # what should the next book ID be? Be simple, go with the current max+1
    # or 0, if there is no max
    cur.execute("SELECT COALESCE(MAX(CategoryID) + 1, 0) FROM Category")
    nextID = cur.fetchall()[0][0];

    return render_template("categories.html", head=head, table=rows, nextID=nextID)
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()

# function for task 1
@app.route("/categories/add", methods=["POST"])
def categoriesAdd():
  try:
    con, cur = getConnection()

    cid = request.form["cid"]
    cname = request.form["cname"]
    ctype = request.form["ctype"]

    cur.execute("INSERT INTO Category VALUES (%s, %s, %s)", [cid, cname, ctype])
    con.commit()

    return redirect(url_for("categories"))
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()

# function for task 2
@app.route("/categories/del", methods=["POST"])
def categoriesDel():
  try:
    con, cur = getConnection()

    cid = request.form["cat"]

    cur.execute("DELETE FROM Category WHERE CategoryID = %s", [cid])
    con.commit()

    return redirect(url_for("categories"))
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()

# book stuff, includes task 4
@app.route("/books")
def books():
  try:
    con, cur = getConnection()

    cur.execute("SELECT BookID, Title, (SELECT Name FROM Category WHERE Category.CategoryID = Book.CategoryID) AS category, (SELECT Name FROM Publisher WHERE Publisher.PublisherID = Book.PublisherID) AS publisher FROM Book ORDER BY BookID")
    head = [desc[0] for desc in cur.description]
    rows = cur.fetchall()

    cur.execute("SELECT COALESCE(MAX(BookID) + 1, 0) FROM Book")
    nextID = cur.fetchall()[0][0];

    return render_template("books.html", head=head, table=rows, nextID=nextID)
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()

@app.route('/books/history/<int:bid>')
def bookHistory(bid):
  try:
    con, cur = getConnection()

    cur.execute("""SELECT
  Title,
  OrderDate,
  Price,
  UnitSellingPrice,
  Quantity,
  ShopOrder.ShopOrderID,
  (SELECT Name FROM Shop WHERE ShopID = ShopOrder.ShopID) AS shop_name,
  (SELECT order_value FROM order_value WHERE ShopOrderID = ShopOrder.ShopOrderID)
  FROM Book,OrderLine,ShopOrder
  WHERE Book.BookID = OrderLine.BookID AND OrderLine.ShopOrderID = ShopOrder.ShopOrderID AND
    Book.BookID = %s""", [bid])
    head = [desc[0] for desc in cur.description]
    rows = cur.fetchall()

    return render_template("book_history.html", head=head, table=rows)
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()

@app.route('/custom', methods=["GET", "POST"])
def custom():
  if request.method == "POST":
    try:
      con, cur = getConnection()
      cur.execute(request.form["query"])
      head = [desc[0] for desc in cur.description]
      rows = cur.fetchall()
      con.rollback()
      print(rows)
      return render_template("custom.html", head=head, table=rows);
    except Exception as e:
      return render_template("index.html", msg=e)
    finally:
      if con:
        con.close()
  return render_template("custom.html");
