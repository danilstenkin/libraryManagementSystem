-- Basic SELECT Queries:
SELECT
    *
FROM
    Books;

SELECT
    title,
    year_published
FROM
    Books;

-- Simple Data Entries:
INSERT INTO
    Patrons (first_name, last_name, email, phone)
VALUES
    (
        "Someone",
        "New",
        'random.email@gmail.com',
        '+77771234567'
    );

-- Column Operations and Aliases:
SELECT
    first_name || ' ' || last_name AS "full_name"
FROM
    Patrons;

SELECT
    book_id,
    title,
    year_published,
    (strftime('%Y', 'now') - year_published) AS "book_age"
FROM
    Books;

-- Filtering Data:
SELECT
    book_id,
    title
FROM
    Books
WHERE
    year_published > 2000;

SELECT
    patron_id,
    first_name,
    last_name
FROM
    Patrons
WHERE
    last_name = 'Smith';

-- Pattern Matching and Sorting:
SELECT
    book_id,
    title
FROM
    Books
WHERE
    title LIKE 'The%'
ORDER BY
    year_published DESC;

-- Text Operations:
SELECT
    patron_id,
    upper(email)
FROM
    Patrons;

SELECT
    patron_id,
    first_name,
    last_name
FROM
    Patrons
WHERE
    first_name LIKE '%a';

-- Unique Values:
SELECT
    DISTINCT g.genre_id,
    g.genre_name
FROM
    Books b
    JOIN Genres g ON b.genre_id = g.genre_id
ORDER BY
    g.genre_name;

-- Aggregate Functions:
SELECT
    count(book_id) AS "total_number_of_books"
FROM
    Books;

SELECT
    book_id,
    title AS "oldest_book",
    year_published
FROM
    Books
WHERE
    year_published = (
        SELECT
            MIN(year_published)
        FROM
            Books
    )
LIMIT
    1;

-- Grouping Operations:
SELECT
    a.author_id,
    a.last_name,
    a.first_name,
    COUNT(*) AS book_count
FROM
    Books b
    JOIN Authors a ON b.author_id = a.author_id
GROUP BY
    b.author_id
ORDER BY
    book_count DESC;

SELECT
    AVG(loan_count) AS average_loans_per_patron
FROM
    (
        SELECT
            patron_id,
            COUNT(*) AS loan_count
        FROM
            Loans
        GROUP BY
            patron_id
    ) AS patron_loans;

-- Filtering Groups:
SELECT
    b.author_id,
    a.first_name,
    a.last_name,
    COUNT(*) AS book_count
FROM
    Books b
    JOIN Authors a ON b.author_id = a.author_id
GROUP BY
    b.author_id
HAVING
    COUNT(*) > 2
ORDER BY
    book_count DESC;

SELECT
    l.patron_id,
    p.first_name,
    p.last_name,
    COUNT(*) AS borrowed_count
FROM
    Loans l
    JOIN Patrons p ON l.patron_id = p.patron_id
GROUP BY
    l.patron_id
HAVING
    COUNT(*) > 3
ORDER BY
    borrowed_count DESC;

--- 11. Single Value Subqueries
SELECT
    l.book_id,
    (
        SELECT
            title
        FROM
            books b
        WHERE
            b.book_id = l.book_id
    ) as title,
    count(*) as loan_count
FROM
    loans l
GROUP BY
    l.book_id
HAVING
    loan_count = (
        SELECT
            count(*) as maxLoan_count
        FROM
            Loans
        GROUP BY
            book_id
        ORDER BY
            maxLoan_count DESC
        LIMIT
            1
    );

--- 12. Single Value Subqueries
SELECT
    p.patron_id,
    (p.first_name || ' ' || p.last_name) AS full_name,
    g.genre_name
FROM
    Patrons p
    JOIN Loans l ON p.patron_id = l.patron_id
    JOIN books b ON l.book_id = b.book_id
    JOIN Genres g ON b.genre_id = g.genre_id
GROUP BY
    p.patron_id,
    g.genre_id
HAVING
    count(DISTINCT l.book_id) = (
        SELECT
            count(*)
        FROM
            books b2
        WHERE
            b2.genre_id = g.genre_id
    );

--- 13. Nested Aggregates
SELECT
    a.author_id,
    a.first_name || ' ' || a.last_name AS author_name,
    AVG(2025 - b.year_published) AS average_book_age
FROM
    authors a
    JOIN books b ON a.author_id = b.author_id
GROUP BY
    a.author_id
ORDER BY
    average_book_age DESC;

--- 14. Complex Filtering
SELECT
    b.book_id,
    b.title,
    b.year_published
FROM
    Books b
WHERE
    b.book_id NOT IN (
        SELECT
            book_id
        FROM
            Loans
    )
    AND b.year_published < (
        SELECT
            AVG(year_published)
        FROM
            Books
    )
ORDER BY
    b.year_published;

--- 15. Conditional Aggregation
SELECT
    p.patron_id,
    (p.first_name || ' ' || p.last_name) AS full_name,
    count(
        CASE
            WHEN b.year_published > 2010 THEN 1
        END
    ) AS total_books_published_after_2010
FROM
    Patrons p
    JOIN Loans l ON p.patron_id = l.patron_id
    JOIN Books b ON l.book_id = b.book_id
GROUP BY
    p.patron_id;

--- 16. Subqueries in SELECT Clause
SELECT
    b.book_id,
    b.title,
    COUNT(l.book_id) AS number_of_times_borrowed
FROM
    Books b
    JOIN Loans l ON b.book_id = l.book_id
GROUP BY
    b.book_id,
    b.title;

--- 17. Advanced Pattern Matching
SELECT
    DISTINCT a.author_id,
    a.first_name,
    a.last_name
FROM
    authors a
    JOIN Books b ON a.author_id = b.author_id
WHERE
    a.last_name LIKE '%son%'
    AND b.title LIKE '%Data%'
ORDER BY
    a.last_name;

--- 18. Date Calculations
SELECT
    l.loan_id,
    b.title AS book_title,
    p.first_name || ' ' || p.last_name AS patron_name,
    l.due_date,
    julianday('now') - julianday(l.due_date) AS days_overdue
FROM
    Loans l
    JOIN Books b ON l.book_id = b.book_id
    JOIN Patrons p ON l.patron_id = p.patron_id
WHERE
    l.return_date IS NULL
    AND days_overdue > 30
ORDER BY
    days_overdue DESC;

--- 19. Combined Aggregate Functions
SELECT
    g.genre_id,
    g.genre_name,
    AVG(2025 - b.year_published) AS average_book_age
FROM
    Genres g
    JOIN Books b ON g.genre_id = b.genre_id
GROUP BY
    g.genre_id
ORDER BY
    average_book_age DESC
LIMIT
    1;

--- 20. Nested Subqueries and Aggregation
SELECT
    p.patron_id,
    p.first_name || ' ' || p.last_name AS patron_name,
    COUNT(l.loan_id) AS books_borrowed
FROM
    Patrons p
    JOIN Loans l ON p.patron_id = l.patron_id
GROUP BY
    p.patron_id
HAVING
    COUNT(l.loan_id) > (
        SELECT
            AVG(books_per_patron)
        FROM
            (
                SELECT
                    COUNT(loan_id) AS books_per_patron
                FROM
                    Loans
                GROUP BY
                    patron_id
            )
    )
ORDER BY
    books_borrowed DESC;