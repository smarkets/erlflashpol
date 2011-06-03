-module(erlflashpol_app).

-behaviour(application).

-export([start/0, start/2, stop/1]).

start() -> application:start(erlflashpol).

start(_StartType, _StartArgs) ->
    erlflashpol_sup:start_link().

stop(_State) -> ok.
