:- [utils].

% Este predicado triunfa si X es un azulejo valido
tiles(X) :-
    member(X, [azul, amarillo, rojo, negro, blanco]).

% ----------------------------------------------------------------------------------------

% Triunfa si X es un bag nuevo, es decir, que contiene todas las fichas.
% En caso de X ser una variable unbounded pues le asigna un bag nuevo
new_bag(X) :-
    findall(Tile:20, tiles(Tile), Tiles),
    expanded(Tiles, Expanded),
    random_permutation(Expanded, X).

% ----------------------------------------------------------------------------------------

extract_from_bag(Bag, Number_of_tiles, Extracted_tiles, Updated_bag):-
    split_at(Number_of_tiles, Bag, Extracted_tiles, Updated_bag).