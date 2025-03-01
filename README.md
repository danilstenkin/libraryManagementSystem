# Library Management System

## Overview
The **Library Management System** is a database project designed to manage book records, patrons, and loan transactions efficiently. It helps track book availability, patron details, and loan history, ensuring smooth library operations.

## Features
- **Book Management:** Add, update, delete, and retrieve book records.
- **Patron Management:** Maintain patron details, including contact information.
- **Loan Management:** Track books borrowed and returned.
- **Indexing:** Optimized queries using indexed columns.
- **Constraints:** Ensures data integrity with primary keys, foreign keys, and checks.

## Entity-Relationship Diagram (ERD)
The database consists of five main tables:
1. **Books** - Stores information about books.
2. **Patrons** - Maintains details of library members.
3. **Loans** - Tracks book loans and returns.
4. **Authors** - Stores information about books' authors.
5. **Genres** - Stores information about books' genres.


## Database Schema

### **Books Table**
```sql
CREATE TABLE Books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    title TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    year_published INTEGER NOT NULL, 
    language TEXT NOT NULL DEFAULT 'English'
        CHECK (language IN ('English', 'Russian', 'French',...)),
    UNIQUE (title, language)
);
```

### **Patrons Table**
```sql
CREATE TABLE Patrons (
    patron_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50)NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email TEXT UNIQUE NOT NULL 
        CHECK (email LIKE '%@%'), 
     phone TEXT UNIQUE NOT NULL 
        CHECK (phone LIKE '+%' AND LENGTH(phone) >= 10),
    membership_date TEXT NOT NULL DEFAULT (date('now'))
);
```

### **Loans Table**
```sql
CCREATE TABLE IF NOT EXISTS Loans (
    loan_id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER NOT NULL,
    patron_id INTEGER NOT NULL,
    loan_period_days INTEGER NOT NULL CHECK (loan_period_days BETWEEN 1 AND 30),
    loan_date TEXT NOT NULL DEFAULT (date('now')),
    due_date TEXT NOT NULL GENERATED ALWAYS AS (date(loan_date, '+' || loan_period_days || ' days')) VIRTUAL,
    return_date TEXT 
);
```

### **Authors Table**
```sql
CREATE TABLE IF NOT EXISTS Authors (
    author_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name 	VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_year YEAR,
    nationality VARCHAR(50)
);
```

### **Genres Table**
```sql
CREATE TABLE IF NOT EXISTS Genres (
    genre_id INTEGER PRIMARY KEY AUTOINCREMENT,
    genre_name VARCHAR(50) UNIQUE NOT NULL,
    genre_description TEXT
    genre_popularity INTEGER NOT NULL,
    genre_created TEXT NOT NULL DEFAULT (date('now'))

);
```

## Sample Data

### **Insert Sample Books**
```sql
INSERT INTO Books (book_id, title, year_published, genre_id, author_id) VALUES
(1, 'The Great Gatsby', 1925, 1, 1),
(2, 'To Kill a Mockingbird', 1960, 2, 2),
(3, '1984', 1949, 3, 3);
```

### **Insert Sample Patrons**
```sql
INSERT INTO Patrons (patron_id, first_name, last_name, email, phone) VALUES
(1, 'Alice', 'Smith', 'alice@example.com', '123-456-7890'),
(2, 'Bob', 'Johnson', 'bob@example.com', '234-567-8901');
```

### **Insert Sample Loans**
```sql
INSERT INTO Loans (loan_id, book_id, patron_id, loan_date, return_date) VALUES
(1, 1, 1, '2025-02-01', '2025-02-15'),
(2, 2, 2, '2025-02-02', NULL);
```

## Indexing
To optimize search queries, indexes are created on frequently queried columns.
```sql
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_patrons_email ON Patrons(email);
```

## Test Cases

### **1. Inserting a Duplicate Primary Key**
```sql
INSERT INTO Books (book_id, title, year_published, genre_id, author_id) VALUES (1, 'Duplicate', 2023, 1, 1);
-- Expected: Error due to PRIMARY KEY constraint.
```

### **2. Inserting NULL into NOT NULL Column**
```sql
INSERT INTO Patrons (patron_id, first_name, last_name, email, phone) VALUES (3, NULL, 'Brown', 'charlie@example.com', '345-678-9012');
-- Expected: Error due to NOT NULL constraint.
```

### **3. Foreign Key Constraint Violation**
```sql
INSERT INTO Loans (loan_id, book_id, patron_id, loan_date, return_date) VALUES (3, 99, 1, '2025-02-03', NULL);
-- Expected: Error due to book_id not existing in Books table.
```

## License
This project is licensed under the MIT License.

