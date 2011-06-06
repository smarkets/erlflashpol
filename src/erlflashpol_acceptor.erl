-module(erlflashpol_acceptor).

-export([start_link/2, init/2, acceptor/1]).

-define(TCP_OPTIONS,
        [binary,
         {active, false},
         {reuseaddr, true},
         {backlog, 1024},
         {packet, raw}]).

start_link(ListenIp, Port) ->
    Pid = proc_lib:spawn_link(?MODULE, init, [ListenIp, Port]),
    {ok, Pid}.

init(ListenIp, Port) ->
    error_logger:info_msg("Starting flash policy acceptor listening on ~p, port ~w~n", [ListenIp, Port]),
    ParsedIp =
        case ListenIp of
            any -> any;
            ListenIp when is_tuple(ListenIp) -> ListenIp;
            ListenIp when is_list(ListenIp) ->
                {ok, IpTuple} = inet_parse:address(ListenIp),
                IpTuple
        end,
    {ok, LSocket} = gen_tcp:listen(Port, [{ip, ParsedIp}|?TCP_OPTIONS]),
    acceptor(LSocket).

acceptor(LSocket) ->
    {ok, Socket} = gen_tcp:accept(LSocket),
    erlflashpol_server_sup:start_child(Socket),
    ?MODULE:acceptor(LSocket).
