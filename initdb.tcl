# initdb.tcl
# for testing and dev

package require tdbc::sqlite3

# load database-logic
source database.tcl

# delete old db
file delete -force data.sqlite3

# new dB connection
db::open "data.sqlite3"

# generate table
db::execSql {
    CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        category TEXT,
        name TEXT,
        amount REAL NOT NULL
    );
}

# generate example data 
set exampledata {
    {date "2025-05-01" category "Lebensmittel" name "Einkauf Rewe" amount 42.50}
    {date "2025-05-03" category "Transport" name "Bahnticket" amount 15.00}
    {date "2025-05-05" category "Gehalt" name "Minijob" amount -450.00}
}

foreach entry $exampledata {
    db::execValuesSql {
        INSERT INTO transactions (date, category, name, amount)
        VALUES (:date, :category, :name, :amount)
    } $entry
}

# optinal: print everything
puts "Transaktionen:"
db::printTable transactions

# close connection
db::close
