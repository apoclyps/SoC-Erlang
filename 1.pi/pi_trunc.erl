-module(pi_trunc).
-export([pi/0,pi/3]).
-export([trunc/2]).

pi() -> pi(1,0,1).

pi(_, Pi, 0.00) ->	
	io_lib:format("~w", [trunc(Pi,5)]);

pi(N, O, _) ->
	    C =  O + (4/N - 4/(N+2)),
		D = trunc(C,11) - trunc(O,11),
		pi(N+4,C,D).

trunc(F, N) ->
    Prec = math:pow(10, N),
    trunc(F*Prec)/Prec.    			
