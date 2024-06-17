(ns uuidv7
  (:require [clojure.string :as str])
  (:import (java.security SecureRandom)))

(defn gen-uuid-v7
  []
  (let [rand-array (byte-array 10)
        _ (.nextBytes (SecureRandom.) rand-array)
        rand-seq (map byte rand-array)
        uuid-seq (map #(str/lower-case (format "%02X" %))
                      (concat
                        ;; timestamp
                        (map byte (.toByteArray (biginteger (bit-and (System/currentTimeMillis) 0xFFFFFFFFFFFF))))
                        ;; ver
                        (list (bit-or (bit-and (first rand-seq) 0x0F) 0x70))
                        (list (second rand-seq))
                        ;; var
                        (list (bit-or (bit-and (first (drop 2 rand-seq)) 2r00111111) 2r10000000))
                        (drop 3 rand-seq)))]
    (str/join "-" (map #(apply str %)
                       (let [indices (reductions + 0 [4 2 2 2 6])]
                         (map #(subvec (vec uuid-seq) %1 %2) (butlast indices) (rest indices)))))))
