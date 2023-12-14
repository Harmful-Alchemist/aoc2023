main :- 
    open('day3_ex.txtpl',read,Str),
    read_lines(Str,Y).
    % sum_games(Y,X,[]),
    % sum_games2(Y,Z,[]),
    % close(Str),
    % write(X), nl,
    % write(Z), nl.

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

% info(Line,CurrentIndex,Symbols,Numbers,Remaining).

% Is ambiguous of course, hmm......
info([],0,[],[],[]).

info([S|Out],I,[I|A],B,[]) :-
    \+ number(S,_,[]),
    symbol(S),
    info(Out,Ii,A,B,[]),
    I is Ii + 1.

info([N1,N2,N3|Out],Iend,[Istart,Imiddle,Iend|A],[Istart,Iend,Val|B],[]) :-
    number([N1,N2,N3],Val,[]),
    info(Out,Ii,A,B,[]),
    Istart is Ii + 1,
    Imiddle is Ii +2,
    Iend is Ii + 3.

info([N1,N2|Out],Iend,[Istart,Iend|A],[Istart,Iend,Val|B],[]) :-
    number([N1,N2],Val,[]),
    info(Out,Ii,A,B,[]),
    Istart is Ii + 1,
    Iend is Ii + 2.

info([N|Out],I,[I|A],[I,I,Val|B],[]) :-
    number([N],Val,[]),
    info(Out,Ii,A,B,[]),
    I is Ii + 1.

info([S|Out],I,A,B,[]) :-
    \+ symbol(S),
    \+ number(S,_,[]),
    info(Out,Ii,A,B,[]),
    I is Ii + 1.

% 46 is ascii dot
symbol(S) :- 
    S < 46.

symbol(S) :- 
    S > 46.

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