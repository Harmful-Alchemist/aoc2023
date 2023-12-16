
score1([],0).
score1([Line|Lines],Val) :-
    % write(Line),nl,
    ticket(Line,_,Ns,Ws),
    score(Ns,Ws,X),
    score1(Lines,Y),
    Val is X + Y.

% Duplicates is going to screw it up :P, They didn't!
score(Ns,Ws,0) :-
    intersection(Ns,Ws,[]).
score(Ns,Ws,Val) :-
    intersection(Ns,Ws,Is),
    filled(Is),
    length(Is,X),
    Val is 2**(X-1).

filled([_|_]).

ticket(Line,N,Ns,Ws) :-
    append(`Card `,X1,Line),
    number(X1,N,[S1|X2]),
    colon(S1),
    numbers(X2,Ns,X3),
    % end(X3,X4),
    numbers(X3,Ws,[]).

numbers([],[],[]).
numbers(In,[Val|Prev],More2) :-
    number(In,Val,More),
    numbers(More,Prev,More2).
numbers([S|More],Prev,More2) :-
    space(S),
    numbers(More,Prev,More2).
numbers([S|More],[],More) :-
    vbar(S).

end([],[]).
end([S|Out],Out) :-
    vbar(S).
end([S|More],Out) :-
    space(S),
    end(More,Out).


main :- 
    open('day4.txtpl',read,Str),
    read_lines(Str,Y),
    score1(Y,X),
    write(X), nl.
    % write(Z), nl.

read_lines(Stream,[]) :-
    at_end_of_stream(Stream).

read_lines(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream), %https://en.wikipedia.org/wiki/Prolog#Negation
    read(Stream,X),
    read_lines(Stream,L).

number([H1,H2,H3|Out],Val,Out) :-
    not_num(Out),
    digit(H1,V1),
    digit(H2,V2),
    digit(H3,V3),
    Val is 100*V1 + 10*V2 + V3.

number([H1,H2|Out],Val,Out) :-
    not_num(Out),
    digit(H1, Val1),
    digit(H2, Val2),
    Val is 10*Val1 + Val2.

number([H|Out], Val, Out) :-
    not_num(Out),
    digit(H,Val).

number([S|More],Val,Out) :-
    space(S),
    number(More,Val,Out).

not_num([]).
not_num([S|_]) :-
    \+ digit(S,_).

space(32).
vbar(124).
colon(58).

digit(48,0).
digit(49,1).
digit(50,2).
digit(51,3).
digit(52,4).
digit(53,5).
digit(54,6).
digit(55,7).
digit(56,8).
digit(57,9).