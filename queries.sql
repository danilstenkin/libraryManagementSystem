-- Basic SELECT Queries:
SELECT * FROM Books;

SELECT title, year_published FROM Books;

-- Simple Data Entries:
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

-- Pattern Matching and Sorting:
SELECT book_id, title
FROM Books
WHERE title LIKE 'The%'
ORDER BY year_published DESC;

-- Text Operations:
SELECT patron_id, upper(email)
FROM Patrons;

SELECT patron_id, first_name, last_name
FROM Patrons
WHERE first_name LIKE '%a';

-- Unique Values:
SELECT DISTINCT g.genre_id, g.genre_name
FROM Books b
JOIN Genres g ON b.genre_id = g.genre_id
ORDER BY g.genre_name;

-- Aggregate Functions:
SELECT count(book_id) AS "total_number_of_books"
FROM Books;

SELECT book_id, title AS "oldest_book", year_published
FROM Books
WHERE year_published = (SELECT MIN(year_published) FROM Books)
LIMIT 1;

-- Grouping Operations:
SELECT a.author_id, a.last_name, a.first_name, COUNT(*) AS book_count
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
GROUP BY b.author_id
ORDER BY book_count DESC;

SELECT AVG(loan_count) AS average_loans_per_patron
FROM (
    SELECT patron_id, COUNT(*) AS loan_count
    FROM Loans
    GROUP BY patron_id
) AS patron_loans;

-- Filtering Groups:
SELECT b.author_id, a.first_name, a.last_name, COUNT(*) AS book_count
FROM Books b
JOIN Authors a ON b.author_id = a.author_id
GROUP BY b.author_id
HAVING COUNT(*) > 2
ORDER BY book_count DESC;

SELECT l.patron_id, p.first_name, p.last_name, COUNT(*) AS borrowed_count
FROM Loans l
JOIN Patrons p ON l.patron_id = p.patron_id
GROUP BY l.patron_id
HAVING COUNT(*) > 3
ORDER BY borrowed_count DESC;