package main

import (
	"io"
	"log"
	"net/http"
)

type myHandler struct{}

func (*myHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "URL: "+r.URL.String())
}

func main() {
	mux := http.NewServeMux()

	// Register routes and register handlers in this form.
	mux.Handle("/", &myHandler{})

	//http.ListenAndServe uses the default server structure.
	err := http.ListenAndServe(":8090", mux)
	if err != nil {
		log.Fatal(err)
	}
}
