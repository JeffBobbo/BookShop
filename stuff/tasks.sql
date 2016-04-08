-- task SQL

/* task 1
Create new categories (from id, name and type)
*/
INSERT INTO Category VALUES (catID, catName, catType);

/* task 2
Given a category id, remove that category
*/
DELETE FROM Category WHERE CategoryID = catID;

/* task 3
summary report of books available in each category
  should include the number of book titles and average price
*/
SELECT CategoryID, COUNT(*) AS count, CAST(AVG(Price) AS decimal(10,2)) AS average_price FROM Book GROUP BY CategoryID;

/* task 4
given a publisher name, produce a report of books ordered by year and month
  for each year and month, the report should show bookid, title, total number of orders, total quantity and total selling value (order and retail)
*/
SELECT * FROM Book,OrderLine,ShopOrder WHERE Book.BookID = OrderLine.BookID AND OrderLine.ShopOrderID = ShopOrder.ShopOrderID AND PublisherID = (SELECT PublisherID FROM Publisher WHERE Name = 'HarperCollins');

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
  order_value,
  shop_name
FROM
  (SELECT
    Title,
    OrderDate,
    Price,
    UnitSellingPrice,
    Quantity,
    ShopOrder.ShopOrderID
    FROM Book,OrderLine,ShopOrder WHERE Book.BookID = OrderLine.BookID AND OrderLine.ShopOrderID = ShopOrder.ShopOrderID AND Book.BookID = 2) AS a
  JOIN
    (SELECT ShopOrder.ShopOrderID,
      SUM(UnitSellingPrice*Quantity) AS order_value,
      (SELECT Name FROM Shop WHERE ShopID = ShopOrder.ShopID) AS shop_name
      FROM OrderLine RIGHT JOIN ShopOrder ON OrderLine.ShopOrderID = ShopOrder.ShopOrderID GROUP BY ShopOrder.ShopOrderID) AS b
  ON  a.ShopOrderID = b.ShopOrderID

/* task 6
given start and end dates, produce a report showing the performance of each sales rep over that period
  report should beginw ith the rep who generated most orders by value and include total units sold and total order value
  include all sales reps
*/
--SELECT

/* task 7
given a category id and discount percentage, apply a discount to the standard price of all books in that category
*/
-- non-mutating version
SELECT BookID, Title, CAST(Price * (1 - (discount / 100.0)) AS decimal(10,2)) AS Price, CategoryID, PublisherID FROM Book WHERE CategoryID = catID;
-- mutating version
UPDATE Book
  SET Price = CAST(Price * (1 - (discount / 100.0)) AS decimal(10,2))
  WHERE CategoryID = catID;
