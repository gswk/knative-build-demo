package main

import (
	"fmt"
	"log"
	"net/http"
)

func handlePost(rw http.ResponseWriter, req *http.Request) {
	// Say Hello!
	fmt.Fprintf(rw, "%s", "Hello from Knative Builds!")
}

func main() {
	log.Print("Starting server on port 8080...")
	http.HandleFunc("/", handlePost)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
