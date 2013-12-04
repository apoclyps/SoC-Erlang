-module (ccharcount).
-export ([load/1,count/3,go/1,join/2,split/2]).

load(F)->
{ok, Bin} = file:read_file(F),
   List=binary_to_list(Bin),
   Length=round(length(List)/20),
   Ls=string:to_lower(List),
   Sl=split(Ls,Length),
   io:fwrite("Loaded and Split~n"),
   Result=countsplit(Sl,[]),
Result.

% Splits the file into 20 segments
%=====================================================================================
split([],_)->[];

split(List,Length)->
S1=string:substr(List,1,Length),
case length(List) > Length of
   true->S2=string:substr(List,Length+1,length(List));
   false->S2=[]
end,
[S1]++split(S2,Length).
 
 % Counts the number of splits
 %=====================================================================================
countsplit([],R)->R;
countsplit([H|T],R)->
 Result=go(H),
 R2=join(R,Result),
 countsplit(T,R2).

%joins the number of splits
%=====================================================================================
join([],[])->[];
join([],R)->R;
join([H1 |T1],[H2|T2])->
   {C,N}=H1,
   {C1,N1}=H2,
   [{C1,N+N1}]++join(T1,T2).


% Go starts the recursion
%===================================================================================
go(L)->
   Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
   rgo(Alph,L,[]).

rgo([H|T],L,Result)->
   N=count(H,L,0),
   Result2=Result++[{[H],N}],
   rgo(T,L,Result2);

rgo([],_,Result)->Result.

count(_, [],N)->N;
count(Ch, [H|T],N) ->
   case Ch==H of
   true-> count(Ch,T,N+1);
   false -> count(Ch,T,N)
end.