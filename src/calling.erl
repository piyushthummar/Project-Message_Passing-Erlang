%%%-------------------------------------------------------------------
%%% @author PIYUSH
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jun 2020 12:54
%%%-------------------------------------------------------------------
-module(calling).
-author("PIYUSH").

%% API
-export([messagePassing/3]).
messagePassing(Sender, Receivers, Master_Process_Id) ->
  iterateList(Sender, Receivers, self()),
  caller(Master_Process_Id, Sender).

iterateList(Sender, Receivers, Process_ID) ->
  lists:foreach(fun(Record) ->
    register(Sender, Process_ID),
    {_,_,MicroSecond} = erlang:now(),
    Process_ID ! {request, Sender, Record, Process_ID, MicroSecond}
                end, Receivers).

caller(Master_Process_Id, Sender_Name) ->
  receive
    {request, Sender, Current_Receiver, Process_ID, MicroSecond} ->
      timer:sleep(100),
      Master_Process_Id ! {intro_Message,Sender,Current_Receiver,MicroSecond},
      Process_ID ! {response, Master_Process_Id, Sender, Current_Receiver, MicroSecond};

    {response,Master_Process_Id, Sender, Receiver, Timestamp} ->
      timer:sleep(100),
      Master_Process_Id ! {reply_Message, Sender, Receiver, Timestamp}

  after
    5000 ->
      io:format("Process ~w has received no calls for 5 seconds, ending...", [Sender_Name])
  end, caller(Master_Process_Id, Sender_Name).