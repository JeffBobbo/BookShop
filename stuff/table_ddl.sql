CREATE TABLE IF NOT EXISTS Category
(
  CategoryID    INTEGER PRIMARY KEY,
  Name          VARCHAR(50) UNIQUE NOT NULL CONSTRAINT valid_category_name CHECK (Name != ''),
  CategoryType  VARCHAR(20) NOT NULL CONSTRAINT valid_cateogry_type CHECK (CategoryType = 'fiction' OR CategoryType = 'Non-fiction')
);

CREATE TABLE IF NOT EXISTS SalesRep
(
  SalesRepID  INTEGER PRIMARY KEY,
  Name        VARCHAR(50) NOT NULL CONSTRAINT valid_salesrep_name CHECK (Name != '')
);

CREATE TABLE IF NOT EXISTS Shop
(
  ShopID  INTEGER PRIMARY KEY,
  Name    VARCHAR(50) NOT NULL CONSTRAINT valid_shop_name CHECK (Name != '')
);

CREATE TABLE IF NOT EXISTS Publisher
(
  PublisherID INTEGER PRIMARY KEY,
  Name        VARCHAR(50) UNIQUE NOT NULL CONSTRAINT valid_publisher_name CHECK (Name != '')
);

CREATE TABLE IF NOT EXISTS Book
(
  BookID      INTEGER PRIMARY KEY,
  Title       VARCHAR(50) NOT NULL CONSTRAINT valid_book_title CHECK (Title != ''),
  Price       DECIMAL(10,2) NOT NULL CONSTRAINT valid_book_price CHECK (Price > 0.0),
  CategoryID  INTEGER REFERENCES Category(CategoryID) ON DELETE SET NULL,
  PublisherID INTEGER REFERENCES Publisher(PublisherID)
);

CREATE TABLE IF NOT EXISTS ShopOrder
(
  ShopOrderID INTEGER PRIMARY KEY,
  OrderDate   DATE,
  ShopID      INTEGER REFERENCES Shop(ShopID),
  SalesRepID  INTEGER REFERENCES SalesRep(SalesRepID)
);
CREATE TABLE IF NOT EXISTS Orderline
(
  ShopOrderID       INTEGER REFERENCES ShopOrder(ShopOrderID),
  BookID            INTEGER REFERENCES Book(BookID),
  Quantity          INTEGER CONSTRAINT valid_orderline_quantity CHECK (Quantity > 0),
  UnitSellingPrice  DECIMAL (10,2) CONSTRAINT valid_orderline_unitprice CHECK (UnitSellingPrice >= 0.0),
  PRIMARY KEY (ShopOrderID, BookID)
)
