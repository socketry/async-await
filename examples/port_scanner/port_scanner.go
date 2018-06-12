package main

import (
	"context"
	"fmt"
	"golang.org/x/sync/semaphore"
	"net"
	"syscall"
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
func NewPortScanner(ip string, limit uint64) *PortScanner {
	return &PortScanner{
		ip: ip,
		lock: semaphore.NewWeighted(int64(limit)),
	}
}

// Compute the maximum number of files we can open.
func FileLimit(max uint64) uint64 {
	var rlimit syscall.Rlimit
	err := syscall.Getrlimit(syscall.RLIMIT_NOFILE, &rlimit)
	if err != nil {
		panic(err)
	}
	
	if (max < rlimit.Cur) {
		return max
	}
	
	return rlimit.Cur
}

// As the name might suggest, this function checks if a given port
// is open to TCP communication. Used in conjunction with the Start function
// to sweep over a range of ports concurrently.
func checkPortOpen(ip string, port int, timeout time.Duration) {
	conn, err := net.DialTimeout("tcp", fmt.Sprintf("%s:%d", ip, port), timeout)

	if err != nil {
		if strings.Contains(err.Error(), "timeout") {
			fmt.Println(port, "timeout", err.Error())
		} else if strings.Contains(err.Error(), "deadline exceeded") {
			fmt.Println(port, "timeout", err.Error())
		} else if strings.Contains(err.Error(), "refused") {
			// fmt.Println(port, "closed", err.Error())
		} else {
			panic(err)
		}
		return
	}

	fmt.Println(port, "open")
	conn.Close()
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
	batch_size := FileLimit(512)
	
	// Create a new PortScanner for localhost.
	ps := NewPortScanner("0.0.0.0", batch_size)

	// Start scanning all the ports on localhost.
	ps.Start(1, 65535, 1000*time.Millisecond)
}
