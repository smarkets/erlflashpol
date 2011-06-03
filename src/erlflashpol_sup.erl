-module(erlflashpol_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(LISTEN_PORT, 8843). % TODO: config

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Children =
        [{erlflashpol_acceptor,
          {erlflashpol_acceptor, start_link, [?LISTEN_PORT]},
          permanent, 5000, worker, [erlflashpol_acceptor]},
         {erlflashpol_server_sup,
          {erlflashpol_server_sup, start_link, []},
          permanent, 5000, supervisor, [erlflashpol_server_sup]}],
    {ok, {{one_for_all, 5, 10}, Children}}.
