:-[utils].
% Nota: Aqui no hace falta el predicado para crear una nueva zona de penalizacion
% porque inicialmente sera una simple lista vacia.

%-------------------------------------------------------------------------------

% La lista de penalizacion
penalization_list(X):-
    X = [-1,-1,-2,-2,-2,-3,-3].

add_to_penalization_zone(Penalization_zone, Tiles_to_add, New_penalization_zone, Tiles_to_tape):-
    is_list(Penalization_zone),
    is_list(Tiles_to_add),
    append(Penalization_zone, Tiles_to_add, New_penalization_0),
    split(7, New_penalization_0, New_penalization_zone, Tiles_to_tape),!.
