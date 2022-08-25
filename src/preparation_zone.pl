:- [wall].

% Predicado para devolver una nueva zona de preparacion
% Maximum_amount:Tile_value:Actual_amount
new_preparation_zone(Zone):-
    repeated_list(empty:0, 5, List),
    indexed_list(List, 1, Zone).

% ----------------------------------------------------------

valid_tiles_to_add_(Maximun_amount:empty:_, All_tiles, Maximun_amount):-
    findall(Tile, tiles(Tile), All_tiles).
valid_tiles_to_add_(Maximun_amount:Tile:Actual_amount, [Tile], Amount_to_add):-
    tiles(Tile),
    Actual_amount >= 0,
    Maximun_amount >= Actual_amount,
    Amount_to_add is Maximun_amount - Actual_amount.

valid_tiles_for_zone_row(Zone, Row_index, Wall, Valid_tiles, Amount):-
    valid_tiles_for_wall_row(Wall, Row_index, Wall_row_valid_tiles), % Dame los azulejos que se estan libres en el Muro
    list_index(Zone, Row_index, Preparation_row), % Dame la fila de preparacion deseada
    valid_tiles_to_add_(Preparation_row, Preparation_row_valid_tiles, Amount), % Dime los azulejos que se le pueden agregar
    intersection(Wall_row_valid_tiles, Preparation_row_valid_tiles, Valid_tiles),!.
