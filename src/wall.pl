:- [bag].

% Triunfa cuando Wall es un muro en su estado inicial
new_wall(Wall) :-
    findall(Tile:0, tiles(Tile), Tiles),
    add_rotated(Tiles, 4, Wall).

add_to_wall_row_(Wall_row, Tile, New_wall_row, Col_index):-
    list_index(Wall_row, Col_index, Tile:0),
    split(Col_index, Wall_row, First_part, Last_part),
    Last_part = [_ | Tail],
    New_last_part = [Tile:1 | Tail],
    append(First_part, New_last_part, New_wall_row),!.

% Este es el predicado que debe llamarse cuando se vaya a agregar un azulejo
% al Muro
add_to_wall(Wall, Row_index, Tile, New_wall, Score):-
    split(Row_index, Wall, First_part, Last_part),
    Last_part = [Head | Tail],
    add_to_wall_row_(Head, Tile, New_head, Col_index),
    New_last_part = [New_head | Tail],
    append(First_part, New_last_part, New_wall),
    consecutive_wall_tiles(New_wall, Row_index, Col_index, Score),!.

% -----------------------------------------------------------------------------------

% Este predicado es para contar la cantidad de azulejos consecutivos en una fila
% Es un predicado auxiliar para el predicado 'consecutive_wall_tiles'
consecutive_tiles_([], 0).
consecutive_tiles_([_:0 | _], 0).
consecutive_tiles_([_:1 | Tail], Score):-
    consecutive_tiles_(Tail, Score_0),
    Score is Score_0 + 1.

consecutive_wall_tiles(Wall, Row_index, Col_index, Number):-
    matrix_column_index(Wall, Col_index, Column), % Obtienes aqui la columna
    list_index(Wall, Row_index, Row), % Obtienes aqui la fila
    split(Col_index, Row, First_row_part, Rest_row_part),
    
    reverse(First_row_part, First_row_part_1),
    consecutive_tiles_(First_row_part_1, Row_sum_0),

    consecutive_tiles_(Rest_row_part, Row_sum_1),
    Row_sum is Row_sum_0 + Row_sum_1,
    split(Row_index, Column, First_col_part, Rest_col_part),

    reverse(First_col_part, First_col_part_1),
    consecutive_tiles_(First_col_part_1, Col_sum_0),
    
    consecutive_tiles_(Rest_col_part, Col_sum_1),
    Col_sum is Col_sum_0 + Col_sum_1,
    (
        Row_sum =:= 1,
        Col_sum =:= 1,
        Number = 1,!;
        Row_sum > 1,
        Col_sum > 1,
        Number is Row_sum + Col_sum,!;
        Row_sum > 1,
        Col_sum =:= 1,
        Number = Row_sum,!;
        Col_sum > 1,
        Row_sum =:= 1,
        Number = Col_sum,!;
        Number = 0,!
    ).

% -----------------------------------------------------------------

% Predicado para saber dado un wall y un indice de una fila del mismo
% los azulejos que faltan por posicionar
valid_tiles_for_wall_row(Wall, Row_index, Valid_tiles):-
    list_index(Wall, Row_index, Row),
    findall(Tile, member(Tile:0, Row), Valid_tiles).

% -----------------------------------------------------------------

% Predicados necesarios para imprimir el Muro

print_wall_rows_([]):-!.
print_wall_rows_([Wall]):-
    length(Wall, Length),
    Length == 5,
    print_row_(Wall).
print_wall_rows_([Head|Tail]):-
    print_wall_rows_(Tail),
    nl,
    print_wall_rows_([Head]).

% Imprime un Wall con el nombre Wall_name
print_wall(Wall, Wall_name):-
    % valid_wall(Wall),
    string(Wall_name),
    reverse(Wall, Wall_reversed),
    nl,nl,
    format("~`+t ~s ~`+t~66+", [Wall_name]),nl,
    print_wall_rows_(Wall_reversed),!,nl,
    format("~`+t~66+", []),nl,nl.

% format

% Imprime un Row en una linea
print_row_(Row):-
    is_list(Row),
    % findall(Y, (element_representation(Row,Z), member(Y,Z)),Representation),
    element_representation(Row, Representation),
    length(Row,Length),
    repeat_string_pattern("~t~s~t~13+|",Length, Repeated_pattern),
    string_concat("|",Repeated_pattern, Repeated_pattern2),
    format(Repeated_pattern2, Representation),!.

element_representation([Element:Enabled], [Representation]):-
    Enabled == 0,
    Representation = "-";
    Enabled == 1,
    Representation = Element.

element_representation([Head | Tail],Representation):-
    element_representation(Tail, Representation2),
    element_representation([Head], Representation1),
    append(Representation1, Representation2, Representation).
