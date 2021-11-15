% my_agent.pl

%   this procedure requires the external definition of two procedures:
%
%     init_agent: called after new world is initialized.  should perform
%                 any needed agent initialization.
%
%     run_agent(percept,action): given the current percept, this procedure
%                 should return an appropriate action, which is then
%                 executed.
%
% This is what should be fleshed out
% Space fact, (X, Y, Safe, PossiblePit, PossibleWumpus)

:- dynamic noStench/2, noBreeze/2, stench/2, breeze/2, visited/2, wall/2, safety/2, haveArrow/0, murder/0.

% turn facts, can turn left or right, mostly use right turns because they are the right way to go.
turn(north, east).
turn(east, south).
turn(south, west).
turn(west, north).

% fact replacing function, used for replacing direction and location.
replace_existing_fact(OldFact, NewFact) :-
    (   call(OldFact)
    ->  retract(OldFact),
        assertz(NewFact)
    ;   assertz(NewFact)
    ).

% update_spaces(S, P, W) :- location(X, Y), 
%	replace_existing_fact(space(X,Y,0,_,_), space(X,Y,S,P,W))

% Initialize at the bottom left with an empty wallet and one arrow.
init_agent:-
    format('\n=====================================================\n'),
    format('This is init_agent:\n\tIt gets called once, use it for your initialization\n\n'),
    format('=====================================================\n\n'),
	assert(haveArrow),
	assert(gold(0)),
	assert(location(0,0)),
	assert(visited(0,0)),
	assert(boredom(0)),
	assert(direction(east)).
	

% --------- unused pathfinding predicates ---------------------------------------------------------------------------------------
% I wanted to make the agent pathfind to unvisited tiles, but I could not figure out the predicate for finding unvisited, safe spaces from anywhere on the grid.
% I would have also made the agent pathfind to the ladder when it found the gold
% meandering is not great, but it usually finds the gold when a safe path exists.

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



% Tiled faced
% Pretty self explanatory, gives the next tile using the direction fact and given tile.
next_tile(X, Y, Dx, Dy) :- direction(east), Dx is X + 1, Dy is Y.
next_tile(X, Y, Dx, Dy) :- direction(north), Dx is X, Dy is Y + 1.
next_tile(X, Y, Dx, Dy) :- direction(west), Dx is X - 1, Dy is Y.
next_tile(X, Y, Dx, Dy) :- direction(south), Dx is X, Dy is Y - 1.



% Confirmed Wumpus?
% If we found a tile with two neighboring stenches, we have likely found the wumpus and should kill it if we are looking at it.
conWumpus(X,Y) :- X1 is X - 1, Y1 is Y - 1, stench(X1, Y), stench(X, Y1), not(visited(X, Y)).
conWumpus(X,Y) :- X1 is X - 1, Y2 is Y + 1, stench(X1, Y), stench(X, Y2), not(visited(X, Y)).
conWumpus(X,Y) :- X1 is X - 1, X2 is X + 1, stench(X1, Y), stench(X2, Y), not(visited(X, Y)).
conWumpus(X,Y) :- X2 is X + 1, Y1 is Y - 1, stench(X2, Y), stench(X, Y1), not(visited(X, Y)).
conWumpus(X,Y) :- X2 is X + 1, Y2 is Y + 1, stench(X2, Y), stench(X, Y2), not(visited(X, Y)).
conWumpus(X,Y) :- Y1 is X + 1, Y2 is Y + 1, stench(X, Y1), stench(X, Y2), not(visited(X, Y)).

% Possible Wumpus?
% if none of the neighboring spaces lack a stench, we must assume a wumpus.
wumpus(X, Y) :- not(visited(X, Y)), X1 is X - 1, X2 is X + 1, Y1 is Y - 1, Y2 is Y + 1, not(noStench(X1, Y)), not(noStench(X2, Y)), not(noStench(X, Y1)), not(noStench(X, Y2)).

% Possible Pit?
% if none of the neighboring spaces lack a breeze, we must assume a wumpus.
pit(X, Y) :- not(visited(X, Y)), X1 is X - 1, X2 is X + 1, Y1 is Y - 1, Y2 is Y + 1, not(noBreeze(X1, Y)), not(noBreeze(X2, Y)), not(noBreeze(X, Y1)), not(noBreeze(X, Y2)).

% Is Safe?
% Is the tile safe? changes depending on the state of the wumpus and arrow.
isSafe(X,Y) :- not(pit(X,Y)), not(wumpus(X,Y)).
isSafe(X,Y) :- not(pit(X,Y)), murder.
isSafe(X,Y) :- not(pit(X,Y)), safety(X,Y).

% Are there any safe places still unvisited?
% Attempted but was unable to make good predicate.
% The idea was to see if a tile existed that was both visited and safe.
% If no such tile existed, I would like to go home.

% new_space() :- isSafe(X,Y), not(visited(X,Y)). not(wall(A,B)).



% Unvisited nearby?
% Is one of neighboring tiles unvisited?
% We want to prioritize unvisited tiles.
unVisited(X, Y) :- X1 is X - 1, not(visited(X1, Y)), not(wall(X1,Y)), isSafe(X1,Y).
unVisited(X, Y) :- X2 is X + 1, not(visited(X2, Y)), not(wall(X2,Y)), isSafe(X2,Y).
unVisited(X, Y) :- Y1 is Y - 1, not(visited(X, Y1)), not(wall(X,Y1)), isSafe(X,Y1).
unVisited(X, Y) :- Y2 is Y + 1, not(visited(X, Y2)), not(wall(X,Y2)), isSafe(X,Y2).

