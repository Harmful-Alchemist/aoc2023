main :- 
    open('day1.txtpl',read,Str),
    read_lines(Str,Y),
    process(X,Y),
    % process_acc(Y,0,X),
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

last(X,[X]).
last(X,[_H|T]) :- last(X,T).

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

% Too slow? Or infinite maybe? Not for example, also I think incorrect for the example :P process_acc([`one`,`11111eightwo`],0,Y). goes fine
process_acc([],A,A).

process_acc([H|T],A,Tot) :-
    line(H,Val),
    Anew is A+Val,
    process_acc(T,Anew,Tot).

line(X,Val) :- 
    first_no(X,F),
    last_no(X,L),
    Val is 10 * F + L.

first_no(X,H) :-
    terminals(X,[H|_T]).

last_no(X,Val) :-
    terminals(X, Ts),
    last(Val,Ts).

terminals([InputH|InputT], [Val|List]) :-
    append(X,_Rest,[InputH|InputT]),
    terminal(X,Val),
    terminals(InputT,List).

% Ignore unknown
terminals([_InputH|InputT], List) :-
    terminals(InputT,List).

terminals([],[]).

terminal(`1`,1).
terminal(`one`,1).
terminal(`2`,2).
terminal(`two`,2).
terminal(`3`,3).
terminal(`three`,3).
terminal(`4`,4).
terminal(`four`,4).
terminal(`5`,5).
terminal(`five`,5).
terminal(`6`,6).
terminal(`six`,6).
terminal(`7`,7).
terminal(`seven`,7).
% terminal(_A,0).
