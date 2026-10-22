package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	mux.HandleFunc("GET /orders", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode([]map[string]any{
			{"id": 1, "item": "keyboard", "qty": 2},
		})
	})

	addr := ":8080"
	log.Printf("orders-api listening on %s (version %s)", addr, os.Getenv("APP_VERSION"))
	log.Fatal(http.ListenAndServe(addr, mux))
}

// trigger
