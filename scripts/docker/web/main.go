package main

import (
	"fmt"
	"net/http"

	"github.com/jackc/pgx"
)

var conn *pgx.Conn

func init() {
	var err error
	conn, err = pgx.Connect(
		pgx.ConnConfig{
			Host:     "localhost",
			Port:     6432,
			User:     "techdb",
			Password: "techdb",
			Database: "techdb",
		},
	)
	if err != nil {
		fmt.Printf("Unable to connection to database: %v\n", err)
		return
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	rows, err := conn.Query("select * from checkpoint_highschooler.highschooler")
	if err != nil {
		fmt.Fprintf(w, "Error querying the database: %v\n", err)
		return
	}

	defer rows.Close()

	for rows.Next() {
		var id int
		var name string
		var grade int
		err = rows.Scan(&id, &name, &grade)
		if err != nil {
			fmt.Fprintf(w, "Error scanning the row: %v\n", err)
			return
		}
		fmt.Fprintf(w, "ID: %d, Name: %s, Grade: %d\n", id, name, grade)
	}
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
