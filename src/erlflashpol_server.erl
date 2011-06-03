-module(erlflashpol_server).

-export([start_link/1, loop/1]).

-define(GENERIC_POLICY_FILE,
        "<?xml version=\"1.0\"?>"
        "<!DOCTYPE cross-domain-policy SYSTEM \"/xml/dtds/cross-domain-policy.dtd\">"
        "<cross-domain-policy>"
        "    <allow-access-from domain=\"*\" to-ports=\"*\" />"
        "</cross-domain-policy>\0").

start_link(Socket) ->
    Pid = spawn_link(?MODULE, loop, [Socket]),
    {ok, Pid}.

loop(Socket) ->
    case gen_tcp:recv(Socket, 22) of
        {ok, <<"<policy-file-request/>">>} ->
            {ok, File} = erlflashpol_policy_server:policy_file(),
            gen_tcp:send(Socket, File),
            ?MODULE:loop(Socket);
        {ok, _Data} ->
            ok = gen_tcp:close(Socket);
        {error, closed} ->
            ok
    end.
