% Define the colors available for coloring
color(red).
color(green).
color(blue).
color(yellow).

% Define the map as a list of regions and their neighbors
map([region(a, [b, c]),       % Region 'a' is adjacent to 'b' and 'c'
     region(b, [a, c, d]),    % Region 'b' is adjacent to 'a', 'c', and 'd'
     region(c, [a, b, d]),    % Region 'c' is adjacent to 'a', 'b', and 'd'
     region(d, [b, c])]).     % Region 'd' is adjacent to 'b' and 'c'

% Main predicate to solve the map coloring problem
map_coloring(Map, Coloring) :-
    % Extract all regions from the map
    findall(Region, member(region(Region, _), Map), Regions),
    % Initialize the coloring as an empty list
    Coloring = [],
    % Start the heuristic search
    heuristic_search(Map, Regions, Coloring).

% Heuristic search: MRV (Minimum Remaining Values)
heuristic_search(_, [], Coloring) :-
    % If no regions are left, the coloring is complete
    format_coloring(Coloring).

heuristic_search(Map, Regions, Coloring) :-
    % Select the region with the fewest available colors (MRV heuristic)
    mrv_region(Map, Regions, Coloring, SelectedRegion),
    % Remove the selected region from the list of regions to be colored
    select(SelectedRegion, Regions, RemainingRegions),
    % Find all possible colors for the selected region
    findall(Color, color(Color), Colors),
    % Filter out colors that conflict with neighboring regions
    filter_colors(Map, SelectedRegion, Coloring, Colors, ValidColors),
    % Assign a valid color to the selected region
    member(SelectedColor, ValidColors),
    % Add the colored region to the coloring
    append(Coloring, [region(SelectedRegion, SelectedColor)], NewColoring),
    % Recursively color the remaining regions
    heuristic_search(Map, RemainingRegions, NewColoring).

% MRV heuristic: Select the region with the fewest available colors
mrv_region(Map, Regions, Coloring, SelectedRegion) :-
    % Calculate the number of valid colors for each region
    findall(region_count(Region, Count), (
        member(Region, Regions),
        findall(Color, color(Color), Colors),
        filter_colors(Map, Region, Coloring, Colors, ValidColors),
        length(ValidColors, Count)
    ), RegionCounts),
    % Sort regions by the number of valid colors (ascending order)
    sort(1, @=<, RegionCounts, SortedRegionCounts),
    % Select the region with the minimum count
    SortedRegionCounts = [region_count(SelectedRegion, _) | _].

% Filter colors for a region based on neighboring regions
filter_colors(Map, Region, Coloring, Colors, ValidColors) :-
    % Find the neighbors of the region
    member(region(Region, Neighbors), Map),
    % Remove colors that are already used by neighboring regions
    exclude(conflicts_with_neighbors(Neighbors, Coloring), Colors, ValidColors).

% Check if a color conflicts with neighboring regions
conflicts_with_neighbors(Neighbors, Coloring, Color) :-
    member(region(Neighbor, NeighborColor), Coloring),
    member(Neighbor, Neighbors),
    Color = NeighborColor.

% Format the coloring output
format_coloring(Coloring) :-
    forall(member(region(Region, Color), Coloring),
           format('~w => ~w~n', [Region, Color])).

% Main query to solve the map coloring problem
solve :-
    % Retrieve the map
    map(Map),
    % Solve the map coloring problem (only one solution)
    once(map_coloring(Map, _)).