use Bitwise

defmodule UUIDv7 do
  def generate do
    # random bytes
    value = :crypto.strong_rand_bytes(16) |> :binary.bin_to_list()

    # current timestamp in ms
    timestamp = :os.system_time(:millisecond)

    # timestamp
    value = List.replace_at(value, 0, (timestamp >>> 40) &&& 0xFF)
    value = List.replace_at(value, 1, (timestamp >>> 32) &&& 0xFF)
    value = List.replace_at(value, 2, (timestamp >>> 24) &&& 0xFF)
    value = List.replace_at(value, 3, (timestamp >>> 16) &&& 0xFF)
    value = List.replace_at(value, 4, (timestamp >>> 8) &&& 0xFF)
    value = List.replace_at(value, 5, timestamp &&& 0xFF)

    # timestamp
    value = List.replace_at(value, 6, (Enum.at(value, 6) &&& 0x0F) ||| 0x70)
    value = List.replace_at(value, 8, (Enum.at(value, 8) &&& 0x3F) ||| 0x80)

    value
  end
end

uuid_val = UUIDv7.generate()
Enum.map(uuid_val, &Integer.to_string(&1, 16))
|> Enum.map(&String.pad_leading(&1, 2, "0"))
|> Enum.join()
|> IO.puts()
