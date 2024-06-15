uuidv7 <- function() {
  # random bytes
  value <- as.raw(sample(0:255, 16, replace = TRUE))

  # current timestamp in ms
  timestamp <- as.numeric(Sys.time()) * 1000

  # timestamp
  value[1] <- as.raw((timestamp %/% 2^40) %% 256)
  value[2] <- as.raw((timestamp %/% 2^32) %% 256)
  value[3] <- as.raw((timestamp %/% 2^24) %% 256)
  value[4] <- as.raw((timestamp %/% 2^16) %% 256)
  value[5] <- as.raw((timestamp %/% 2^8) %% 256)
  value[6] <- as.raw(timestamp %% 256)

  # version and variant
  value[7] <- as.raw(bitwOr(bitwAnd(as.integer(value[7]), 0x0F), 0x70))
  value[9] <- as.raw(bitwOr(bitwAnd(as.integer(value[9]), 0x3F), 0x80))

  return(value)
}

uuid_val <- uuidv7()
cat(paste(sprintf('%02x', as.integer(uuid_val)), collapse = ''))
