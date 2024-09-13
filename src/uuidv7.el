(require 'cl-lib)

(defun uuidv7 ()
  "Generates an array representing the bytes of an UUIDv7 label."
  (let* ((timestamp (car (time-convert (current-time) 1000)))
         (timestamp-bytes
          (cl-loop for i from 5 downto 0
                   collect (logand (ash timestamp (* i -8)) #xFF)))
         (uuid (make-vector 16 0)))

    (cl-loop for i below 16 do
	     (aset uuid i
		   (if (< i 6)
		       (nth i timestamp-bytes)
		   (random 256))))
    
    (aset uuid 6 (logior (logand (elt uuid 6) #x0F) #x70))
    (aset uuid 8 (logior (logand (elt uuid 8) #x3F) #x80))

    uuid))

(defun bytes-to-hexstring (bytes)
  "Converts a vector of bytes into a hexadecimal string."
  (cl-loop for byte across bytes
           concat (format "%02x" byte)))

(let ((uuid-bytes (uuidv7)))
  (message "%s" (bytes-to-hexstring uuid-bytes)))
