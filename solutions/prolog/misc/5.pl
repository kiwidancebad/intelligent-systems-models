write_list_str([]) :- !.
write_list_str([H|T]) :- 
    write_str(H),
    nl,
    write_list_str(T).

write_str([]) :- !.
write_str([H|Tail]) :- 
    put(H),
    write_str(Tail).

perm_list([], []).
perm_list(L, [H|P]):-
    select(H, L, NL),
    perm_list(NL, H, P).
perm_list([], _, []).
perm_list(L, H, [I|P]):-
    select(I, L, NL),
    perm_list(NL, I, P).

build_perm(Set, [], _).
build_perm(Set, [H|T], Dup):- member(H, Set), not(member(H, Dup)), build_perm(Set, T, [H|Dup]).
perm(Set, N, Res):- length(Res, N), build_perm(Set, Res, []).

repeater(A, K, Rep1, Rep2, Rest):- 
    member(E1, A), repeat(E1, K, Rep1), del_elem(E1, A, A1), 
    member(E2, A1), repeat(E2, K, Rep2), del_elem(E2, A1, Rest).
    
repeat(El, K, Res):- repeat(El, K, 0, [], Res).
repeat(El, K, K, List, List):- !.
repeat(El, K, I, List, Res):- NextI is I + 1, repeat(El, K, NextI, [El|List], Res), !.

del_elem(El, List, Res):- del_elem(El, List, [], Res).
del_elem(_, [], List, List):- !.
del_elem(El, [El|T], List, Res):- del_elem(El, T, List, Res), !.
del_elem(El, [H|T], List, Res):- del_elem(El, T, [H|List], Res), !.

sol(A, N, K, L):- 
    repeater(A, K, Rep1, Rep2, Rest), 
    NK is N - K - K, 
    perm(Rest, NK, RestPerm), 
    append(Rep1, Rep2, RepUnion2),
    
    
    append(RepUnion2, RestPerm, Union),
    perm_list(Union, L).

main(A,N,K,BACK):- bagof(RES,sol(A,N,K,RES),BACK).

removeDupl(List, Res):- removeDupl(List, [], Res).
removeDupl([], Res, Res):-!.
removeDupl([H|T], Dup, Res):- not(member(H, Dup)), removeDupl(T, [H|Dup], Res), !.
removeDupl([H|T], Dup, Res):- removeDupl(T, Dup, Res), !.

start :-
    main([a,b,c,d,e,f],5,2,BACK),
    removeDupl(BACK, RES),
    tell('output_5.txt'),
    write_list_str(RES),
    told.