% Define the colors available
color(red).
color(green).
color(blue).
color(yellow).

% Define the adjacency between regions (map structure)
adjacent(a, b).
adjacent(a, c).
adjacent(a, d).
adjacent(b, c).
adjacent(c, d).

% Ensure that two adjacent regions do not have the same color
valid_coloring(Region1, Color1, Region2, Color2) :-
    adjacent(Region1, Region2),
    Color1 \= Color2.

% Main predicate to color the map
color_map([], _).
color_map([Region-Color | Rest], Colors) :-
    member(Color, Colors),
    \+ (member(OtherRegion-OtherColor, Rest), adjacent(Region, OtherRegion), Color = OtherColor),
    color_map(Rest, Colors).

% Example usage
% Define the regions to be colored
regions([a, b, c, d]).

% Find a valid coloring for the map
solve_coloring(Coloring) :-
    regions(Regions),
    findall(Color, color(Color), Colors),
    assign_colors(Regions, Colors, Coloring),
    color_map(Coloring, Colors).

% Helper predicate to assign colors to regions
assign_colors([], _, []).
assign_colors([Region | Rest], Colors, [Region-Color | Coloring]) :-
    member(Color, Colors),
    assign_colors(Rest, Colors, Coloring).

% Helper predicate to print the coloring
print_coloring([]).
print_coloring([Region-Color | Rest]) :-
    write(Region), write(' -> '), write(Color), nl,
    print_coloring(Rest).

% Run the program
:- solve_coloring(Coloring), print_coloring(Coloring).