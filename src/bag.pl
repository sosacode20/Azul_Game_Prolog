:- [utils].

% Este predicado triunfa si X es un azulejo valido
tiles(X) :-
    member(X, [azul, amarillo, rojo, negro, blanco]).

% ----------------------------------------------------------------------------------------

% Triunfa si X es un bag nuevo, es decir, que contiene todas las fichas.
% En caso de X ser una variable unbounded pues le asigna un bag nuevo
new_bag(Bag) :-
    findall(Tile:20, tiles(Tile), Tiles),
    expanded(Tiles, Expanded),
    random_permutation(Expanded, Bag).

% ----------------------------------------------------------------------------------------

extract_from_bag(Bag, Number_of_tiles, Extracted_tiles, Updated_bag):-
    split(Number_of_tiles, Bag, Extracted_tiles, Updated_bag).

% ----------------------------------------------------------------------------------------

add_to_bag(Bag, List_of_tiles, Updated_bag) :-
    append(Bag, List_of_tiles, Updated_bag).
    
% ----------------------------------------------------------------------------------------

print_bag(Bag, Title) :-
    print(Title),
    nl, nl,
    portray_clause(Bag).
    
