;; UUIDv7 implementation in Clojure.
;; License: Public Domain.

(ns uuidv7
  (:import (java.security SecureRandom)
           (java.util UUID)))

(defonce ^SecureRandom rng (SecureRandom.))

(defn uuid-v7 []
  (let [ts (System/currentTimeMillis)
        ;; timestamp (48 bits)
        hi-bits (bit-or (bit-shift-left ts 16)
                        ;; version + rand_a (12 bits)
                        (bit-or 0x7000 (bit-and (.nextLong rng) 0x0FFF)))
        ;; variant (10xx) + rand_b (62 bits)
        lo-bits (bit-or (bit-shift-left 2 62)
                        (bit-and (.nextLong rng) 0x3FFFFFFFFFFFFFFF))]
    (UUID. hi-bits lo-bits)))

(println (str (uuid-v7)))
