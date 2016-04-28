-- categories
INSERT INTO Category VALUES ( 0, 'Fantasy', 'fiction');
INSERT INTO Category VALUES ( 1, 'Science fiction', 'fiction');
INSERT INTO Category VALUES ( 2, 'Poetry', 'fiction');
INSERT INTO Category VALUES ( 3, 'Children''s', 'fiction');
INSERT INTO Category VALUES ( 4, 'History', 'Non-fiction');
INSERT INTO Category VALUES ( 5, 'Science', 'Non-fiction');
INSERT INTO Category VALUES ( 6, 'Mathematics', 'Non-fiction');
INSERT INTO Category VALUES ( 7, 'Computing', 'Non-fiction');
INSERT INTO Category VALUES ( 8, 'Reference', 'Non-fiction');
INSERT INTO Category VALUES ( 9, 'Languages', 'Non-fiction');
INSERT INTO Category VALUES (10, 'Sports', 'Non-fiction');
INSERT INTO Category VALUES (11, 'Horror', 'fiction');
INSERT INTO Category VALUES (12, 'Thriller', 'fiction');
INSERT INTO Category VALUES (13, 'Comedy', 'fiction');
INSERT INTO Category VALUES (14, 'Food and Drink', 'Non-fiction');

-- sales reps
INSERT INTO SalesRep VALUES (0, 'Woody Boyd');
INSERT INTO SalesRep VALUES (1, 'David Lister');
INSERT INTO SalesRep VALUES (2, 'Roy Slater');
INSERT INTO SalesRep VALUES (3, 'Patrick Jane');

-- shops
INSERT INTO Shop VALUES (0, 'Ye Olde Booke Shoppe');
INSERT INTO Shop VALUES (1, 'Waterstones, UEA');

-- publishers
INSERT INTO Publisher VALUES (0, 'Penguin');
INSERT INTO Publisher VALUES (1, 'HarperCollins');
INSERT INTO Publisher VALUES (2, 'Pearson');
INSERT INTO Publisher VALUES (3, 'John Murray');
INSERT INTO Publisher VALUES (4, 'Bloomsbury Childrens');

