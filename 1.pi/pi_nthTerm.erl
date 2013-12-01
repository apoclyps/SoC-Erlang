-module(pi_nthTerm).
-export([pi/0]).
-export([pi/1]).
-export([calculateStop/0]).
-export([calculateStop/1]).

pi() -> pi(1).

pi(N) when N < 1000001 -> 
	%io:fwrite("~3.3.0w #" , [N]),
	(4/N - (4/(N+2))) + pi(N+4);

pi(1000001) -> 000.

calculateStop() ->
		DecimalPlaces =5,
		NthTerm = math:pow(10,DecimalPlaces),
		io:fwrite("~6.6.0w " , [NthTerm]).

calculateStop(DP) when DP > 0 ->
		DecimalPlaces =DP,
		NthTerm = math:pow(10,DecimalPlaces),
		io:fwrite("~6.6.0w " , [NthTerm]).








				                			
