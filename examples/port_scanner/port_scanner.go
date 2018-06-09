package main

import (
	"context"
	"fmt"
	"golang.org/x/sync/semaphore"
	"net"
	"os/exec"
	"strconv"
	"strings"
	"sync"
	"time"
)

// The star of the show, of modest means,
// used to manage the port scan for a single host.
type PortScanner struct {
	ip   string
	lock *semaphore.Weighted
}

// Provides a simple wrapper to initializing a PortScanner.
func NewPortScanner(ip string, limit int64) *PortScanner {
	return &PortScanner{
		ip:   "127.0.0.1",
		lock: semaphore.NewWeighted(limit),
	}
}

// Returns the output from the ulimit builtin shell command for the
// maximum number of open connections, used to limit the number
// of concurrent port scans.
func Ulimit() int64 {
	out, err := exec.Command("ulimit", "-n").Output()
	if err != nil {
		panic(err)
	}
	s := strings.TrimSpace(string(out))
	i, err := strconv.ParseInt(s, 10, 64)
	if err != nil {
		panic(err)
	}
	return i
}

// As the name might suggest, this function checks if a given port
// is open to TCP communication. Used in conjunction with the Start function
// to sweep over a range of ports concurrently.
func checkPortOpen(ip string, port int, timeout time.Duration) {
	conn, err := net.DialTimeout("tcp", fmt.Sprintf("%s:%d", ip, port), timeout)

	if err != nil {
		if strings.Contains(err.Error(), "socket") {
			time.Sleep(500 * time.Millisecond)
			checkPortOpen(ip, port, timeout)
		} else {
			fmt.Println(port, "closed")
		}
		return
	}

	conn.Close()

	fmt.Println(port, "open")
}

// This function is the bread and butter of this script. It manages the
// port scanning for a given range of ports with the given timeout value
// to deal with filtered ports by a firewall typically.
func (ps *PortScanner) Start(start, stop int, timeout time.Duration) {
	wg := sync.WaitGroup{}
	defer wg.Wait()

	for port := start; port <= stop; port++ {

		ctx := context.TODO()

		for {
			err := ps.lock.Acquire(ctx, 1)
			if err == nil {
				break
			}
		}

		wg.Add(1)

		go func(ip string, port int) {
			defer ps.lock.Release(1)
			defer wg.Done()

			checkPortOpen(ps.ip, port, timeout)
		}(ps.ip, port)

	}
}

// This function kicks off the whole shindig' and provides a
// basic example of the internal API usage.
func main() {
	// Create a new PortScanner for localhost.
	ps := NewPortScanner("127.0.0.1", Ulimit())

	// Start scanning all the ports on localhost.
	ps.Start(1, 1024, 500*time.Millisecond)
}
