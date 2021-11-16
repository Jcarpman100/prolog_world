Wumpus World Report - Joseph Carpman
==============

<br>  

##   Introduction
>My solution can be described as a reflex agent that remembers where it has been and its percepts at those locations. Due to the small size of wumpus world, I decided against using an actual pathfinding algorithm after spending a few hours trying to make one work. My agent simply moves forward until something interesting happens or it can use the knowledge it has gained about the world. This is unlikely to give an optimal solution, but it will almost always present a solution when one exists, and it will never willingly walk into danger.

<br>  

## Test Case #1
>My solution easily finds the gold and returns to the goal by retracing it's steps. Usually my agent is not satisfied with just the gold, but it will be satisfied if it has not smelled a wumpus before it finds the gold.

<br>  
<br>  

## Test Case #2
>My solution should never knowingly walk into a pit, so it navigates any possible world of pits as well as the information allows. This will not be optimal because my agent will only turn right, making any left turn into 3 right turns.

<br>  
<br>  

## Test Case #3
>My solution should never knowingly walk into a pit, so it would usually just spin in circles until the grader timed out. To stop this, my agent will start moving home if it hasn't witnessed a unvisited tile in 16 moves.

<br>  
<br>  

## Test Case #4
>My solution works just fine for the default case and even kills the wumpus for fun. killing the wumpus is not needed, but it gives more points.

<br>  
<br>  

## Test Case #5
>My solution assumes nothing about the shape of the world, so it can handle any size of world. Walls are asserted as the agent bumps into them to avoid loops. I believe my agent can navigate a world with walls in the middle because of this generic assertion.

<br>  
<br>  

## Test Case #6
>My solution can find the wumpus as long as it can explore 2 stench nodes. This covers most cases, but not all. I tested this case by placing the wumpus on the same tile as the gold. Sometimes the agent will kill the wumpus for points before going home due to impossible gold.

<br>  
<br>  

## Test Case #7
>My solution will shoot an arrow if it spawns in stench, it will then move forward to that tile because it must be safe, whether or not the wumpus was there. The agent also disregards future stenches if it hears a scream.

<br>  
<br>  
