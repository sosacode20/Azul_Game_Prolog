:- [players].
:- [bag].

factory_player_relation(Players_count, Factory_count):-
    Players_count inside (2:4), % Ver el predicado 'inside' en Utils
    Factory_count is Players_count * 2 + 1.

new_factories(Bag, Tape, Factories, Updated_bag, Updated_tape) :-
    get_players_count(Count),
    factory_player_relation(Count, Factory_count),
    Needed_tiles is Factory_count * 4,
    length(Bag, Length),
    Amount_to_extract_from_tape is Needed_tiles - Length,
    (
        Amount_to_extract_from_tape > 0,
        split(Amount_to_extract_from_tape, Tape, Extracted_amount, Updated_tape),
        append(Bag, Extracted_amount, New_bag),
        new_factories_(New_bag, Factory_count, Factories, Updated_bag),!;
        % Aqui el Amount a extraer tiene que ser menor o igual a 0
        new_factories_(Bag, Factory_count, Factories, Updated_bag),!
    ).


new_factories_(Bag, 1, [Filled_factory], Updated_bag):-
    extract_from_bag(Bag, 4, Extracted_tiles, Updated_bag),
    add_list_of_elements_to_group(Extracted_tiles, [], Filled_factory).

new_factories_(Bag, Number_of_factories, Filled_factories, Updated_bag) :-
    Number_of_factories > 1,
    % extract_from_bag(Bag, 4, Extracted_tiles, Updated_bag_0),
    new_factories_(Bag, 1, Filled_factories_0, Updated_bag_0),
    New_count is Number_of_factories - 1,
    new_factories_(Updated_bag_0, New_count, Filled_factories_1, Updated_bag),
    append(Filled_factories_0, Filled_factories_1, Filled_factories).
