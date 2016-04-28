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
    COUNT(Book.CategoryID) AS book_count,
    CAST(COALESCE(AVG(Price), 0.0) AS decimal(10,2)) AS average_price
  FROM Category LEFT JOIN Book ON Category.CategoryID = Book.CategoryID
  GROUP BY Category.CategoryID ORDER BY Category.CategoryID
  ) AS a
  UNION
  (SELECT
     NULL,
    'Uncategorized',
    'N/A',
    COUNT(Book.CategoryID),
    CAST(COALESCE(AVG(Price), 0.0) AS decimal(10,2))
 FROM Book WHERE CategoryID IS NULL)
ORDER BY CategoryID""")

    head = [desc[0] for desc in cur.description]
    rows = cur.fetchall()

    cur.execute("SELECT COUNT(Book.BookID) AS total_book_count, CAST(COALESCE(SUM(Price), 0.0) AS decimal(10,2)) AS total_price FROM Category LEFT JOIN Book ON Category.CategoryID = Book.CategoryID")

    shead = [desc[0] for desc in cur.description]
    srows = cur.fetchall();

    # what should the next book ID be? Be simple, go with the current max+1
    # or 0, if there is no max
    cur.execute("SELECT COALESCE(MAX(CategoryID) + 1, 0) FROM Category")
    nextID = cur.fetchall()[0][0];

    return render_template("categories.html", head=head, rows=rows, shead=shead, srows=srows, nextID=nextID)
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

@app.route("/categories/discount/<int:cid>", methods=["GET", "POST"])
def categoriesDiscount(cid):
  try:
    con, cur = getConnection()

    cname = "Uncategorized"
    count = 0;
    # get the category name
    if cid >= 0: # if the cid is >= 0, then get the name of the category and the number of books
      cur.execute("SELECT Name FROM Category WHERE CategoryID = %s", [cid])
      cname = cur.fetchall()[0][0]
      cur.execute("SELECT COUNT(*) FROM Book WHERE CategoryID = %s", [cid])
    else: # otherwise, get the number of uncategorized books
      cur.execute("SELECT COUNT(*) FROM Book WHERE CategoryID IS NULL")
    count = cur.fetchall()[0][0]

    if request.method == "GET":
      return render_template("category_discount.html", name=cname, id=cid, count=count)


    discount = 0.0
    if "discount" in request.form:
      discount = float(request.form["discount"])
    else:
      discount = 100.0 / (100.0 - float(request.form["undiscount"]))
    cur.execute("""UPDATE Book
  SET Price = CAST(Price * (1 - (%s / 100.0)) AS decimal(10,2))
  WHERE CategoryID = %s""", [discount, cid])

    con.commit()

    return render_template("category_discount.html", name=cname, id=cid, count=count, done=1)
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()

# task 4, publisher stuff
@app.route("/publishers")
def publishers():
  try:
    con, cur = getConnection()

    # this is task three, combined with some extra stuff
    # we want everything from the category
    # and we want the count of books in each category
    # and the average price
    # also union, because we want to include books which have no category
#    cur.execute("""SELECT
#  Book.*,
#  COUNT(Book.BookID) AS num_orders,
#  SUM(Quantity) AS quant_orderd,
#  TO_CHAR(ShopOrder.OrderDate, 'YYYY-MM') AS order_month,
#  SUM(Price*Quantity) AS retail_price,
#  SUM(UnitSellingPrice*Quantity) AS selling_price
#  FROM Book,OrderLine,ShopOrder
#  WHERE Book.BookID = OrderLine.BookID AND OrderLine.ShopOrderID = ShopOrder.ShopOrderID AND
#    PublisherID = (SELECT PublisherID FROM Publisher WHERE Name = 'HarperCollins')
#  GROUP BY Book.BookID, TO_CHAR(ShopOrder.OrderDate, 'YYYY-MM')
#  ORDER BY TO_CHAR(ShopOrder.OrderDate, 'YYYY-MM') DESC
#""")
    cur.execute("SELECT *, (SELECT COUNT(BookID) FROM Book WHERE Book.PublisherID = Publisher.PublisherID) AS book_count FROM Publisher")

    head = [desc[0] for desc in cur.description]
    rows = cur.fetchall()

#    shead = [desc[0] for desc in cur.description]
#    srows = cur.fetchall();

    # what should the next book ID be? Be simple, go with the current max+1
    # or 0, if there is no max
    cur.execute("SELECT COALESCE(MAX(PublisherID) + 1, 0) FROM Publisher")
    nextID = cur.fetchall()[0][0];

    return render_template("publishers.html", head=head, rows=rows, nextID=nextID)
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()

