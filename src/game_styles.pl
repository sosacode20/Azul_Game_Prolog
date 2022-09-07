:- [plays].

% Aqui estaran los predicados necesarios para permitir jugar con diferentes
% estilos o estrategias
game_style(random).
game_style(greedy).

not_plays_for_player(Player_index):-
    get_player_by_index(Player_index, Player_name:_),
    write("--------- El jugador "), print(Player_name), write(" no tiene posibles jugadas ----------"),
    nl,nl.

% Este predicado busca en el juego el tablero del jugador seleccionado
% y escoge de manera aleatoria una de todas las jugadas posibles y la asigna
% a Selected_play
random(Game, Player_index, Selected_play):-
    get_all_plays(Game, Player_index, Plays),
    random_member(Selected_play, Plays),!.

% Esta segunda opcion no se llamara nunca a no ser que la lista de jugadas
% posibles sea vacia
random(_, Player_index, _):-
    not_plays_for_player(Player_index),!.

% Este predicado busca en el juego el tablero del jugador seleccionado
% y escoge de todas las jugadas posibles la que considera mejor segun el criterio greedy
% y la asigna a Selected_play
greedy(Game, Player_index, Selected_play):- % Esto se podria refactorizar con el metapredicado foldl
    get_all_plays(Game, Player_index, Plays),
    findall(
        Play:Punctuation,
        (
            member(Play, Plays),
            apply_play_to_game(Game, Player_index, Play, New_game_status),
            get_board_from_game(New_game_status, Player_index, Board),
            % es necesario alicatar para tener una idea de con que puntuacion
            % se quedaria el jugador si el juego terminara en esta ronda
            alicatado(Board, New_board, _),
            unpack_board(New_board, _, _, _, Punctuation, _)
        ),
        Plays_and_punctuations
    ),
    best_play_(Plays_and_punctuations, Selected_play),!.

greedy(_, Player_index, _):-
    not_plays_for_player(Player_index),!.

% ----------------- Utils for this file ---------------

best_play_([First_play | Other_plays_and_punctuations], Best_play):-
    foldl(select_best_play, Other_plays_and_punctuations, First_play, Best_play:_).

select_best_play(Play_1:Score_1, Play_2:Score_2, Best_play):-
    Score_1 >= Score_2,
    Best_play = Play_1:Score_1;
    Best_play = Play_2:Score_2.
