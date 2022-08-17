
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
