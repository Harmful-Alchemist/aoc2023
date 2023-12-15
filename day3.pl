main :- 
    open('day3.txtpl',read,Str),
    read_lines(Str,Y),
    % X is 4361, % Ok sure it finds the correct answer but also more.....
    partno([``|Y],X), % add the empty line to have comparison for 1st line
    % close(Str),
    gears_no([``|Y],Z),
    write(X), nl,
    write(Z), nl.

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

% partno([Line], [Val])
% partno([],0).

% gear(AsteriskI,[S1,E1,N1],[S2,E2,N2],Val) :- %Adjacent on same line.
%     AsteriskI is E1 + 1,
%     AsteriskI is S2 - 1,
%     Val is N1 * N2.


% gears_no([`467..114..`,`...*......`,`..35..633.`],X).
% Oh bah exactly two adjcent....
gear(AsteriskI,[S1,E1,N1],[S2,E2,N2],Val) :- 
    \+ same_number([S1,E1,N1],[S2,E2,N2]),
    AsteriskI >= S1 - 1,
    AsteriskI =< E1 + 1,
    AsteriskI >= S2 - 1,
    AsteriskI =< E2 + 1,
    Val is N1 * N2.

same_number([S,E,N],[S,E,N]).

gears(_,[_,_,_],[],0).

gears(I,N1,[S2,E2,N2|_More],Val) :-
    % write(N1),nl,
    gear(I,N1,[S2,E2,N2],Val).
    % write(N),nl,
    % gears(I,N1,More,Valp), %only if no other 2 number make a gear with an asterisk
    % Val is Valp + N.

gears(I,N1,[S2,E2,N2|More],Val) :-
    \+ gear(I,N1,[S2,E2,N2],_),
    gears(I,N1,More,Val).

gears_more(_,[],_,0).

gears_more(I,[S1,E1,N1|More],N2,Val) :-
    gears(I,[S1,E1,N1],N2,Valn),
    gears_more(I,More,N2,Valp),
    % Valp is Valn,
    write(Valn),nl,write(Valp),nl,
    Val is Valp + Valn.

% gears_more(I,[S1,E1,N1|More],N2,Val) :-
%     \+ gears(I,[S1,E1,N1],N2,_),
%     gears_more(I,More,N2,Val).


gears_all([],_,0).
gears_all([I|Is],Ns,Val) :-
    gears_more(I,Ns,Ns,Valn),
    gears_all(Is,Ns,Valp),
    Val is Valn/2 + Valp. % We get them from both numbers...

gears_no([],0).

gears_no([L1,L2,L3|More],Val) :-
    % \+ empty(More), % TODO when empty! Altho...
    info(L1,_,_,N1,_,[]),
    info(L2,_,_,N2,G2,[]),
    info(L3,_,_,N3,_,[]),
    combi(N1,N2,N3,Ns),
    gears_all(G2,Ns,Valn),
    gears_no([L2,L3|More],Valp),
    Val is Valn + Valp.

gears_no([L1,L2],Val) :-
    info(L1,_,_,N1,G1,[]),
    info(L2,_,_,N2,G2,[]),
    append(N1,N2,Ns),
    gears_all(G1,Ns,Val1),
    gears_all(G2,Ns,Val2),
    Val is Val1 + Val2.

gears_no([L],Val) :-
    info(L,_,_,N,G,[]),
    gears_all(G,N,Val).

combi(L1,L2,L3,CL) :-
    append(L1,L2,N),
    append(N,L3,CL).

partno([L],Val) :-
    info(L,_,S,N,_,[]),
    parts_adjacent(S,N,Val,_).

partno([L1,L2],Val) :-
    info(L1,_,S1,N1,_,[]),
    info(L2,_,S2,N2,_,[]),
    parts_adjacent(S1,N1,Val1a,N1_1),
    parts_diag(S2,N1_1,Val1d,_),
    parts_adjacent(S2,N2,Val2,_),
    Val is Val2 + Val1a + Val1d.

partno([L1,L2,L3|More],Val) :-
    info(L1,_,S1,_,_,[]),
    info(L2,_,S2,N2,_,[]),
    info(L3,_,S3,_,_,[]),
    parts_adjacent(S2,N2,A,Nn),
    parts_diag(S1,Nn,B,Nnn),
    parts_diag(S3,Nnn,C,_),
    partno([L2,L3|More],Valp),
    \+ empty(More),
    Val is Valp + A + B + C.

