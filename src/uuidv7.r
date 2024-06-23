uuidv7 <- function() {
  # Initialise vector with current timestamp & random numbers
  value = numeric(16)
  value[1:6] <- as.numeric(Sys.time()) * 1000
  value[7:16] <- sample(0:255, 10L, replace = TRUE)
 
  # timestamp
  value[1:6] <- value[1:6] %/% 2^c(40, 32, 24, 16, 8, 1) %% 256L

  # version and variant
  value[7] <- bitwOr(bitwAnd(value[7], 0x0F), 0x70)
  value[9] <- bitwOr(bitwAnd(value[9], 0x3F), 0x80)
  as.raw(value)
}

uuid_val <- uuidv7()
cat(paste(sprintf('%02x', as.integer(uuid_val)), collapse = ''))
