:- [bag].

% Este archivo esta con el unico proposito de contener un predicado
% comun entre el Centro y las Factorias para poder extraer sus Tiles
% y que con el Centro sepa que debe extraer la ficha de jugador inicial
% junto con la que se solicite extraer

% Aqui se debe Notar que Tile_to_extract tiene que ser un Tile valido, por ende
% no se puede pedir extraer la ficha del jugador inicial, en cuyo caso fallara
extract_from_tile_collection(Collection, Tile_to_extract, Extracted_tiles, New_collection) :-
    tiles(Tile_to_extract),
    extract_first_(Collection, Extracted_first, New_collection_0), % Extracted_first puede ser lista vacia
    list_index(New_collection_0, Index, Tile_to_extract:Amount),!,
    split_at(Index, New_collection_0, First_part, [_ | Tail]),
    append(Extracted_first, [Tile_to_extract:Amount], Extracted_tiles),
    append(First_part, Tail, New_collection).

% Este predicado es para comprobar si la ficha de jugador inicial se encuentra
% en la coleccion
extract_first_(Collection, [first:1], New_collection) :-
    % Lo siguiente verifica que la ficha del primer jugador se encuentre
    list_index(Collection, Index, first:1),!,
    split_at(Index, Collection, First_part, [_ | Tail]),
    append(First_part, Tail, New_collection).
    
extract_first_(Collection, [], Collection).