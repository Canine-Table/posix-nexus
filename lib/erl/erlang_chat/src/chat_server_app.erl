-module(chat_server_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    {ok, spawn(fun() -> loop() end)}.

stop(_State) ->
    ok.

% Simple loop to keep the process alive
loop() ->
    receive
        stop -> ok
    end.
