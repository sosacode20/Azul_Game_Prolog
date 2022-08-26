
% Esto permite crear al predicado inside como un operador
:- op(500, xfy, inside).

%% inside (?Element, +Low:High)
% Dice si X se encuentra en el intervalo denotado por [Low-High]
inside(X, Low:High):-
    integer(Low),
    integer(High),
    High >= Low,
    (
        X = Low,!;
        (
            Next is Low + 1,
            inside(X, Next:High)
        )
    ).

% -----------------------------------------------------------------

% El predicado expanded dice si la lista de elementos en el 1er argumento
% donde todos sus elementos son de la forma [X:Amount, Y:Amount2, ...]
% coincide con la lista expandida dada en el 2do argumento, es decir,
% este predicado triunfa cuando la lista Expanded es el resultado de transformar
% todos los elementos Element:Amount en una lista que contenga al elemento 'Element'
% Amount veces
expanded(X:1, [X]):- atom(X),!.
expanded(X:Amount, Expanded):-
    atom(X),
    integer(Amount),
    Amount > 0,
    Amount2 is Amount - 1,
    expanded(X:Amount2, Expanded2),
    append([X], Expanded2, Expanded),!.

expanded([], []).

expanded([X:Amount|Tail], Expanded) :-
    expanded(X:Amount, Expanded1),
    expanded(Tail, Expanded2),
    append(Expanded1, Expanded2, Expanded),!.

% -------------------------------------------------------

% Triunfa si el resultado de picar una lista en la posicion justo antes de Index
% es First_part + Last_part
split(0, List, [], List):-
    is_list(List), !.
split(_, [], [], []):- !.
split(Index, [Head | Tail], [Head | Tail], []) :-
    length([Head | Tail], Length),
    Index >= Length,!.
split(Index, [Head | Tail], First_part, Last_part) :-
    Index > 0,
    New_index is Index - 1,
    split(New_index, Tail, F, Last_part),
    First_part = [Head | F].

% --------------------------------------------------------

% Triunfa si la lista final es la original pero desplazada Amount posiciones
% si Amount es negativo, desplaza hacia la izquierda, si es positivo,
% desplaza hacia la derecha
displaced([Element | Tail], Amount, List_displaced) :-
    length([Element|Tail], Length),
    integer(Amount),
    Index is (-1 * Amount) mod Length,
    split(Index, [Element|Tail], First, Last),
    append(Last,First,List_displaced).

% --------------------------------------------------------------------------

% Este predicado triunfa si la lista final es una lista de listas de tamano Amount
% donde su primer elemento es la lista que se pasa como argumento 1 y cada lista
% consecutiva es la misma que la anterior pero rotada una posicion a la derecha
% Nota: Este predicado es usado en la creacion del Wall
add_rotated([Element | Tail], 0, [[Element | Tail]]).
add_rotated([Element | Tail], Amount, Rotated_list) :-
    Amount > 0,
    New_amount is Amount - 1,
    add_rotated([Element | Tail], New_amount, Rotated1),
    displaced([Element | Tail], Amount, Rotated2),
    append(Rotated1, [Rotated2], Rotated_list),!.

% --------------------------------------------------------

% Aqui estan todos los predicados que trabajan con un grupo
% Los grupos son una lista donde cada elementos tiene el siguiente
% formato: Element:Amount
% Son utiles para los predicados del Centro de Mesa y las Factorias

add_to_group(Tile, [], [Tile:1]).
add_to_group(Tile, [Tile:Amount | Tail], [Tile:Amount2 | Tail]):-
    Amount2 is Amount + 1,!.
add_to_group(Tile, [Head:Amount | Tail], Group) :-
    Head \== Tile,
    add_to_group(Tile, Tail, Group2),
    Group = [Head:Amount | Group2],!.

% Mezcla 2 grupos
merge_groups(Group1, Group2, Merged_group):-
    expanded(Group1, Expanded_group),
    add_list_of_elements_to_group(Expanded_group, Group2, Merged_group).

% remove_from_group(Group, Element, New_group) :-


add_list_of_elements_to_group([Element], Group, New_group):-
    add_to_group(Element, Group, New_group),!.
add_list_of_elements_to_group([Head | Tail], Group, New_group):-
    add_list_of_elements_to_group(Tail, Group, New_group1),
    add_to_group(Head, New_group1, New_group).

% --------------------------------------------------------------

% Triunfa si en la lista dada el Element se encuentra en la posicion
% dada por Index
list_index(List, Index, Element) :-
    List = [Head | _],
    Head = Element,
    Index = 0;
    List = [_ | Tail],
    list_index(Tail, Index2, Element),
    Index is Index2 + 1.

% Dada una matriz y un indice se devuelve la columna que se encuentra
% en ese indice
matrix_column_index([[Head | Tail]], Index, [Column]) :- 
    % element_index(Column, [Head|Tail], Index).
    list_index([Head | Tail], Index, Column).
matrix_column_index(Matrix, Index, Column) :-
    Matrix = [Head|Tail],
    matrix_column_index(Tail, Index, Column2),
    matrix_column_index([Head], Index, Column1),
    append(Column1, Column2, Column).

% --------------------------------------------------------------------------

% Este predicado triunfa si el string del 3er parametro es el mismo que el primero
% pero repetido Amount_of_times veces
repeat_string_pattern(X,1, X).%:- string(X).
repeat_string_pattern(X, Amount_of_times, Repeated) :-
    Amount_of_times > 1,
    New_amount is Amount_of_times - 1,
    repeat_string_pattern(X, New_amount, Repeated2),
    string_concat(X, Repeated2, Repeated),!.

% Triunfa si la lista final es el resultado de repetir Amount de veces
% el Element.
repeated_list(_, 0, []).
repeated_list(Element, 1, [Element]).
repeated_list(Element, Amount, List) :-
    Amount > 1,
    New_amount is Amount - 1,
    repeated_list(Element, New_amount, List_tail),
    append([Element], List_tail, List),!.

% --------------------------------------------------------------------------

% Este predicado triunfa si la lista final es la inicial con indices en aumento
% comenzando por el indice Index
indexed_list([Element], Index, [Index:Element]) :-
    integer(Index).
indexed_list([Original_list_Head | Original_Tail], Start_index, [Start_index:Original_list_Head | Indexed_tail]) :-
    integer(Start_index),
    New_index is Start_index + 1,
    indexed_list(Original_Tail, New_index, Indexed_tail),!.

% -------------------------------------------------------------------------

% Lower clamp es un predicado que unifica Result con 0 en caso de que
% Number sea negativo, en otro caso Result unifica con Number
clamp_to_zero(Number, Result):-
    Number < 0,
    Result = 0,!.

clamp_to_zero(Number, Result):-
    % Si se va por este camino el numero es positivo
    Result = Number,!.

clamp_up(Number, Top_limit, Result):-
    Number >= Top_limit,
    Result = Top_limit,!.

clamp_up(Number, _, Result):-
    Result = Number,!.