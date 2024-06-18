(ns uuidv7
  (:require [clojure.string :as str])
  (:import (java.security SecureRandom)))

(defn gen-uuid-v7
  []
  (let [rand-array (byte-array 10)]
    (.nextBytes (SecureRandom.) rand-array)
    (concat
      ;; timestamp
      (map byte (.toByteArray (biginteger (System/currentTimeMillis))))
      ;; version
      [(bit-or (bit-and (first rand-array) 0x0F) 0x70)]
      [(nth rand-array 1)]
      ;; variant
      [(bit-or (bit-and (nth rand-array 2) 0x3F) 0x80)]
      (drop 3 rand-array))))

(defn uuid-to-string
  [uuid-bytes]
  (let [uuid-seq (map #(str/lower-case (format "%02X" %)) uuid-bytes)]
    (str/join "-" (map #(apply str %)
                       (let [indices (reductions + 0 [4 2 2 2 6])]
                         (map #(subvec (vec uuid-seq) %1 %2) (butlast indices) (rest indices)))))))

(def uuid-bytes (gen-uuid-v7))
(println (uuid-to-string uuid-bytes))
