package main

import (
	"crypto/rand"
	"fmt"
	"time"
)

func uuidv7() ([16]byte, error) {
	// random bytes
	var value [16]byte
	_, err := rand.Read(value[:])
	if err != nil {
		return value, err
	}

	// current timestamp in ms
	timestamp := time.Now().UnixMilli()

	// timestamp
	value[0] = byte(timestamp >> 40)
	value[1] = byte(timestamp >> 32)
	value[2] = byte(timestamp >> 24)
	value[3] = byte(timestamp >> 16)
	value[4] = byte(timestamp >> 8)
	value[5] = byte(timestamp)

	// version and variant
	value[6] = (value[6] & 0x0F) | 0x70
	value[8] = (value[8] & 0x3F) | 0x80

	return value, nil
}

func main() {
	uuidVal, err := uuidv7()
	if err != nil {
		panic(err)
	}
	for _, byte := range uuidVal {
		fmt.Printf("%02x", byte)
	}
	fmt.Println()
}
