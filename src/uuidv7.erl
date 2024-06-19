-module(uuidv7).

-export([generate/0, main/1]).

-spec generate() -> binary().
generate() ->
    <<RandA:12, RandB:62, _:6>> = crypto:strong_rand_bytes(10),
    UnixTsMs = os:system_time(millisecond),
    Ver = 2#0111,
    Var = 2#10,
    <<UnixTsMs:48, Ver:4, RandA:12, Var:2, RandB:62>>.

main(_) ->
    UUIDv7 = generate(),
    %% note: if you use an erlang release newer than OTP23,
    %%       there is binary:encode_hex/1,2
    io:format("~s~n", [[io_lib:format("~2.16.0b",[X]) || <<X:8>> <= UUIDv7]]).
