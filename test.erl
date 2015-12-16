-module(test).

-export([run/0]).

run() ->
    Cmd = "ls",
    Port = open_port({spawn, Cmd}, [binary, exit_status]),
    do_read(Port).

do_read(Port) ->
    receive
        {Port, {data, _}} ->
            do_read(Port);
        {Port, {exit_status, 0}} ->
            io:format("SUCCESS~n");
        E ->
            io:format("Something: ~p~n", [E])
      after 5000 ->
        io:format("FAILED~n")
    end.
