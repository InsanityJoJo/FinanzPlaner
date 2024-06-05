namespace eval db {
	#opens database and creates db::conn object
	proc open {filename} {
		tdbc::sqlite3::connection create conn $filename
	}
	#executes sql statement
	proc execSql {sql} {
		set stmt [conn prepare $sql]
		$stmt execute
		$stmt close
	}
	#executes sql statement with values as a dictionary
	proc execValuesSql {sql values} {
		set stmt [conn prepare $sql]
		$stmt execute $values
		$stmt close
	}
	#selects all entries from a table and returns the result
	proc selectFrom {tableName} {
		set stmt [conn prepare "select * from $tableName"]
		return [$stmt execute]
	}
	#prints all entries from a table
	proc printTable {tableName} {
		conn foreach row "select * from $tableName" {} {
			puts $row
		}
	}
	#closes database connection
	proc close {} {
		conn close
	}
}
