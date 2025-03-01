--- Create Books Table
CREATE TABLE IF NOT EXISTS Books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    title TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    year_published INTEGER NOT NULL, -- В SQLite нет YEAR, заменяем на INTEGER
    language TEXT NOT NULL DEFAULT 'English'
        CHECK (language IN ('English', 'Russian', 'French', 'Spanish', 'German', 'Chinese', 'Japanese', 
                            'Kazakh', 'Italian', 'Portuguese', 'Arabic', 'Turkish', 'Hindi', 'Korean', 
                            'Greek', 'Dutch', 'Polish', 'Ukrainian', 'Hebrew', 'Swedish', 'Finnish', 
                            'Czech', 'Hungarian', 'Danish', 'Romanian', 'Thai', 'Indonesian', 'Vietnamese', 
                            'Norwegian', 'Malay', 'Filipino', 'Serbian', 'Slovak', 'Bulgarian', 'Croatian', 
                            'Persian', 'Tamil', 'Urdu', 'Bengali', 'Swahili', 'Afrikaans', 'Georgian', 'Lithuanian', 
                            'Latvian', 'Slovenian', 'Mongolian', 'Armenian', 'Estonian', 'Albanian', 'Macedonian')),
    UNIQUE (title, language) -- Запрещает дублирование книг с одинаковым названием и языком
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
    loan_period_days INTEGER NOT NULL CHECK (loan_period_days BETWEEN 1 AND 30), -- Количество дней аренды (не может быть отрицательным)
    loan_date TEXT NOT NULL DEFAULT (date('now')), -- Дата выдачи (по умолчанию сегодня)
    due_date TEXT NOT NULL GENERATED ALWAYS AS (date(loan_date, '+' || loan_period_days || ' days')) VIRTUAL, -- Автоматический расчёт даты возврата
    return_date TEXT -- Фактическая дата возврата (может быть NULL)
);
--- Create Authors Table 

CREATE TABLE IF NOT EXISTS Authors (
    author_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name 	VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_year YEAR,
    nationality VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Genres (
    genre_id INTEGER PRIMARY KEY AUTOINCREMENT,
    genre_name VARCHAR(50) UNIQUE NOT NULL,
    genre_description TEXT
    genre_popularity INTEGER NOT NULL,
    genre_created TEXT NOT NULL DEFAULT (date('now'))

);

---            Связи между таблицами

--- Books → author_id (ссылается на Authors.author_id).
--- Books → genre_id (ссылается на Genres.genre_id).
--- Loans → book_id (ссылается на Books.book_id).
--- Loans → patron_id (ссылается на Patrons.patron_id).
