:- [utils].

new_center(Center) :-
    Center = [first:1].

% ----------------------------------------------------------------

% New_tiles_to_add es un grupo, es decir, una lista donde sus elementos
% tienen el formato: Element:Amount
add_to_center(Center, New_tiles_to_add, New_center) :-
    merge_groups(New_tiles_to_add, Center, New_center).
