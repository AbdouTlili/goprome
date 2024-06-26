package main

import (
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	optProcessed = promauto.NewCounter(prometheus.CounterOpts{
		Name: "webserver_processed_ops_total",
		Help: "The total number of processed events in the web server",
	})
)

func recordMetrics() {
	go func() {
		for {
			optProcessed.Inc()
			time.Sleep(2 * time.Second)
		}
	}()
}

func main() {
	recordMetrics()
	print("starting wwebserver")
	http.Handle("/metrics", promhttp.Handler())
	http.ListenAndServe(":2112", nil)

}
