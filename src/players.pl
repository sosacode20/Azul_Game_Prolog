:- [utils].
:- dynamic player/2, first_player_index/1.

% Este predicado permite saber si el nombre del estilo dado es valido en el simulador.
game_style(Style):-
    member(Style, [greedy, random]).

% Este predicado da la cantidad de jugadores que hay actualmente creados
get_players_count(Count):-
    findall(Player, player(Player,_), All_players),
    length(All_players, Count).

% Este predicado agrega a la base de datos un nuevo jugador si no existia previamente su nombre guardado
create_player(Id, Style):-
    game_style(Style),
    findall(Player, player(Player,_), All_players),
    (
        member(Id, All_players),
        write('Player already exists'), nl, !;
        get_players_count(Count),
        Count == 4,
        write('You have the maximum amount of players that is 4'), nl, !;
        assertz(player(Id, Style)),!
    ).

create_player(Id:Style) :-
    create_player(Id, Style),!.

create_players([]).
create_players([Id:Style | Other_players]) :-
    create_player(Id:Style),
    create_players(Other_players).
