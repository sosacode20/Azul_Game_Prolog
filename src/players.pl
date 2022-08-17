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

% ----------------------------------------------------------------------------

% Este predicado elimina de la base de datos un jugador si existe su nombre guardado
remove_player(Id):-
    retract(player(Id, _)),!.

remove_player(_):-
    write('Player does not exist'), nl.

% Este predicado se encarga de eliminar todos los jugadores que se encuentren en la BD
remove_players :-
    retractall(player(_,_)).
