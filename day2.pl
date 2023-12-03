main :- 
    open('day2_ex.txtpl',read,Str),
    read_lines(Str,Y),
    sum_games(Y,X,[]),
    close(Str),
    write(X), nl.

read_lines(Stream,[]) :-
    at_end_of_stream(Stream).

read_lines(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream), %https://en.wikipedia.org/wiki/Prolog#Negation
    read(Stream,X),
    read_lines(Stream,L).


sum_games([],0,[]).

sum_games([Line|T],Val,Out) :-
    possible_game1(Line,GameVal),
    sum_games(T,Vp,Out),
    Val is Vp + GameVal.

possible_game1(In,Val) :-
    append(`Game `,R1,In),
    number(R1,Val,R2),
    append(`: `,R3,R2),
    hands(R3,Hands,[]),
    max(Hands,R,B,G,[]),
    R < 13,
    B < 15,
    G < 14.

possible_game1(_In,0).

possible_game1(_In,0).

max_of(X,Y,Z) :- X > Y, Z is X.
max_of(X,Y,Z) :- X =< Y, Z is Y.

max([],0,0,0,[]).
max([Rin,Bin,Gin | T],R,B,G,Out) :-
    max(T,Rp, Bp, Gp, Out),
    max_of(Rin,Rp,R),
    max_of(Bin,Bp,B),
    max_of(Gin,Gp,G).

hands([],[],[]).

%  infinite loop wtf, if on top, this is the problem!
hands(In, [R,G,B|Hands],Out) :-
    hand(In,R,G,B,Rem), 
    hands(Rem,Hands,Out).

hand(In,R,G,B,Out) :-
    append(N, R1,In),
    number(N,R,[]),
    append(` red`,R2,R1),
    hand(R2,0,G,B,Out).

hand(In,R,G,B,Out) :-
    append(N, R1,In),
    number(N,G,[]),
    append(` green`,R2,R1),
    hand(R2,R,0,B,Out).

hand(In,R,G,B,Out) :-
    append(N, R1,In),
    number(N,B,[]),
    append(` blue`,R2,R1),
    hand(R2,R,G,0,Out).

% ascii ; is 59
hand([59|Out],0,0,0,Out).
hand([],0,0,0,[]).
% ignore space 32 and comma 44
hand([32|Out],R,B,G,Out2) :- hand(Out,R,G,B,Out2).
hand([44|Out],R,B,G,Out2) :- hand(Out,R,G,B,Out2).

number([H1,H2,H3|Out],Val,Out) :-
    digit(H1,V1),
    digit(H2,V2),
    digit(H3,V3),
    Val is 100*V1 + 10*V2 + V3.

number([H1,H2|Out],Val,Out) :-
    digit(H1, Val1),
    digit(H2, Val2),
    Val is 10*Val1 + Val2.

number([H|Out], Val, Out) :-
    digit(H,Val).

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