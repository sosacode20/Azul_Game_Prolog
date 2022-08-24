
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