% run_agent(Percept,Action):-

% display world
% Just print the world at every turn.
run_agent(_, _) :- display_world, boredom(X), X1 is X + 1, replace_existing_fact(boredom(X), boredom(X1)), false().

% --------- purely percept predicates ---------------------------------------------------------------------------------------

% Bored
% A new tile has not been seen for 16 moves, go home.
run_agent([_,_,_,_,_], _) :- boredom(X), X >= 15, assert(gold(1)), write("I'm going home\n"), false().

% Scream!
% Assert murder.
run_agent([_,_,_,_,yes], _) :- assert(murder), false().

% Bump
% retract the perceived movement, turn, and assert the location as a wall.
run_agent([_,_,_,yes,_], turnright):- location(X,Y), retract(visited(X,Y)), assert(wall(X,Y)), next_tile(X, Y, Dx, Dy), DDx is (2 * X) - Dx, DDy is (2 * Y) - Dy, replace_existing_fact(location(X,Y), location(DDx, DDy)),
write("bump\n"), direction(A), turn(A,B), write("turn!"), replace_existing_fact(direction(A), direction(B)).

% Wumpus nearby
% If there is a wumpus nearby, assert a stench
% If there is not a wumpus nearby, assert a noStench
run_agent([yes,_,_,no,_], _):- location(X,Y), assert(stench(X, Y)), write("I smell a Wumpus.\n"),false().
run_agent([no,_,_,no,_], _):- location(X,Y), assert(noStench(X, Y)), write("Smells fine.\n"), false().

% Pit nearby
% If there is a pit nearby, assert nothing.
% If there is not a pit nearby, assert a noBreeze.
run_agent([_,yes,_,no,_], _):- write("I feel a breeze.\n"), false().
run_agent([_,no,_,no,_], _):- location(X,Y), assert(noBreeze(X, Y)), write("The air is still.\n"), false().


% --------- specific case\percept predicates ---------------------------------------------------------------------------------------

% Wumpus ahead
% Take the shot if you have an arrow and mark the location as safe.
run_agent([yes,_,_,_,_], shoot):- haveArrow, location(X,Y), next_tile(X, Y, Dx, Dy), conWumpus(Dx,Dy), write("The wumpus is in my sight!.\n"), assert(safety(Dx, Dy)), retract(haveArrow).

% On Gold
% Grab that money.
run_agent([_,_,yes,_,_], grab):- gold(0), write("grab\n"), assertz(gold(1)).

% On ladder with breeze?
% Climb out, no risks will be taken
run_agent([_,yes,_,_,_], climb):- location(0,0), write("Not worth falling into a pit!\n") .

% On ladder with stench?
% Use your arrow to carve a safe path.
run_agent([yes,_,_,_,_], shoot):- location(0,0), haveArrow, next_tile(0, 0, Dx, Dy), assert(safety(Dx, Dy)), retract(haveArrow), write("I'm in a corner with the beast!.\n").

% On ladder with gold!
% Leave, we have won!
run_agent([_,_,_,_,_], climb):- location(0,0), gold(1).


% --------- common movement predicates ---------------------------------------------------------------------------------------

% Pit danger!
% If there could be a pit ahead, turn right.
run_agent([_,_,_,_,_], turnright):- location(X,Y), next_tile(X, Y, Dx, Dy), pit(Dx, Dy), write("A pit is ahead.\n"), direction(A), turn(A,B), replace_existing_fact(direction(A), direction(B)).

% Wumpus danger!
% If there could be a live wumpus ahead, turn right.
run_agent([_,_,_,_,_], turnright):- location(X,Y), next_tile(X, Y, Dx, Dy), not(murder), not(safety(Dx,Dy)), wumpus(Dx, Dy), write("A wumpus is ahead.\n"), direction(A), turn(A,B), replace_existing_fact(direction(A), direction(B)).

% Avoid known walls
% If there is a wall ahead, turn right
run_agent(_,turnright):- location(X,Y), next_tile(X, Y, Dx, Dy), wall(Dx, Dy), direction(A), turn(A,B), replace_existing_fact(direction(A), direction(B)), write("Wall ahead.").

% Meander home
% If you have the gold and the next tile has been visited, move forward.
run_agent(_,goforward):- location(X,Y), next_tile(X, Y, Dx, Dy), gold(1), visited(Dx,Dy), replace_existing_fact(location(X,Y), location(Dx, Dy)), write("forward!").

% Meander to the gold
% If you do not have the gold and you haven't visited a nearby tile, turn
run_agent(_,turnright):- location(X,Y), next_tile(X, Y, Dx, Dy), gold(0), unVisited(X, Y), replace_existing_fact(boredom(G), boredom(0)), visited(Dx, Dy),  direction(A), turn(A,B), replace_existing_fact(direction(A), direction(B)), write("Unvisited tile nearby!").

% Default Moving
% If nothing else has occurred, walk forward.
run_agent(_,goforward):- location(X,Y), next_tile(X, Y, Dx, Dy),assert(visited(Dx, Dy)), replace_existing_fact(location(X,Y), location(Dx, Dy)), write("forward!").