-- books
INSERT INTO Book VALUES ( 0, 'The Silmarillion', 5.84,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'HarperCollins'));
INSERT INTO Book VALUES ( 1, 'The Hobbit', 5.59,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'HarperCollins'));
INSERT INTO Book VALUES ( 2, 'The Lord of the Rings: The Fellowship of the Ring', 8.83,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'HarperCollins'));
INSERT INTO Book VALUES ( 3, 'The Lord of the Rings: The Two Towers', 8.89,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'HarperCollins'));
INSERT INTO Book VALUES ( 4, 'The Lord of the Rings: The Return of the King', 8.83,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'HarperCollins'));
INSERT INTO Book VALUES ( 5, 'Database Systems', 37.99,
                         (SELECT CategoryID FROM Category WHERE Name = 'Computing'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Pearson'));
INSERT INTO Book VALUES ( 6, 'Charlie and the Chocolate Factory', 5.99,
                         (SELECT CategoryID FROM Category WHERE Name = 'Children'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Penguin'));
INSERT INTO Book VALUES ( 7, 'What If?', 14.99,
                         (SELECT CategoryID FROM Category WHERE Name = 'Science'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'John Murray'));
INSERT INTO Book VALUES ( 8, 'Penguin Dictionary of Physics', 12.99,
                         (SELECT CategoryID FROM Category WHERE Name = 'Reference'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Penguin'));
INSERT INTO Book VALUES ( 9, 'The Ha Ha Bonk Book', 3.99,
                         (SELECT CategoryID FROM Category WHERE Name = 'Comedy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Penguin'));
INSERT INTO Book VALUES (10, 'Harry Potter and the Philosopher''s Stone', 15.00,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Bloomsbury Childrens'));
INSERT INTO Book VALUES (11, 'Harry Potter and the Chamber of Secrets', 14.00,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Bloomsbury Childrens'));
INSERT INTO Book VALUES (12, 'Harry Potter and the Prisoner of Azkaban', 16.00,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Bloomsbury Childrens'));
INSERT INTO Book VALUES (13, 'Harry Potter and the Goblet of Fire', 15.00,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Bloomsbury Childrens'));
INSERT INTO Book VALUES (14, 'Harry Potter and the Order of the Phoenix', 14.00,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Bloomsbury Childrens'));
INSERT INTO Book VALUES (15, 'Harry Potter and the Half Blood Prince', 16.00,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Bloomsbury Childrens'));
INSERT INTO Book VALUES (16, 'Harry Potter and the Deathly Hallows', 17.00,
                         (SELECT CategoryID FROM Category WHERE Name = 'Fantasy'),
                         (SELECT PublisherID FROM Publisher WHERE Name = 'Bloomsbury Childrens'));

-- shop order
INSERT INTO ShopOrder VALUES (0, '2016-03-28',
                              (SELECT ShopID FROM Shop WHERE Name = 'Waterstones, UEA'),
                              (SELECT SalesRepID FROM SalesRep WHERE Name = 'Roy Slater'));
INSERT INTO ShopOrder VALUES (1, '2014-06-12',
                              (SELECT ShopID FROM Shop WHERE Name = 'Ye Olde Booke Shoppe'),
                              (SELECT SalesRepID FROM SalesRep WHERE Name = 'Patrick Jane'));
INSERT INTO ShopOrder VALUES (2, '2014-07-03',
                              (SELECT ShopID FROM Shop WHERE Name = 'Ye Olde Booke Shoppe'),
                              (SELECT SalesRepID FROM SalesRep WHERE Name = 'Woody Byod'));
INSERT INTO ShopOrder VALUES (3, '2016-04-12',
                              (SELECT ShopID FROM Shop WHERE Name = 'Waterstones, UEA'),
                              (SELECT SalesRepID FROM SalesRep WHERE Name = 'David Lister'));
INSERT INTO ShopOrder VALUES (4, '2016-04-13',
                              (SELECT ShopID FROM Shop WHERE Name = 'Waterstones, UEA'),
                              (SELECT SalesRepID FROM SalesRep WHERE Name = 'David Lister'));

-- order line
INSERT INTO OrderLine VALUES (0,
                              (SELECT BookID FROM Book WHERE Title = 'The Silmarillion'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'The Silmarillion'));
INSERT INTO OrderLine VALUES (0,
                              (SELECT BookID FROM Book WHERE Title = 'The Hobbit'),
                              1,
                              (SELECT Price * 0.95 FROM Book WHERE Title = 'The Hobbit'));
INSERT INTO OrderLine VALUES (0,
                              (SELECT BookID FROM Book WHERE Title = 'The Lord of the Rings: The Fellowship of the Ring'),
                              1,
                              (SELECT Price * 0.95 FROM Book WHERE Title = 'The Lord of the Rings: The Fellowship of the Ring'));
INSERT INTO OrderLine VALUES (0,
                              (SELECT BookID FROM Book WHERE Title = 'The Lord of the Rings: The Two Towers'),
                              1,
                              (SELECT Price * 0.95 FROM Book WHERE Title = 'The Lord of the Rings: The Two Towers'));
INSERT INTO OrderLine VALUES (0,
                              (SELECT BookID FROM Book WHERE Title = 'The Lord of the Rings: The Return of the King'),
                              1,
                              (SELECT Price * 0.95 FROM Book WHERE Title = 'The Lord of the Rings: The Return of the King'));

INSERT INTO OrderLine VALUES (1,
                              (SELECT BookID FROM Book WHERE Title = 'Harry Potter and the Philosopher''s Stone'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'Harry Potter and the Philosopher''s Stone'));
INSERT INTO OrderLine VALUES (1,
                              (SELECT BookID FROM Book WHERE Title = 'Harry Potter and the Chamber of Secrets'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'Harry Potter and the Chamber of Secrets'));
INSERT INTO OrderLine VALUES (1,
                              (SELECT BookID FROM Book WHERE Title = 'Harry Potter and the Prisoner of Azkaban'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'Harry Potter and the Prisoner of Azkaban'));
INSERT INTO OrderLine VALUES (1,
                              (SELECT BookID FROM Book WHERE Title = 'Harry Potter and the Goblet of Fire'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'Harry Potter and the Goblet of Fire'));
INSERT INTO OrderLine VALUES (1,
                              (SELECT BookID FROM Book WHERE Title = 'Harry Potter and the Order of the Phoenix'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'Harry Potter and the Order of the Phoenix'));
INSERT INTO OrderLine VALUES (1,
                              (SELECT BookID FROM Book WHERE Title = 'Harry Potter and the Half Blood Prince'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'Harry Potter and the Half Blood Prince'));
INSERT INTO OrderLine VALUES (1,
                              (SELECT BookID FROM Book WHERE Title = 'Harry Potter and the Deathly Hallows'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'Harry Potter and the Deathly Hallows'));


INSERT INTO OrderLine VALUES (2,
                              (SELECT BookID FROM Book WHERE Title = 'The Ha Ha Bonk Book'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'The Ha Ha Bonk Book'));
INSERT INTO OrderLine VALUES (2,
                              (SELECT BookID FROM Book WHERE Title = 'Charlie and the Chocolate Factory'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'Charlie and the Chocolate Factory'));

INSERT INTO OrderLine VALUES (3,
                              (SELECT BookID FROM Book WHERE Title = 'What If?'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'What If?'));
INSERT INTO OrderLine VALUES (3,
                              (SELECT BookID FROM Book WHERE Title = 'Penguin Dictionary of Physics'),
                              1,
                              (SELECT Price FROM Book WHERE Title = 'Penguin Dictionary of Physics'));

INSERT INTO OrderLine VALUES (4,
                              (SELECT BookID FROM Book WHERE Title = 'The Lord of the Rings: The Fellowship of the Ring'),
                              1,
                              (SELECT Price * 0.97 FROM Book WHERE Title = 'The Lord of the Rings: The Fellowship of the Ring'));
INSERT INTO OrderLine VALUES (4,
                              (SELECT BookID FROM Book WHERE Title = 'The Lord of the Rings: The Two Towers'),
                              1,
                              (SELECT Price * 0.97 FROM Book WHERE Title = 'The Lord of the Rings: The Two Towers'));
INSERT INTO OrderLine VALUES (4,
                              (SELECT BookID FROM Book WHERE Title = 'The Lord of the Rings: The Return of the King'),
                              1,
                              (SELECT Price * 0.97 FROM Book WHERE Title = 'The Lord of the Rings: The Return of the King'));
