-module(uuidv7).

-export([generate/0, main/0]).

-spec generate() -> binary().
generate() ->
    <<RandA:12, RandB:62, _:6>> = crypto:strong_rand_bytes(10),
    UnixTsMs = os:system_time(millisecond),
    Ver = 2#0111,
    Var = 2#10,
    <<UnixTsMs:48, Ver:4, RandA:12, Var:2, RandB:62>>.

main() ->
    HexUUIDv7 = binary:encode_hex(generate(), lowercase),
    io:format("~s~n", [HexUUIDv7]).
