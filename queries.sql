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

