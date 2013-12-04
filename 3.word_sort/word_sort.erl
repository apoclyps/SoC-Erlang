%%%----------------------------------------------------------------------
%%% File    : word_sort.erl
%%% Author  : Claes Wikstrom [klacke@bluetail.com]
%%% Purpose : Count the x chars in a file
%%% Created : 20 Oct 1998 by Claes Wikstrom [klacke@bluetail.com]
%%%----------------------------------------------------------------------
-module(word_sort).
-author('kyle90adam@hotmail.com').
-export([main/1]).
-export([unique/2]).
-export([sort/1]).
-export([readlines/1]).
-export([wordCount/3]).

readlines(FileName) ->
    io:format("~nLoading File : ~p~n", [FileName]),
    {ok, File} = file:read_file(FileName),
    Content = unicode:characters_to_list(File),
    TokenList = string:tokens(string:to_lower(Content), " .,;:!?~/>'<{}£$%^&()@-=+_[]*#\\\n\r\"0123456789"),
    main(TokenList).

main(TokenList) ->                                  % Main takes in unsorted list
    % Scan through the text file and find a list of unique words
    UniqueList = unique(TokenList,[]),            % Creates Uniquelist of Items
    io:format("~nSorted List : ~n"),
    SortedList = sort(UniqueList),          % Sorts UniqueList into SortedList
    io:format("~nSorted List : "),
    
    io:format("~nWriting to file - This may take 1-2 minutes~n"),
    {ok, F} = file:open("unique_words.txt", [write]),
    register(my_output_file, F),
    U = wordCounter(SortedList,TokenList,0),
    io:format("~nUnique : ~p~n", [U]),
    io:fwrite("~nComplete~n").

wordCounter([H|T],TokenList,N) ->
    %io:fwrite("~p \t:  ~p~n", [H,T]),
    wordCount(H, TokenList, 0),
    wordCounter(T,TokenList,N+1);

wordCounter([], _, N) -> N.

% Word count takes the unique word, and searches the origional list
% counts occurances of that word
wordCount(Word,[H|T],N) ->
    case Word == H of           % checks to see if H is in Seen List
        true -> wordCount(Word, T, N+1);              % if true, N_Seen = Seen List
        false -> wordCount(Word, T, N)       % if false, head appends Seen List.
    end;
    
wordCount(Word,[],N) -> 
    io:fwrite("~p   \t:  ~p ~n", [N,Word]),
    io:format(whereis(my_output_file), "~p   \t: ~p ~n", [N,Word]).
    
%=================================================================================

unique([H|T],Seen) ->                       % Accepts List of numbers and Seen List
    case lists:member(H, Seen) of           % checks to see if H is in Seen List
        true -> N_Seen = Seen;              % if true, N_Seen = Seen List
        false -> N_Seen = Seen ++ [H]       % if false, head appends Seen List.
    end,
    unique(T,N_Seen);                       % calls uniques with Tail and Seen List.

%=================================================================================

unique([],Seen) -> Seen.                    % Stop Function

sort([Pivot|T]) ->                          %Quicksort taking a List as a parameter
   	sort([ X || X <- T, X < Pivot]) ++ 	    % list of all elements in T which are less than Pivot
    [Pivot] ++							    % pivot 
    sort([ X || X <- T, X >= Pivot]);

sort([]) -> [].                             %Quicksort stop function
