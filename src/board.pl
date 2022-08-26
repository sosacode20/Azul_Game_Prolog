:-[players].
:-[preparation_zone].

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
