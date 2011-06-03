-module(erlflashpol_acceptor).

-export([start_link/1, init/1, acceptor/1]).

-define(TCP_OPTIONS,
        [binary,
         {active, false},
         {reuseaddr, true},
         {backlog, 1024},
         {packet, raw}]).

start_link(Port) ->
    Pid = proc_lib:spawn_link(?MODULE, init, [Port]),
    {ok, Pid}.

init(Port) ->
    error_logger:info_msg("Starting flash policy acceptor on port ~w~n", [Port]),
    {ok, LSocket} = gen_tcp:listen(Port, ?TCP_OPTIONS),
    acceptor(LSocket).

acceptor(LSocket) ->
    {ok, Socket} = gen_tcp:accept(LSocket),
    erlflashpol_server_sup:start_child(Socket),
    ?MODULE:acceptor(LSocket).