partno([L1,L2,L3|More],Val) :-
    info(L1,_,S1,_,_,[]),
    info(L2,_,S2,N2,_,[]),
    info(L3,_,S3,N3,_,[]),
    parts_adjacent(S2,N2,A,Nn),
    parts_diag(S1,Nn,B,Nnn),
    parts_diag(S3,Nnn,C,_),
    empty(More),
    parts_adjacent(S3,N3,D,N3_1),
    parts_diag(S2,N3_1,E,_),
    Val is A + B + C + D + E.

empty([]).

parts_adjacent(_,[],0,[]).

parts_adjacent(Symbols,[StartN,_,N|More],Val,RemN) :-
    Before is StartN -1,
    member(Before,Symbols),
    parts_adjacent(Symbols,More,Vp,RemN),
    Val is Vp + N.

parts_adjacent(Symbols,[_,EndN,N|More],Val,RemN) :-
    After is EndN + 1,
    member(After,Symbols),
    parts_adjacent(Symbols,More,Vp,RemN),
    Val is Vp + N.

parts_adjacent(Symbols,[StartN,EndN,N|More],Val,[StartN,EndN,N|RemP]) :-
    Before is StartN -1,
    \+ member(Before,Symbols),
    After is EndN + 1,
    \+ member(After,Symbols),
    parts_adjacent(Symbols,More,Val,RemP).

parts_diag(_,[],0,[]).

parts_diag(Symbols,[StartN,EndN,N|More],Val,RemN) :-
    Start is StartN - 1,
    End is EndN + 1,
    parts_diag(Symbols,More,Valp,RemN),
    contains_bound(Start, End,Symbols),
    Val is Valp + N.

parts_diag(Symbols,[StartN,EndN,N|More],Val,[StartN,EndN,N|RemP]) :-
    Start is StartN - 1,
    End is EndN + 1,
    \+ contains_bound(Start, End,Symbols),
    parts_diag(Symbols,More,Val,RemP).
    % RemN is [StartN,EndN,N|RemP].

contains_bound(Min,Max,[S|_]) :-
    S =< Max,
    S >= Min.

contains_bound(Min,Max,[_|Symbols]) :-
    contains_bound(Min,Max,Symbols).

% info(Line,CurrentIndex,Symbols,Numbers,Remaining).
info([],0,[],[],[],[]).

info([S|Out],I,[I|A],B,C,[]) :-
    symbol(S),
    \+ asterisk(S),
    info(Out,Ii,A,B,C,[]),
    I is Ii + 1.

info([S|Out],I,[I|A],B,[I|C],[]) :-
    symbol(S),
    asterisk(S),
    info(Out,Ii,A,B,C,[]),
    I is Ii + 1.

info([N1,N2,N3|Out],Iend,[Istart,Imiddle,Iend|A],[Istart,Iend,Val|B],C,[]) :-
    number([N1,N2,N3],Val,[]),
    info(Out,Ii,A,B,C,[]),
    Istart is Ii + 1,
    Imiddle is Ii +2,
    Iend is Ii + 3.

info([N1,N2],Iend,[Istart,Iend|A],[Istart,Iend,Val|B],C,[]) :-
    number([N1,N2],Val,[]),
    info([],Ii,A,B,C,[]),
    Istart is Ii + 1,
    Iend is Ii + 2.

info([N1,N2,N3|Out],Iend,[Istart,Iend|A],[Istart,Iend,Val|B],C,[]) :-
    \+ number([N1,N2,N3],Val,[]),
    number([N1,N2],Val,[]),
    info([N3|Out],Ii,A,B,C,[]),
    Istart is Ii + 1,
    Iend is Ii + 2.

info([N],I,[I|A],[I,I,Val|B],C,[]) :-
    number([N],Val,[]),
    info([],Ii,A,B,C,[]),
    I is Ii + 1.

info([N, N2|Out],I,[I|A],[I,I,Val|B],C,[]) :-
    \+ number([N,N2],Val,[]),
    number([N],Val,[]),
    info([N2|Out],Ii,A,B,C,[]),
    I is Ii + 1.

info([S|Out],I,A,B,C,[]) :-
    dot(S),
    info(Out,Ii,A,B,C,[]),
    I is Ii + 1.


asterisk(S) :-
    S is 42.
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