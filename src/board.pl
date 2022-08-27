:-[players].
:-[preparation_zone].
:-[penalization].

new_board(Player_id, New_board):-
    get_player_by_id(Player_id, _, _),
    new_wall(Wall),
    new_preparation_zone(Zone),
    New_board = [
        player:Player_id,
        preparation_zone:Zone,
        wall:Wall,
        punctuation:0,
        penalization:[]
    ].

% -----------------------------------------------

unpack_board(Board, Player_id, Preparation_zone, Wall, Punctuation, Penalization_zone) :-
    Board = [
        _:Player_id,
        _:Preparation_zone,
        _:Wall,
        _:Punctuation,
        _:Penalization_zone
    ].

pack_board(Player_id, Preparation_zone, Wall, Punctuation, Penalization_zone, New_board) :-
    New_board = [
        player:Player_id,
        preparation_zone:Preparation_zone,
        wall:Wall,
        punctuation:Punctuation,
        penalization: Penalization_zone
    ].

% -----------------------------------------------

alicatado(Board, New_board, Tiles_to_tape) :-
    unpack_board(Board, Player_id, Preparation_zone, Wall, Punctuation, Penalization_zone),
    alicatado_(Preparation_zone, Wall, New_punctuation_0, New_preparation_zone, New_wall, Tiles_to_tape_0),
    Punctuation_without_penalization is Punctuation + New_punctuation_0,
    length(Penalization_zone, Penalization_amount),
    penalization_cost(Penalization_amount, Penalization_cost),
    New_punctuation is Punctuation_without_penalization + Penalization_cost,
    clamp_to_zero(New_punctuation, Final_punctuation), % This line is for mantaining a non-negative punctuation
    append(Tiles_to_tape_0, Penalization_zone, Tiles_to_tape), % In here is not important to remove the tile of the first player because it will be removed later
    pack_board(Player_id, New_preparation_zone, New_wall, Final_punctuation, [], New_board), !.

% -----------------------------------------------

% Aqui van los predicados auxiliares para el alicatado de un board
% alicatado_(Preparation_zone, Wall, Punctuation, New_preparation_zone, New_wall, Tiles_to_tape).

alicatado_([], Wall, 0, [], Wall, []).

% Esta variante es la que se encarga del caso en el que una fila no este completa
% es decir, tambien sirve para el caso de que Tile sea 'empty'
alicatado_(
    [Max_amount:Tile:Actual_amount | Tail], 
    Wall, 
    Punctuation, 
    [Max_amount:Tile:Actual_amount | New_tail], 
    New_wall, 
    Tiles_to_tape) :-
        Max_amount \== Actual_amount,
        alicatado_(Tail, Wall, Punctuation, New_tail, New_wall, Tiles_to_tape).

% Esta variante es para el caso de que una fila este completa
alicatado_(
    [Max_amount:Tile:Max_amount | Zone_tail],
    Wall,
    Punctuation,
    New_preparation_zone,
    New_wall,
    Tiles_to_tape) :-
        Tile \== empty,
        Row_index is Max_amount - 1, % Esto es solo para mejorar la legibilidad en lo siguiente
        add_to_wall(Wall, Row_index, Tile, New_wall_0, Punctuation_0),
        alicatado_(Zone_tail, New_wall_0, Punctuation_1, New_zone_tail, New_wall, Tiles_to_tape_0),
        New_preparation_zone = [Max_amount:empty:0 | New_zone_tail],
        Count is Max_amount - 1,
        expanded(Tile:Count, Tiles_to_tape_1),
        append(Tiles_to_tape_1, Tiles_to_tape_0, Tiles_to_tape),
        Punctuation is Punctuation_0 + Punctuation_1,!.
