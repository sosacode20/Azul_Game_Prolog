:- [utils].

% Predicado para devolver una nueva zona de preparacion
% Maximum_amount:Tile_value:Actual_amount
new_preparation_zone(Zone):-
    repeated_list(empty:0, 5, List),
    indexed_list(List, 1, Zone).
