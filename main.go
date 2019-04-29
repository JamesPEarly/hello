package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)


func main() {
	// Set up the router
	r := mux.NewRouter()
	r.HandleFunc("/jearly/hello", func(w http.ResponseWriter, r *http.Request) {
		// Anonymous request
		fmt.Fprintf(w, "Hello there. Who is this?\n")
	})
	r.HandleFunc("/jearly/hello/{name}", func(w http.ResponseWriter, r *http.Request) {
		// Get the path variable
		vars := mux.Vars(r)
		name := vars["name"]
		fmt.Fprintf(w, "Hello %s!\n", name)
	})

	http.ListenAndServe(":8080", r)
}
