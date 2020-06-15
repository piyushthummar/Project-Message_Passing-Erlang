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
-export([start/0, print_Conversation_Message/1]).
start() ->
%%              (Reference: https://sites.google.com/site/gettingalongwitherlang/home/file-i-o/file-consult)
                {Data, CallsData} = file:consult("src/calls.txt"),
                io:format("~n ** Calls to be made ** ~n",[]),
                Master_Process_id = self(),
                List_of_Data = maps:from_list(CallsData),
                [io:format("~w: ~w ~n",[Sender,List_of_Receivers]) || {Sender, List_of_Receivers} <- CallsData],
                io:format("~n",[]),
                lists:foreach(fun(Record) ->
                                            {Sender,Receivers} = Record,
                                            Process_ID = spawn(calling, messagePassing, [Sender,Receivers,Master_Process_id])
                                            ,register(Sender, Process_ID)
%%                                            ,io:format("~w: ~w -> ~w ~n",[Sender,Receivers, Process_ID])
                              end,
                              CallsData),
%%                maps:fold(fun(Key, Value) ->
%%                  Process_ID = spawn(calling, messagePassing, [Key,Value,Master_Process_id])
%%                          end, List_of_Data),
            print_Conversation_Message(Master_Process_id).
%%            io:fwrite("Done!!",[]). %% 0

%% Print Initial and Reply message...
print_Conversation_Message(Master_Process_id) ->
  receive
    {intro_Message, Sender, Receiver, Timestamp} ->
      io:fwrite("~p received intro message from ~p [~p] ~n",[Receiver, Sender, Timestamp]),
      print_Conversation_Message(Master_Process_id); %%Counter+1
    {reply_Message, Sender, Receiver, Timestamp} ->
      io:fwrite("~p received reply message from ~p [~p] ~n",[Sender, Receiver, Timestamp]),
      print_Conversation_Message(Master_Process_id) %%Counter+1
  after
    10000 ->
      io:fwrite("~nMaster has received no replies for 10 seconds, ending...~n",[])
  end.
