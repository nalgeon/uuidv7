#lang typed/racket/base

(provide uuidv7-generate uuidv7-string)

(require racket/math)
(require/typed racket/random
               [crypto-random-bytes (-> Integer Bytes)])
(require/typed racket/unsafe/ops
               [unsafe-bytes->immutable-bytes! (-> Bytes Bytes)]
               [unsafe-string->immutable-string! (-> String String)])

;;; Return a v7 UUID as a 16-byte binary blob.
(: uuidv7-generate (-> Bytes))
(define (uuidv7-generate)
  (define uuid (make-bytes 16))
  (define timestamp (exact-truncate (current-inexact-milliseconds)))
  (bytes-set! uuid 0 (bitwise-bit-field timestamp 40 48))
  (bytes-set! uuid 1 (bitwise-bit-field timestamp 32 40))
  (bytes-set! uuid 2 (bitwise-bit-field timestamp 24 32))
  (bytes-set! uuid 3 (bitwise-bit-field timestamp 16 24))
  (bytes-set! uuid 4 (bitwise-bit-field timestamp 8 16))
  (bytes-set! uuid 5 (bitwise-and timestamp #xFF))
  (bytes-copy! uuid 6 (crypto-random-bytes 10))
  (bytes-set! uuid 6 (bitwise-ior (bitwise-and (bytes-ref uuid 6) #x0F) #x70))
  (bytes-set! uuid 8 (bitwise-ior (bitwise-and (bytes-ref uuid 8) #x3F) #x80))
  (unsafe-bytes->immutable-bytes! uuid))

(define hex-chars '#(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\a #\b #\c #\d #\e #\f))

(: bytes->hex! : Bytes Index Index String Index -> Void)
(define (bytes->hex! bs start end dest dest-start)
  (for ([b (in-bytes bs start end)]
        [i (in-range dest-start (+ dest-start (* (- end start) 2)) 2)])
    (string-set! dest i (vector-ref hex-chars (arithmetic-shift (bitwise-and b #xF0) -4)))
    (string-set! dest (add1 i) (vector-ref hex-chars (bitwise-and b #x0F)))))

;;; Convert a v7 UUID blob into a human-readable string. Returns a newly-generated UUID if not given one.
(: uuidv7-string (->* () (Bytes) String))
(define (uuidv7-string [uuid (uuidv7-generate)])
  (define s (make-string 36 #\-))
  (bytes->hex! uuid 0 4 s 0)
  (bytes->hex! uuid 4 6 s 9)
  (bytes->hex! uuid 6 8 s 14)
  (bytes->hex! uuid 8 10 s 19)
  (bytes->hex! uuid 10 16 s 24)
  (unsafe-string->immutable-string! s))

(module+ main
  (displayln (uuidv7-string)))
