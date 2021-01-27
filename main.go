package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/gorilla/mux"
)

func init() {
	// Attempt to read the secret key as an enviroment variable
	secretKey1 := []byte(os.Getenv("SECRET_KEY_1"))
	// Create a directory for certs
	os.MkdirAll("./cert", 0700)
	// Write this key to a file
	err := ioutil.WriteFile("./cert/secretKey1.pem", secretKey1, 0644)
	if err != nil {
		fmt.Printf("Error writing file: %s", string(secretKey1))
	}
}

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
	r.HandleFunc("/jearly/cert/secret", func(w http.ResponseWriter, r *http.Request) {
		// Show the secret file
		content, err := ioutil.ReadFile("./cert/secretKey1.pem")
		if err != nil {
			fmt.Fprintf(w, "Error reading file: %s", err.Error())
		} else {
			fmt.Fprintf(w, "%s", content)
		}
	})

	http.ListenAndServe(":8080", r)
}
