-- task SQL

/* task 1
Create new categories (from id, name and type)
*/
INSERT INTO Category VALUES (%s, %s, %s);

/* task 2
Given a category id, remove that category
*/
DELETE FROM Category WHERE CategoryID = %s;

/* task 3
summary report of books available in each category
  should include the number of book titles and average price
*/
SELECT * FROM
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
ORDER BY CategoryID

/* task 4
given a publisher name, produce a report of books ordered by year and month
  for each year and month, the report should show bookid, title, total number of orders, total quantity and total selling value (order and retail)
*/
SELECT
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

# summary
SELECT
  COUNT(Book.BookID) AS total_orders,
  SUM(Quantity) AS total_quant_ordered,
  SUM(Price*Quantity) AS total_retail_price,
  SUM(UnitSellingPrice*Quantity) AS total_selling_price
    FROM Book,OrderLine,ShopOrder
  WHERE Book.BookID = OrderLine.BookID AND OrderLine.ShopOrderID = ShopOrder.ShopOrderID AND
    PublisherID = (SELECT PublisherID FROM Publisher WHERE PublisherID = %s)

/* task 5
given a book id, produce the order history for that book
  include dates, titles, prices, unitselling price, total quantity, order value and shop name
  include a summary line showing the total number of copies ordered and the total selling value
*/
SELECT
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
    Book.BookID = %s

# summary
SELECT COUNT(*) AS total_sold, SUM(UnitSellingPrice) AS total_selling_value FROM OrderLine WHERE BookID = %s

/* task 6
given start and end dates, produce a report showing the performance of each sales rep over that period
  report should begin with the rep who generated most orders by value and include total units sold and total order value
  include all sales reps
*/
SELECT
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
    WHERE OrderDate IS NULL OR OrderDate BETWEEN %(from)s AND  %(to)s
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
      SELECT SalesRepID FROM SalesRep EXCEPT (SELECT DISTINCT(SalesRepID) FROM ShopOrder WHERE OrderDate BETWEEN %(from)s AND %(to)s)
      ) AS b JOIN SalesRep ON b.SalesRepID = SalesRep.SalesRepID
  )
  ORDER BY total_order_value DESC

/* task 7
given a category id and discount percentage, apply a discount to the standard price of all books in that category
*/
-- non-mutating version
SELECT BookID, Title, CAST(Price * (1 - (%s / 100.0)) AS decimal(10,2)) AS Price, CategoryID, PublisherID FROM Book WHERE CategoryID = %s;
-- mutating version
UPDATE Book
  SET Price = CAST(Price * (1 - (%s / 100.0)) AS decimal(10,2))
  WHERE CategoryID = %s
