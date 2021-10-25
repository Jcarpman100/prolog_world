% 
% facts can go here
% Howdy

% here's a graph definition
arc('m','p',8).
arc('q','p',13).
arc('q','m',5).
arc('k','q',3).
arc('k','p',16).
% arc('k','m',7).


% 
% rules can go here
% 

%%pathCost(A, B, cost, true) :-
%	arc(A, B, WhatLength),
%	write(WhatLength + cost), nl, halt(0).

countdown(0) :- write(0).
countdown(X) :- write(X), nl, Y is X - 1, countdown(Y). 

path(A,B,P,C) :- allpaths(A,B,Paths), shortestPath(Paths,[],1000,C,P).

shortestPath([],P,C,BestC,BestP) :- BestC is C, BestP = P.
shortestPath([Head|Paths],P,C,BestC,BestP) :- bestPath(Head,P,C,NewC,NewP), shortestPath(Paths,NewP,NewC,BestC,BestP).


bestPath([Hp,Hc|_],LastP,LastC,C,P) :- Hc < LastC, C is Hc, append([Hp],[],P).
bestPath([Hp,Hc|_],LastP,LastC,C,P) :- Hc =:= LastC, append([Hp],LastP,P), C is Hc.
bestPath([Hp,Hc|_],LastP,LastC,C,P) :- C is LastC, P = LastP.

allpaths(A,B,P) :- findall([Path,C], (pathfinder(A,B,Path,C,[A])), P).

pathfinder(A,B,[B|P],C,P) :- arc(A,B,Cost), C is Cost.
pathfinder(A,B,P,C,V) :- arc(A,D,Cost1), pathfinder(D,B,P,Cost2, [D|V]), C is Cost1 + Cost2.


:-
    % 
    % queries go here
    % 
    get_char(StartNode), % <- puts the commandline argument inside of StartNode
    get_char(EndNode),
    write('path from: '), write(StartNode), write('\n'),
    write('path to: '), write(EndNode), write('\n'),
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % uncomment the next few lines to query your path method
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     path(StartNode, EndNode, Output, Cost),
    write('is: '), write(Output), write('\n'),
    write('Cost: '), write(Cost), write('\n'),
    
    % next few lines are an example of how to query an existing fact
    % (WhatLength is the "output" since StartNode, EndNode, are known)
	
	% pathCost(startNode, endNode, 0, arc(StartNode, EndNode, WhatLength)),
	% path(StartNode, EndNode, X),
	% write(X),
	%(arc(StartNode, EndNode, WhatLength) -> write(WhatLength), write('\n'), halt(0) ; write("No direct path"), write('\n')),
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % comment out these^ lines out when you start coding yourself
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
	% countdown(10),
	
	halt(0),
	
    !. end