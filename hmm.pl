% main :- 
%     open('houses.txt',read,Str),
%     read(Str,House1),
%     read(Str,House2),
%     read(Str,House3),
%     read(Str,House4),
%     close(Str),
%     write([House1,House2,House3,House4]), nl.

main :- 
    open('houses.txt',read,Str),
    read_houses(Str,Houses),
    close(Str),
    write(Houses), nl.

read_houses(Stream,[]) :-
    at_end_of_stream(Stream).

read_houses(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_houses(Stream,L).