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
%%              (Reference: https://sites.google.com/site/gettingalongwitherlang/home/file-i-o/file-consult)
                {Data, CallsData} = file:consult("src/calls.txt"),
                io:format("~n ** Calls to be made ** ~n",[]),
                Master_Process_id = self(),
                List_of_Data = maps:from_list(CallsData),
                [io:format("~w: ~w ~n",[Sender,List_of_Receivers]) || {Sender, List_of_Receivers} <- CallsData],
                maps:fold(fun(Key, Value, ok) ->
                  Process_ID = spawn(calling, messagePassing, [Key,Value,Master_Process_id])
                          end,ok, List_of_Data),
            print_Conversation_Message(Master_Process_id). %% 0

%% Print Initial and Reply message...
print_Conversation_Message(Master_Process_id) ->
  receive
    {intro_Message, Sender, Receiver, Timestamp} ->
      io:fwrite("~r received intro message from ~s [~t] ~n",[Sender, Receiver, Timestamp]),
      print_Conversation_Message(Master_Process_id); %%Counter+1
    {reply_Message, Sender, Receiver, Timestamp} ->
      io:fwrite("~r received reply message from ~s [~t] ~n",[Sender, Receiver, Timestamp]),
      print_Conversation_Message(Master_Process_id) %%Counter+1
  after
    10000 -> io:fwrite("Master has received no replies for 10 seconds, ending...~n",[])
  end.
