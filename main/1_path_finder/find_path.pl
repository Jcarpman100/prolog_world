% 
% facts can go here
% Howdy
% This took me a hot minute, but it works all nice now

% here's a graph definition
arc('m','p',8).
arc('q','p',13).
arc('q','m',5).
arc('k','q',3).

% extra facts for testing.
% arc('k','p',16).
% arc('k','m',7).


% 
% rules can go here
% 

%%pathCost(A, B, cost, true) :-
%	arc(A, B, WhatLength),
%	write(WhatLength + cost), nl, halt(0).

% Unneeded function, made to test recursion.
countdown(0) :- write(0).
countdown(X) :- write(X), nl, Y is X - 1, countdown(Y). 

% Driver function, calls the pathfinder functions to locate all paths and the shortest path function to select the best.
path(A,B,P,C) :- allpaths(A,B,Paths), shortestPath(Paths,[],1000,C,P).

% Recursively finds the best path by checking if the head is better than the current best path.
shortestPath([],P,C,BestC,BestP) :- BestC is C, BestP = P.
shortestPath([Head|Paths],P,C,BestC,BestP) :- bestPath(Head,P,C,NewC,NewP), shortestPath(Paths,NewP,NewC,BestC,BestP).

% Determines if this path is better, equal, or worse than the current best.
bestPath([Hp,Hc|_],_,LastC,C,P) :- Hc < LastC, C is Hc, append([Hp],[],P). 					% If this path is better, replace the path and cost,
bestPath([Hp,Hc|_],LastP,LastC,C,P) :- Hc =:= LastC, append([Hp],LastP,P), C is Hc. 		% If this path is equal, append it to the current best.
bestPath([_,_|_],LastP,LastC,C,P) :- C is LastC, P = LastP. 								% If this path is worse, do nothing.

% uses the findall function on the pathfinder function in order to locate every possible path.
allpaths(A,B,P) :- findall([Path,C], (pathfinder(A,B,Path,C,[A])), P).

% pathfinding function, uses matching to determine a valid path.
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