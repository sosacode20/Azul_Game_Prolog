:-[utils].
% Nota: Aqui no hace falta el predicado para crear una nueva zona de penalizacion
% porque inicialmente sera una simple lista vacia.

%-------------------------------------------------------------------------------

% La lista de penalizacion
penalization_list(X):-
    % Sum = [-1, -2, -4, -6, -8, -11, -14]
    X = [-1,-1,-2,-2,-2,-3,-3].

add_to_penalization_zone(Penalization_zone, Tiles_to_add, New_penalization_zone, Tiles_to_tape):-
    is_list(Penalization_zone),
    is_list(Tiles_to_add),
    append(Penalization_zone, Tiles_to_add, New_penalization_0),
    split(7, New_penalization_0, New_penalization_zone, Tiles_to_tape),!.

% -------------------------------------------------------------------------------

sum_count_elements(List, 0, 0):-
    is_list(List).
sum_count_elements([], _, 0).
sum_count_elements([Head | Tile], Amount_of_times, Sum):-
    integer(Head),
    integer(Amount_of_times),
    Amount_of_times >= 0,
    New_count is Amount_of_times - 1,
    sum_count_elements(Tile, New_count, Sum_0),!,
    Sum is Sum_0 + Head.

penalization_cost(Amount_of_tiles_in_penalization, Cost):-
    Amount_of_tiles_in_penalization inside (0:7),
    penalization_list(X),!,
    sum_count_elements(X, Amount_of_tiles_in_penalization, Cost).
