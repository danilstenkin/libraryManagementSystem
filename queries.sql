-- Basic SELECT Queries:
SELECT * FROM Books;

SELECT title, year_published FROM Books;

-- -- Simple Data Entries:
INSERT INTO Patrons (first_name, last_name, email, phone)
VALUES ("Someone", "New", 'random.email@gmail.com', '+77771234567');

-- Column Operations and Aliases:
SELECT first_name || ' ' || last_name AS "full_name"
FROM Patrons;

SELECT 
    book_id, 
    title, 
    year_published, 
    (strftime('%Y', 'now') - year_published) AS "book_age"
FROM Books;

-- Filtering Data:
SELECT book_id, title
FROM Books
WHERE year_published > 2000;

SELECT patron_id, first_name, last_name 
FROM Patrons
WHERE last_name = 'Smith';