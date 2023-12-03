main :- 
    open('day2_ex.txtpl',read,Str),
    read_lines(Str,Y),
    sum_games(Y,0,X,[]),
    close(Str),
    write(X), nl.

read_lines(Stream,[]) :-
    at_end_of_stream(Stream).

read_lines(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream), %https://en.wikipedia.org/wiki/Prolog#Negation
    read(Stream,X),
    read_lines(Stream,L).


sum_games(In,Val,Val,[]).
sum_games([Line|T],ValAcc,Val,Out) :-
    possible_game1(Line,GameVal),
    NewVal is ValAcc + GameVal,
    sum_games(T,NewVal,Val,Out).

possible_game1(In,Val) :-
    append(`Game `,R1,In),
    number(R1,Val,R2),
    append(`: `,R3,R2),
    hands(R3,[],Hands,[]),
    max(Hands,R,B,G,[]),
    R < 13,
    B < 15,
    G < 14.

possible_game1(In,0).

max([],0,0,0,[]).

max([R,B,G|T],R,B,G,Out) :-
    R > Rmax,
    B > Bmax,
    G > Gmax,
    max(T,Rmax,Bmax,Gmax,Out).

max([R,B,G|T],Rmax,B,G,Out) :-
    B > Bmax,
    G > Gmax,
    max(T,Rmax,Bmax,Gmax,Out).

max([R,B,G|T],R,Bmax,G,Out) :-
    R > Rmax,
    G > Gmax,
    max(T,Rmax,Bmax,Gmax,Out).

max([R,B,G|T],R,B,Gmax,Out) :-
    R > Rmax,
    B > Bmax,
    max(T,Rmax,Bmax,Gmax,Out).

max([R,B,G|T],Rmax,B,Gmax,Out) :-
    B > Bmax,
    max(T,Rmax,Bmax,Gmax,Out).

max([R,B,G|T],Rmax,Bmax,G,Out) :-
    G > Gmax,
    max(T,Rmax,Bmax,Gmax,Out).

max([R,B,G|T],R,Bmax,Gmax,Out) :-
    R > Rmax,
    max(T,Rmax,Bmax,Gmax,Out).

max([R,B,G|T],Rmax,Bmax,Gmax,Out) :-
    max(T,Rmax,Bmax,Gmax,Out).


hands([],Hands,Hands,[]).

hands(In, HandsAcc,Hands,Out) :-
    hand(In,R,G,B,Rem),
    NewHands is [R,G,B|HandsAcc],
    hands(Rem,NewHands,Hands,Out).


hand(In,R,G,B,Out) :-
    % \+ G is B,
    append(N, R1,In),
    number(N,R,T),
    append(` red`,R2,T),
    hand(R2,0,G,B,Out).

hand(In,R,G,B,Out) :-
    % \+ R is B,
    append(N, R1,In),
    number(N,G,T),
    append(` green`,R2,T),
    hand(R2,R,0,B,Out).

hand(In,R,G,B,Out) :-
    % \+ R is G,
    append(N, R1,In),
    number(N,B,T),
    append(` blue`,R2,T),
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