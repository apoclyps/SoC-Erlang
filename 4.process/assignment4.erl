-module(assignment4).
-export([load/1,collectResults/1,count/3,go/1,reciever/1,collector/1]).

% Load Function
% Takes File name as parameter
% Reads File and splits into 20 segments
% Calls Main to call 20 processes
% Prints result of all 20 processes combined (a-z) - Not Done
%=======================================================================
load(F)->
io:format("~nLoading File : ~p~n", [F]),
{ok, File} = file:read_file(F),
   Content=unicode:characters_to_list(File),
   List = string:tokens(string:to_lower(Content), ".,;:!?/>'<{}£$%^&()-=+_[]*#\\\n\r\""),
   Length=round(length(List)/20),
   Ls=string:to_lower(List),
   Segments=split(Ls,Length),
   io:fwrite("Loaded and Split~n"),
   EL = [],
   CollectorID = spawn(para, collector, [EL]),
  % CollectorID ! {start, 0, []} ,
   io:format(" Spawned : Collector \t Pid : ~p~n",[CollectorID]),
   timer:sleep(000),
   Result = main(Segments,1,CollectorID),
   Result.


 % Counts the number of splits
 %=====================================================================================
countsplit([],R)->R;
countsplit([H|T],R)->
 receive 
 {start, N, Result} -> 
   io:fwrite(" Processing Message ~p~n",[H]),
   R2=join(R,Result),
   countsplit(T,R2);
 Msg ->
      io:format("~p Collector received unexpected message ~n", [Msg]),
      collector(R)
end.

%joins the number of splits
%=====================================================================================
join([],[])->[];
join([],R)->R;
join([H1 |T1],[H2|T2])->
   {C,N}=H1,
   {C1,N1}=H2,
   [{C1,N+N1}]++join(T1,T2).


% Collects results
collector(ResultsList) ->
  receive
    {start, N, CountedList} -> 
    Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
    io:format("Collector : Recieved Message : Process : ~p ~n~p~n",[N, CountedList]),

    % Reduction function
    ResultsList2 =  CountedList ++ ResultsList,
    %RSL = reducer(Alph, ResultsList2,0),
    RSL = countsplit(CountedList, ResultsList),
    io:fwrite("Results = ~p~n",[RSL]),
   % timer:sleep(5000),
    collector(RSL);
    Msg ->
      io:format("~p Collector received unexpected message ~n", [Msg]),
      collector(ResultsList)
  end.


%Alpha / Results
reducer([H|T], Results,N) ->
    wordCount(H, Results, 0),
    reducer(T, Results, N+1);
reducer([], _, N) -> N.

% Word count takes the unique word, and searches the origional list
% counts occurances of that word
wordCount(Char,[H|T],N) ->
    {C,Val} = H,
    case Char == C of           % checks to see if H is in Seen List
        true -> wordCount(Char, T, N+Val);              % if true, N_Seen = Seen List
        false -> wordCount(Char, T, N)       % if false, head appends Seen List.
    end;
    
wordCount(Char,[],N) -> 
    io:fwrite("~p   \t:  ~p ~n", [N,Char]).
   % io:format(whereis(my_output_file), "~p   \t: ~p ~n", [N,Word]).

















% Main
% Calls spawner 20 times with file segment to create a process for that segment
%=======================================================================
main([H|T],N,Cid) ->
  spawner(H,N,Cid),
  io:fwrite("~nStarting Process # ~p \t using Segment :~p ~n",[N,H]),
  main(T,N+1,Cid);
% Main Stop Function
main([], _,_) -> ok.

% Spawner
% Takes segment of words, and N to identify the process (1-20)
% Creates process and sends a message to start process
%
%=======================================================================
spawner(WordList,N,Cid) ->
  SeenList = [],
  Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
 % Self = self(),
 Self = Cid,
  Processes = [spawn_link(fun() -> 
          process(Word, Self,N,Alph) end) || Word <- WordList],
  [ Process ! {start, Self, SeenList,N} || Process <- Processes].
  %collectResults(WordList).

% Process
% Takes the segment of the file
% Recieves message to start process and calls run_process with parameters
%=======================================================================
process(Segment, Pid,N,Alph) ->
  receive
    {start, Pid, CountedList,N} -> run_process(Segment, Pid, CountedList,N,Alph);
    Msg ->
      io:format("~p received unexpected message ~p~n", [Segment, Msg]),
      process(Segment, Pid,N,Alph)
  end.

% Run Process -  Worker Function
% Takes in Segment, Process ID, CounterList, N , Alpha list
% Counts occurances of char in segment using Head from Alpha
%=======================================================================
run_process(Segment, Pid, CountedList, N,[H|T])  ->
      % NCL = CountedList ++ [H,1],
      %Num = go([H|T]),
      % io:fwrite(" Num = ~p~n",[Num]),
      % {H, _} = Alpha,
      Num=count(H,Segment,0),
  %Uncomment   % io:format("~p~n",[H]),
  % Uncommetn   % io:fwrite("  Rid ~p\t char : ~w x~p \t Pid : ~p ~n", [N,H,Num,Pid]),
      % io:fwrite("Char ~p list ~p~n", [H,List]),
      % Reciever ! {H,N},
      CountedList2=CountedList++[{[H],Num}],
      run_process(Segment, Pid, CountedList2,N,T);

% Run Process - Stop Function
run_process(_, Pid, CountedList,N,[]) ->
  io:fwrite("Completed Process # ~p~n",[N]),
  % Completed Results
  %io:fwrite("Counted List = ~n~p~n",[CountedList]),
  Pid ! {start, N, CountedList}.


% Output
%=======================================================================
collectResults([]) -> ok;
collectResults(Processes) ->
  receive
    {stop, Segment, CountedList, N} ->
      io:format("~p stops at ~p (~p)~n", [Segment, CountedList, N]),
      collectResults(Processes -- [Segment]);
    Msg ->
      io:format("collect results received unexpected message ~p~n", [Msg]),
      collectResults(Processes)
  after 350 -> timeout
  end.


%=======================================================================
split([],_)->[];

split(List,Length)->
   S1=string:substr(List,1,Length),
   case length(List) > Length of
      true->S2=string:substr(List,Length+1,length(List));
      false->S2=[]
   end,
   [S1]++split(S2,Length).


%=========================================================================================
go(L)->
   Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
   Reciever = spawn(para,reciever,[[]]),
   recursivego(Alph,L,[],Reciever).

%=========================================================================================
recursivego([H|T],L,Result,Reciever)->
   N=count(H,L,0),
   Reciever ! {H,N},
   Result2=Result++[{[H],N}],
   recursivego(T,L,Result2,Reciever);
recursivego([],_,Result,_)->Result.

%  Counts occurances of charachter in list
%=========================================================================================
count(_, [],N)->N;
count(Ch, [H|T],N) ->
   case Ch==H of
   true-> count(Ch,T,N+1);
   false -> count(Ch,T,N)
end.

%Joiner Function
%=========================================================================================
reciever(RL) ->
   %display(RL),
    receive
   {H, N} ->
       %io:format("~w : recieved [~w]~n", [H, N]),
       RL2=RL++[{[H],N}],
       %display(RL2),
       reciever(RL2);
   exit ->
       ok
    end.