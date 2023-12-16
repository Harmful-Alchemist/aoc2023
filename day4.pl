score2(Lines,Val) :-
    length(Lines,Len),
    copies_original(Len,OrigCopies),
    total(Lines,OrigCopies,TotalCopies,0),
    sum_list(TotalCopies,Val).

total([Line|Lines],A,L,I) :-
    ticket(Line,_,Ns,Ws),
    wins(Ns,Ws,Wins),
    Ii is I + 1,
    updated(Ii,Wins,A,Anew,I),
    total(Lines,Anew,L,Ii).

total([],Acc,Acc,_).

updated(I,Wins,Prev,Updated,TicketI) :-
    Wins > 0,
    Ii is I + 1,
    Winsw is Wins - 1,
    update(I,Prev,Updatedp,TicketI),
    updated(Ii,Winsw,Updatedp,Updated,TicketI).

updated(_,0,X,X,_).

update(I,Old,New,TicketI) :-
    length(Old,L),
    I < L,
    nth0(I,Old,N),
    nth0(TicketI,Old,TicketCopies),
    Nn is N + TicketCopies,
    replace_nth0(Old,I,N,Nn,New). % Right nth0 updates it lol so adds an element to the list :P

replace_nth0(List, Index, OldElem, NewElem, NewList) :- %From https://www.swi-prolog.org/pldoc/man?predicate=nth0/4 comments
   % predicate works forward: Index,List -> OldElem, Transfer
   nth0(Index,List,OldElem,Transfer),
   % predicate works backwards: Index,NewElem,Transfer -> NewList
   nth0(Index,NewList,NewElem,Transfer).

update(I,Old,Old) :-
    length(Old,L),
    I >= L.

wins(Ns,Ws,0) :-
    intersection(Ns,Ws,[]).

wins(Ns,Ws,X) :-
    intersection(Ns,Ws,Is),
    filled(Is),
    length(Is,X).

copies_original(X,[1|Scores]) :-
    X > 0,
    Xx is X - 1,
    copies_original(Xx,Scores).

copies_original(0,[]).

score1([],0).
score1([Line|Lines],Val) :-
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
    write(X), nl,
    score2(Y,Z),
    write(Z), nl.

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