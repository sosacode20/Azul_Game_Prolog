:- [bag].

% Triunfa cuando Wall es un muro en su estado inicial
new_wall(Wall) :-
    findall(Tile:0, tiles(Tile), Tiles),
    add_rotated(Tiles, 4, Wall).
