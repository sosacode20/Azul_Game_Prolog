:-[game].
:-[extraction_zone_common].
% En este archivo se encuentran los predicados para generar todas las
% jugadas posibles para un board

get_all_plays(Game, Player_index, Plays):-
    var(Plays),
    unpack_game(Game, _, _, Collections, Boards),
    list_index(Boards, Player_index, Board),
    unpack_board(Board, _, Zone, Wall, _, _),
    % valid_tiles_for_zone_row(Zone, Row_index, Wall, Valid_tiles, _),
    findall(
        Tile:Row_index,
        (valid_tiles_for_zone_row(Zone, Row_index, Wall, Tiles, _), member(Tile, Tiles)),
        All_tiles_for_preparation_zone
    ),
    findall(
        Collection_index:Tile:Row_index,
        (member(Tile:Row_index, All_tiles_for_preparation_zone), list_index(Collections, Collection_index, Collection), collection_has_tile(Collection, Tile)), 
        Plays
    ),!.
    
% ----------------------------------------------------------

% Una jugada tiene el formato 'Collection_index:Selected_tile:Preparation_zone_index'
apply_play_to_game(Game, Player_index, Play, New_game_status) :-
    Play = Collection_index:Tile:Preparation_zone_index,
    unpack_game(Game, Bag, Tape, Collections, Boards),
    % Esto siguiente es para obtener el Board
    split(Player_index, Boards, Left_boards, [Board | Right_boards]),
    % Esto es para obtener la coleccion pedida
    split(Collection_index, Collections, Left_collections, [Selected_collection | Right_collections]),
    extract_from_tile_collection(Selected_collection, Tile, Extracted_tiles, New_selected_collection),
    apply_to_board_(Board, Tape, Extracted_tiles, Preparation_zone_index, Updated_board, Updated_tape),
    % Ahora toca unir los Boards
    append(Left_boards, [Updated_board], New_left_boards),
    append(New_left_boards, Right_boards, New_boards),
    % Ahora es unir las colecciones
    append(Left_collections, [New_selected_collection], New_left_collections),
    append(New_left_collections, Right_collections, New_collections),
    % Ahora solo toca unir el juego nuevamente
    pack_game(Bag, Updated_tape, New_collections, New_boards, New_game_status).

% Este es un predicado auxiliar para facilitar el agrego de unos azulejos a la zona de preparacion
% sabiendo que cuando se extraen los azulejos de un mismo tipo de una Zona de Coleccion comun (Centro o Factoria),
% puede estar en 1 de 2 posibles formatos:
% 1- [Tile:Amount] --> Cuando se extrae de una factoria
% 2- [first:1, Tile:Amount] --> Cuando se extrae del Centro y esta la ficha de 1er jugador
apply_to_board_(Board, Tape, [Tile:Amount], Preparation_zone_index, Updated_board, Updated_tape):-
    unpack_board(Board, Player_id, Preparation_zone, Wall, Punctuation, Penalization),
    add_to_zone(Preparation_zone, Preparation_zone_index, Wall, Tile:Amount, Updated_zone, Amount_to_penalization),
    expanded(Tile:Amount_to_penalization, Tiles_to_add),
    add_to_penalization_zone(Penalization, Tiles_to_add, New_penalization_zone, Tiles_to_tape),
    add_to_tape(Tape, Tiles_to_tape, Updated_tape),
    pack_board(Player_id, Updated_zone, Wall, Punctuation, New_penalization_zone, Updated_board),!.

apply_to_board_(Board, Tape, [first:1, Tile:Amount], Preparation_zone_index, Updated_board, Updated_tape):-
    unpack_board(Board, Player_id, Preparation_zone, Wall, Punctuation, Penalization),
    add_to_penalization_zone(Penalization, [first], New_penalization_zone, Tiles_to_tape),
    add_to_tape(Tape, Tiles_to_tape, New_tape),
    pack_board(Player_id, Preparation_zone, Wall, Punctuation, New_penalization_zone, Updated_board_0),
    apply_to_board_(Updated_board_0, New_tape, Tile:Amount, Preparation_zone_index, Updated_board, Updated_tape),!.
