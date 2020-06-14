%%%-------------------------------------------------------------------
%%% @author PIYUSH
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jun 2020 10:53
%%%-------------------------------------------------------------------
-module(exchange).
-author("PIYUSH").

%% API
-export([start/0]).
start() ->
%%                io:fwrite("Hi this is piyush\n"),
%%                CallsData = file:consult("src/calls.txt"),
%%                Calling_List = element(2, CallsData),

%%              (Reference: https://sites.google.com/site/gettingalongwitherlang/home/file-i-o/file-consult)
                {Data, CallsData} = file:consult("src/calls.txt"),
                io:format("~n ** Calls to be made ** ~n",[]),
%%                io:fwrite("~s~n", [Data]),

%%                io:fwrite("~s~n",[CallsData]),
%%
%%              (Reference : https://stackoverflow.com/questions/16111542/understanding-and-using-foreach-in-erlang)
                lists:foreach(fun(Tuple) ->
                                            {Sender,Receiver_List} = Tuple,
                                            io:format("~w: ~w ~n",[Sender,Receiver_List])

                              end,
                              CallsData),

                io:fwrite("~n",[]).
