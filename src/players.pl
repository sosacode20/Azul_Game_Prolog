:- [utils].
:- dynamic player/2, first_player_index/1, game_style/1.

% Este predicado permite saber si el nombre del estilo dado es valido en el simulador.
% game_style(Style):-
%     member(Style, [greedy, random]).

% Este predicado agrega a la base de datos un nuevo jugador si no existia previamente su nombre guardado
create_player(Id, Style):-
    game_style(Style),
    findall(Player, player(Player,_), All_players),
    (
        member(Id, All_players),
        write('Player already exists'), nl, !, fail;
        get_players_count(Count),
        Count == 4,
        write('You have the maximum amount of players that is 4'), nl, !, fail;
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

% -----------------------------------------------------------------------------

% Este predicado devuelve la lista de jugadores con sus respectivos estilos de juego
get_player_list(Players_and_style):-
    findall(Player:Style, player(Player, Style), Players_and_style).

% Este predicado permite obtener el jugador que esta asociado al Index
get_player_by_index(Index, Player:Style):-
    get_player_list(All_players),
    list_index(All_players, Index, Player:Style),!.

% Este predicado da la cantidad de jugadores que hay actualmente creados
get_players_count(Count):-
    get_player_list(All_players),
    length(All_players, Count).

get_player_by_id(Player_id, Player_index, Style) :-
    get_player_by_index(Player_index, Player_id:Style).

% ----------------------------------------------------------------

% Inicialmente en el juego el jugador inicial siempre es el 1ro que se crea
first_player_index(Index) :- 
    integer(Index),
    Index >= 0,
    get_players_count(Count),
    Count > Index,
    retract(first_player_index(_)),
    assertz(first_player_index(Index)).

first_player_index(0).