@app.route("/publishers/history/<int:pid>")
def publisherHistory(pid):
  try:
    con, cur = getConnection()

    cur.execute("""SELECT
  Book.BookID,
  Book.Title,
  COUNT(Book.BookID) AS num_orders,
  SUM(Quantity) AS quant_orderd,
  TO_CHAR(ShopOrder.OrderDate, 'YYYY-MM') AS order_month,
  SUM(Price*Quantity) AS retail_price,
  SUM(UnitSellingPrice*Quantity) AS selling_price
  FROM Book,OrderLine,ShopOrder
  WHERE Book.BookID = OrderLine.BookID AND OrderLine.ShopOrderID = ShopOrder.ShopOrderID AND
    PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherID = %s)
  GROUP BY Book.BookID, TO_CHAR(ShopOrder.OrderDate, 'YYYY-MM')
  ORDER BY TO_CHAR(ShopOrder.OrderDate, 'YYYY-MM') DESC
""", [pid])

    head = [desc[0] for desc in cur.description]
    rows = cur.fetchall()

    cur.execute("""SELECT
  COUNT(Book.BookID) AS total_orders,
  SUM(Quantity) AS total_quant_ordered,
  SUM(Price*Quantity) AS total_retail_price,
  SUM(UnitSellingPrice*Quantity) AS total_selling_price
    FROM Book,OrderLine,ShopOrder
  WHERE Book.BookID = OrderLine.BookID AND OrderLine.ShopOrderID = ShopOrder.ShopOrderID AND
    PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherID = %s)""", [pid])

    shead = [desc[0] for desc in cur.description]
    srows = cur.fetchall()

    return render_template("publisher_history.html", head=head, rows=rows, shead=shead, srows=srows)
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()


# book stuff, link to task 5
@app.route("/books")
def books():
  try:
    con, cur = getConnection()

    cur.execute("SELECT BookID, Title, Price, (SELECT Name FROM Category WHERE Category.CategoryID = Book.CategoryID) AS category, (SELECT Name FROM Publisher WHERE Publisher.PublisherID = Book.PublisherID) AS publisher FROM Book ORDER BY BookID")
    head = [desc[0] for desc in cur.description]
    rows = cur.fetchall()

    cur.execute("SELECT COALESCE(MAX(BookID) + 1, 0) FROM Book")
    nextID = cur.fetchall()[0][0]

    return render_template("books.html", head=head, rows=rows, nextID=nextID)
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()

# task 5
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

    cur.execute("SELECT COUNT(*) AS total_sold, SUM(UnitSellingPrice) AS total_selling_value FROM OrderLine WHERE BookID = %s", [bid])
    shead = [desc[0] for desc in cur.description]
    srows = cur.fetchall()

    return render_template("book_history.html", head=head, rows=rows, shead=shead, srows=srows)
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()

#task 6
@app.route('/salesreps', methods=["GET", "POST"])
def salesReps():
  if request.method == "GET":
    return render_template("salesreps.html")

  try:
    con, cur = getConnection()

    if not request.form["from"] or not request.form["to"]:
      return render_template("salesreps.html")

    # split up the date so we can pass it to the query correctly
    (fDay, fMon, fYear) = request.form["from"].split("/")
    (tDay, tMon, tYear) = request.form["to"].split("/")

    fromDate = "'" + fYear + "-" + fMon + "-" + fDay + "'"
    toDate = "'" + tYear + "-" + tMon + "-" + tDay + "'"

    cur.execute("""SELECT
  *
  FROM
  (
    SELECT
      SalesRep.SalesRepID,
      SalesRep.Name,
      COALESCE(COUNT(DISTINCT(ShopOrder.ShopOrderID)), 0) AS num_orders,
      COALESCE(SUM(UnitSellingPrice*Quantity), 0.0) AS total_order_value,
      COALESCE(SUM(Quantity), 0) AS total_order_quantity
    FROM
      SalesRep
    LEFT JOIN
      ShopOrder ON SalesRep.SalesRepID = ShopOrder.SalesRepID
    LEFT JOIN
      OrderLine ON ShopOrder.ShopOrderID = OrderLine.ShopOrderID
    WHERE OrderDate IS NULL OR OrderDate > %(from)s AND OrderDate < %(to)s
    GROUP BY SalesRep.SalesRepID
  ) AS a
  UNION
  (
    SELECT
      b.SalesRepID,
      Name,
      0,
      0.0,
      0
    FROM (
      SELECT SalesRepID FROM SalesRep EXCEPT (SELECT DISTINCT(SalesRepID) FROM ShopOrder WHERE OrderDate > %(from)s AND OrderDate < %(to)s)
      ) AS b JOIN SalesRep ON b.SalesRepID = SalesRep.SalesRepID
  )
  ORDER BY total_order_value DESC""", {'from': fromDate, 'to': toDate})

    head = [desc[0] for desc in cur.description]
    rows = cur.fetchall()

    return render_template("salesreps.html", head=head, table=rows, fromDate=fromDate, toDate=toDate);
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()


# extra tid bit for running custom queries, dangerous though
# inserts and such are always rolled back, though
@app.route('/custom', methods=["GET", "POST"])
def custom():
  if request.method == "GET":
    return render_template("custom.html");

  try:
    con, cur = getConnection()
    print("Running custom query")
    print(request.form["query"])
    cur.execute(request.form["query"])
    head = [desc[0] for desc in cur.description]
    rows = cur.fetchall()
    con.rollback()
    return render_template("custom.html", head=head, table=rows);
  except Exception as e:
    return render_template("index.html", msg=e)
  finally:
    if con:
      con.close()
