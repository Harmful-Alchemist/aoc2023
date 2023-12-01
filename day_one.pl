main :- 
    open('day1.txtpl',read,Str),
    read_lines(Str,Y),
    process(X,Y),
    close(Str),
    write(X), nl.

read_lines(Stream,[]) :-
    at_end_of_stream(Stream).

read_lines(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream), %https://en.wikipedia.org/wiki/Prolog#Negation
    read(Stream,X),
    read_lines(Stream,L).

process(0, []).

process(Res, [H|T]) :- 
    process(X,T),
    nums(Y,H),
    last(Last, Y),
    first(First, Y),
    Res is X + (First * 10) + Last.

last(X,[_H|T]) :- last(X,T).
last(X,[X]).

first(H,[H|_T]).

% Part two:

nums([1 | Y],[H|T]) :-
    append(`one`,_Rest,[H|T]),
    nums(Y, T).

nums([2 | Y],[H|T]) :-
    append(`two`,_Rest,[H|T]),
    nums(Y, T).

nums([3 | Y],[H|T]) :-
    append(`three`,_Rest,[H|T]),
    nums(Y, T).

nums([4 | Y],[H|T]) :-
    append(`four`,_Rest,[H|T]),
    nums(Y, T).

nums([5 | Y],[H|T]) :-
    append(`five`,_Rest,[H|T]),
    nums(Y, T).

nums([6 | Y],[H|T]) :-
    append(`six`,_Rest,[H|T]),
    nums(Y, T).

nums([7 | Y],[H|T]) :-
    append(`seven`,_Rest,[H|T]),
    nums(Y, T).

nums([8 | Y],[H|T]) :-
    append(`eight`,_Rest,[H|T]),
    nums(Y, T).

nums([9 | Y],[H|T]) :-
    append(`nine`,_Rest,[H|T]),
    nums(Y, T).

% part 1 here
nums([Num | Y],[H|T]) :-
    H > 47,
    H < 58,
    nums(Y, T),
    Num is H - 48.

nums(X,[_H|T]) :-
    nums(X,T).

nums([],[]).