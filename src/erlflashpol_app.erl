-module(erlflashpol_app).

-behaviour(application).

-export([start/0, start/2, stop/1]).

start() -> application:start(erlflashpol).

start(_StartType, _StartArgs) ->
    Config =
        case application:get_all_env(erlflashpol) of
            undefined -> [];
            L -> L
        end,
    ListenIp = proplists:get_value(listen_ip, Config, any),
    ListenPort = proplists:get_value(listen_port, Config, 8843),
    PolicyFile = proplists:get_value(policy_file, Config, liberal),
    erlflashpol_sup:start_link(ListenIp, ListenPort, PolicyFile).

stop(_State) -> ok.
