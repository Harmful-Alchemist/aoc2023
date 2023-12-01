
main :- 
    open('day1_ex.txt',read,Str),
    read_lines(Str,Y),
    process(X,Y),
    close(Str),
    write(X), nl.

read_lines(Stream,[]) :-
    at_end_of_stream(Stream).

read_lines(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_lines(Stream,L).

process(0, []).

process(Res, [H|T]) :- 
    process(X,T),
    nums(Y,H),
    Res is X + Y.

nums(Res,[H|T]) :-
    H > 47,
    H < 58,
    nums([X],T),
    % Res is (H-48)*10 + X.
    No is H - 48,
    Res is [No,X].

nums([Res],[H|T]) :-
    H > 47,
    H < 58,
    nums([],T),
    Res is H - 48.


nums(X,[H|T]) :-
    nums(X,T).


nums([], []).



sum(Res, [H|T]) :- 
    sum(X, T), 
    Res is H + X.

sum(0, []).