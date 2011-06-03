-module(erlflashpol_server_sup).

-behaviour(supervisor).

-export([start_link/0, start_child/1]).

-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Socket) ->
    error_logger:info_msg("Starting a child..~n"),
    supervisor:start_child(?MODULE, [Socket]).

init([]) ->
    Children =
        [{undefined,
          {erlflashpol_server, start_link, []},
          temporary, brutal_kill, worker, [erlflashpol_server]}],
    {ok, {{simple_one_for_one, 5, 10}, Children}}.
