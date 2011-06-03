-module(erlflashpol_sup).

-behaviour(supervisor).

-export([start_link/2]).

-export([init/1]).

start_link(Port, Filename) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Port, Filename]).

init([Port, Filename]) ->
    Children =
        [{erlflashpol_acceptor,
          {erlflashpol_acceptor, start_link, [Port]},
          permanent, 5000, worker, [erlflashpol_acceptor]},
         {erlflashpol_policy_server,
          {erlflashpol_policy_server, start_link, [Filename]},
          permanent, brutal_kill, worker, [erlflashpol_policy_server]},
         {erlflashpol_server_sup,
          {erlflashpol_server_sup, start_link, []},
          permanent, 5000, supervisor, [erlflashpol_server_sup]}],
    {ok, {{one_for_all, 5, 10}, Children}}.
