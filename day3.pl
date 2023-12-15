main :- 
    open('day3_ex.txtpl',read,Str),
    read_lines(Str,Y),
    % X is 4361, % Ok sure it finds the correct answer but also more.....
    partno(Y,X),
    % close(Str),
    write(X), nl.

% Write a quick grammar?
% Sum : Partnumber Partnumber Sum { $1 + $2 + Sum }
%   | e { 0 } 
% PartNumber : Symbol Number
%   | Number Symbol
%   | Filling[n] Filling* \n Filling[n] Number Filling*  This would be diagonal above
%  TODO then troubles since need Number length? Not so hard < 10 -> 1 etc
% Symbol : non-digit non-number terminal
% Filling : any none whitespace character 
% Number : Digit | Digit Digit | Digit Digit Digit 
% Digit : 0|..|9
% Meh don't like it, are the lines constant length? Yes, but whatever
% How about a line has a relation to symbol indices and number indices(as a list)

% partNo([Line], [Val])
partno([],0).

partno([Linep, Line|Lines],Val) :-
    info(Linep,_,Symbols,_,[]),
    info(Line,_,Symbolsl,Numbers,[]),
    parts_adjacent(Symbolsl,Numbers,Vala), %TODO more like filter adjecent numbers from it to not count double
    parts_diag(Symbols,Numbers,Valc),
    partno(Lines,Valp), % processed linep?
    Val is Valc + Valp + Vala.

partno([Line, Linep|Lines],Val) :-
    info(Linep,_,Symbols,_,[]),
    info(Line,_,Symbolsl,Numbers,[]),
    parts_adjacent(Symbolsl,Numbers,Vala), %TODO more like filter adjecent numbers from it to not count double
    parts_diag(Symbols,Numbers,Valc),
    partno([Linep | Lines],Valp),
    Val is Valc + Valp + Vala.

partno([Line],Val) :-
    info(Line,_,Symbols,Numbers,[]),
    parts_adjacent(Symbols,Numbers,Val).
    % partno(Lines,Valp),
    % Val is Valc + Valp.

% partno([Line|Lines],Val) :- 
%     info(Line,_,Symbols,Numbers,[]),
%     \+ parts_adjacent(Symbols,Numbers,_),
%     partno(Lines,Val).

% partno([Line1,Line2|Lines],Val) :- 
%     info(Line1,_,Symbols1,Numbers1,[]),
%     info(Line2,_,Symbols2,Numbers2,[]),
%     \+ parts_diag(Symbols1,Numbers2,_),
%     \+ parts_diag(Symbols2,Numbers1,_),
%     partno([Line2|Lines],Val).

% Double count with diag?
parts_adjacent(_,[],0).

parts_adjacent(Symbols,[StartN,_,N|More],Val) :-
    Before is StartN -1,
    member(Before,Symbols),
    parts_adjacent(Symbols,More,Vp),
    Val is Vp + N.

parts_adjacent(Symbols,[_,EndN,N|More],Val) :-
    After is EndN + 1,
    member(After,Symbols),
    parts_adjacent(Symbols,More,Vp),
    Val is Vp + N.

parts_adjacent(Symbols,[StartN,EndN,_|More],Val) :-
    Before is StartN -1,
    \+ member(Before,Symbols),
    After is EndN + 1,
    \+ member(After,Symbols),
    parts_adjacent(Symbols,More,Val).

parts_diag(_,[],0).

parts_diag(Symbols,[StartN,EndN,N|More],Val) :-
    Start is StartN - 1,
    End is EndN + 1,
    parts_diag(Symbols,More,Valp),
    contains_bound(Start, End,Symbols),
    Val is Valp + N.

parts_diag(Symbols,[StartN,EndN,_|More],Val) :-
    Start is StartN - 1,
    End is EndN + 1,
    \+ contains_bound(Start, End,Symbols),
    parts_diag(Symbols,More,Val).

contains_bound(Min,Max,[S|_]) :-
    S =< Max,
    S >= Min.

contains_bound(Min,Max,[_|Symbols]) :-
    contains_bound(Min,Max,Symbols).

% info(Line,CurrentIndex,Symbols,Numbers,Remaining).
info([],0,[],[],[]).

info([S|Out],I,[I|A],B,[]) :-
    symbol(S),
    info(Out,Ii,A,B,[]),
    I is Ii + 1.

info([N1,N2,N3|Out],Iend,[Istart,Imiddle,Iend|A],[Istart,Iend,Val|B],[]) :-
    number([N1,N2,N3],Val,[]),
    info(Out,Ii,A,B,[]),
    Istart is Ii + 1,
    Imiddle is Ii +2,
    Iend is Ii + 3.

info([N1,N2],Iend,[Istart,Iend|A],[Istart,Iend,Val|B],[]) :-
    number([N1,N2],Val,[]),
    info([],Ii,A,B,[]),
    Istart is Ii + 1,
    Iend is Ii + 2.

info([N1,N2,N3|Out],Iend,[Istart,Iend|A],[Istart,Iend,Val|B],[]) :-
    \+ number([N1,N2,N3],Val,[]),
    number([N1,N2],Val,[]),
    info([N3|Out],Ii,A,B,[]),
    Istart is Ii + 1,
    Iend is Ii + 2.

info([N],I,[I|A],[I,I,Val|B],[]) :-
    number([N],Val,[]),
    info([],Ii,A,B,[]),
    I is Ii + 1.

info([N, N2|Out],I,[I|A],[I,I,Val|B],[]) :-
    \+ number([N,N2],Val,[]),
    number([N],Val,[]),
    info([N2|Out],Ii,A,B,[]),
    I is Ii + 1.

info([S|Out],I,A,B,[]) :-
    dot(S),
    info(Out,Ii,A,B,[]),
    I is Ii + 1.



% 46 is ascii dot
dot(S) :-
    S is 46.

symbol(S) :- 
    S < 46.

symbol(S) :-
    S is 47. % /

% Skip numbers
symbol(S) :- 
    S > 57.

read_lines(Stream,[]) :-
    at_end_of_stream(Stream).

read_lines(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream), %https://en.wikipedia.org/wiki/Prolog#Negation
    read(Stream,X),
    read_lines(Stream,L).

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