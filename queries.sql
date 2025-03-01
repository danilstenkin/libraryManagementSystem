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
    AUTHORS a
    JOIN BOOKS b ON a.author_id = b.author_id
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
    b.book_id NOT IN (SELECT book_id FROM loans)
    AND
    b.year_published < (SELECT AVG(year_published) FROM books)
ORDER BY 
    b.year_published;