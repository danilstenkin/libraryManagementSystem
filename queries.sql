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
            loans
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
    patrons p
    JOIN loans l ON p.patron_id = l.patron_id
    JOIN books b ON l.book_id = b.book_id
    JOIN genres g ON b.genre_id = g.genre_id
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
    books b
WHERE
    b.book_id NOT IN (
        SELECT
            book_id
        FROM
            loans
    )
    AND b.year_published < (
        SELECT
            AVG(year_published)
        FROM
            books
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
    patrons p
    JOIN loans l ON p.patron_id = l.patron_id
    JOIN books b ON l.book_id = b.book_id
GROUP BY
    p.patron_id;

--- 16. Subqueries in SELECT Clause
SELECT 
    b.book_id, 
    b.title, 
    COUNT(l.book_id) AS number_of_times_borrowed
FROM 
    books b
JOIN 
    loans l ON b.book_id = l.book_id
GROUP BY 
    b.book_id, b.title;

--- 17. Advanced Pattern Matching
SELECT DISTINCT
    a.author_id,
    a.first_name,
    a.last_name
FROM 
    authors a
JOIN 
    books b ON a.author_id = b.author_id
WHERE 
    a.last_name LIKE '%son%'
    AND
    b.title LIKE '%Data%'
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
    LOANS l
JOIN 
    BOOKS b ON l.book_id = b.book_id
JOIN 
    PATRONS p ON l.patron_id = p.patron_id
WHERE 
    l.return_date IS NULL
    AND
    julianday('now') - julianday(l.due_date) > 30
ORDER BY 
    days_overdue DESC;

--- 20. Nested Subqueries and Aggregation
SELECT 
    p.patron_id,
    p.first_name || ' ' || p.last_name AS patron_name,
    COUNT(l.loan_id) AS books_borrowed
FROM 
    PATRONS p
JOIN 
    LOANS l ON p.patron_id = l.patron_id
GROUP BY 
    p.patron_id
HAVING 
    COUNT(l.loan_id) > (
        SELECT AVG(books_per_patron)
        FROM (
            SELECT 
                COUNT(loan_id) AS books_per_patron
            FROM 
                LOANS
            GROUP BY 
                patron_id
        )
    )
ORDER BY 
    books_borrowed DESC;