local function uuidv7()
    -- random bytes
    local value = {}
    for i = 1, 16 do
        value[i] = math.random(0, 255)
    end

    -- current timestamp in ms
    local timestamp = os.time() * 1000

    -- timestamp
    value[1] = (timestamp >> 40) & 0xFF
    value[2] = (timestamp >> 32) & 0xFF
    value[3] = (timestamp >> 24) & 0xFF
    value[4] = (timestamp >> 16) & 0xFF
    value[5] = (timestamp >> 8) & 0xFF
    value[6] = timestamp & 0xFF

    -- version and variant
    value[7] = (value[7] & 0x0F) | 0x70
    value[9] = (value[9] & 0x3F) | 0x80

    return value
end

local uuid_val = uuidv7()
for i = 1, #uuid_val do
    io.write(string.format('%02x', uuid_val[i]))
end
print()
