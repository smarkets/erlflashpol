-module(erlflashpol_app).

-behaviour(application).

-export([start/0, start/2, stop/1]).

start() -> application:start(erlflashpol).

start(_StartType, _StartArgs) ->
    % Default to port 8843 and liberal policy file
    erlflashpol_sup:start_link(any, 8843, liberal).

stop(_State) -> ok.
