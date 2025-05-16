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
        timecreated TEXT DEFAULT (datetime('now')), 
        date TEXT NOT NULL,
        name TEXT,
        amount REAL NOT NULL,
        classification TEXT,
        category TEXT,
        place TEXT
    );
}

# generate example data 
set exampledata {
    {date "2025-05-01" name "Einkauf Rewe" amount 42.50 classification "Ausgabe" category "Lebensmittel" place "Rewe" }
    {date "2025-05-03" name "Bahnticket" amount 15.00 classification "Ausgabe" category "Transport" place "online" }
    {date "2025-05-05" name "Minijob" amount -450.00 classification "Einnahme" category "Gehalt" place "Arbeit" }
}

foreach entry $exampledata {
    db::execValuesSql {
        INSERT INTO transactions (date, name, amount, classification, category, place)
        VALUES (:date, :name, :amount, :classification, :category, :place)
    } $entry
}

# optinal: print everything
puts "Transaktionen:"
db::printTable transactions

# close connection
db::close
