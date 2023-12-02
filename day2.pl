number([H1,H2,H3|Out], Out, Val) :-
    digit(H1,Val1),
    digit(H2, Val2),
    digit(H3, Val3),
    Val is 100 * Val1 + 10 * Val2 + Val3.

number([H1,H2|Out], Out, Val) :-
    digit(H1,Val1),
    digit(H2, Val2),
    Val is 10 * Val1 + Val2.

number([H|Out], Out, Val) :-
    digit(H,Val).

digit(49,1).
digit(50,2).
digit(51,3).
digit(52,4).
digit(`5`,5).
digit(`6`,6).
digit(`7`,7).