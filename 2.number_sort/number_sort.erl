-module(number_sort).
-export([main/1,unique/2,count/1,count/2,sort/1,readlines/1]).

readlines(FileName) ->
    io:format("~nLoading File : ~p~n", [FileName]),
    {ok, File} = file:read_file(FileName),
    Content = unicode:characters_to_list(File),
    TokenList = string:tokens(string:to_lower(Content), " .,;:!?/>'<{}£$%^&()-=+_[]*#\\\n\r\"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"),
    main(TokenList).

main(L) ->                                  % Main takes in unsorted list
    Seen = [],                              % Initialises Seen to Empty List
    io:format("~nUnsorted List : "),
    T = count(L),
    io:format("~nTotal : ~p~n", [T]),
    UniqueList = unique(L,Seen),            % Creates Uniquelist of Items
    SortedList = sort(UniqueList),          % Sorts UniqueList into SortedList
    io:format("~nSorted List : "),
    U = count(SortedList),
    io:format("~nUnique : ~p~n", [U]).


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

%================================================================================
count(L) ->
    count(L,0).

count([],N)-> N;

count([H|T],N) ->                           %counts items in list using tail recursion
    io:fwrite("~p", [H]), 
    io:fwrite("  "), 
    count(T, N+1).