--- Create Books Table
CREATE TABLE IF NOT EXISTS Books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    title TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    year_published INTEGER NOT NULL,
    language TEXT NOT NULL DEFAULT 'English'
        CHECK (language IN ('English', 'Russian', 'French', 'Spanish', 'German', 'Chinese', 'Japanese', 
                            'Kazakh', 'Italian', 'Portuguese', 'Arabic', 'Turkish', 'Hindi', 'Korean', 
                            'Greek', 'Dutch', 'Polish', 'Ukrainian', 'Hebrew', 'Swedish', 'Finnish', 
                            'Czech', 'Hungarian', 'Danish', 'Romanian', 'Thai', 'Indonesian', 'Vietnamese', 
                            'Norwegian', 'Malay', 'Filipino', 'Serbian', 'Slovak', 'Bulgarian', 'Croatian', 
                            'Persian', 'Tamil', 'Urdu', 'Bengali', 'Swahili', 'Afrikaans', 'Georgian', 'Lithuanian', 
                            'Latvian', 'Slovenian', 'Mongolian', 'Armenian', 'Estonian', 'Albanian', 'Macedonian')),
    UNIQUE (title, language),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE, 
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id) ON DELETE SET NULL
);

--- Create Patrons Table
CREATE TABLE IF NOT EXISTS Patrons (
    patron_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50)NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email TEXT UNIQUE NOT NULL 
        CHECK (email LIKE '%@%'), 
     phone TEXT UNIQUE NOT NULL 
        CHECK (phone LIKE '+%' AND LENGTH(phone) >= 10),
    membership_date TEXT NOT NULL DEFAULT (date('now'))
);

--- Create Loans Table 
CREATE TABLE IF NOT EXISTS Loans (
    loan_id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER NOT NULL,
    patron_id INTEGER NOT NULL,
    loan_period_days INTEGER NOT NULL CHECK (loan_period_days BETWEEN 1 AND 30),
    loan_date TEXT NOT NULL DEFAULT (date('now')),
    due_date TEXT NOT NULL GENERATED ALWAYS AS (date(loan_date, '+' || loan_period_days || ' days')) VIRTUAL, 
    return_date TEXT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE, 
    FOREIGN KEY (patron_id) REFERENCES Patrons(patron_id) ON DELETE CASCADE 
);

--- Create Authors Table 
CREATE TABLE IF NOT EXISTS Authors (
    author_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    birth_year INTEGER NOT NULL CHECK(birth_year > 0),
    nationality TEXT NOT NULL,
    UNIQUE (first_name, last_name, birth_year, nationality)
);

CREATE TABLE IF NOT EXISTS Genres (
    genre_id INTEGER PRIMARY KEY AUTOINCREMENT,
    genre_name TEXT UNIQUE NOT NULL,
    genre_description TEXT,
    genre_popularity INTEGER NOT NULL,
    genre_created TEXT NOT NULL DEFAULT (date('now'))
);


---            Связи между таблицами

--- Books → author_id (ссылается на Authors.author_id).
--- Books → genre_id (ссылается на Genres.genre_id).
--- Loans → book_id (ссылается на Books.book_id).
--- Loans → patron_id (ссылается на Patrons.patron_id).

-- Books table indexes
CREATE INDEX idx_books_year_published ON Books(year_published);
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_books_author_id ON Books(author_id);

-- Patrons table indexes
CREATE INDEX idx_patrons_last_name ON Patrons(last_name);
CREATE INDEX idx_patrons_email ON Patrons(email);
CREATE INDEX idx_patrons_first_name ON Patrons(first_name);

-- Loans table indexes
CREATE INDEX idx_loans_patron_id ON Loans(patron_id);
CREATE INDEX idx_loans_book_id ON Loans(book_id);