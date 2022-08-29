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
    
