:- [bag].

add_to_tape(Tape, [], Tape).

add_to_tape(Tape, Tiles_to_add, New_tape):-
    Tiles_to_add = [Head | Tail],
    add_to_tape_(Tape, Head, New_tape_0),
    add_to_tape(New_tape_0, Tail, New_tape),!.

add_to_tape_(Tape, first, Tape).

add_to_tape_(Tape, first:_, Tape).

add_to_tape_(Tape, Element:1, [Element | Tape]):-
    tiles(Element).

add_to_tape_(Tape, Element:Amount, New_tape):-
    tiles(Element),
    Amount > 1,
    New_tape_0 = [Element | Tape],
    New_amount is Amount - 1,
    add_to_tape_(New_tape_0, Element:New_amount, New_tape).

add_to_tape_(Tape, Element, New_tape):-
    tiles(Element),
    New_tape = [Element | Tape].