package main

import (
	"crypto/rand"
	"fmt"
	"math/big"
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
	timestamp := big.NewInt(time.Now().UnixMilli())

	// timestamp
	timestamp.FillBytes(value[0:6])

	// version and variant
	value[6] = (value[6] & 0x0F) | 0x70
	value[8] = (value[8] & 0x3F) | 0x80

	return value, nil
}

func main() {
	uuidVal, _ := uuidv7()
	fmt.Printf("%x\n", uuidVal)
}
