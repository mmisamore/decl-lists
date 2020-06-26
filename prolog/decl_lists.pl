:- use_module(library(clpfd)).
:- use_module(library(reif_utils)).
:- use_module('../reif.pl').

%! set_member(+X, +Xs:list) is semidet.
%! set_member(+X, -Xs:list) is multi.
%! set_member(-X, +Xs:list) is multi.
%! set_member(-X, -Xs:list) is multi.
%
% True whenever `X` is a member of the underlying set of the list `Xs`. The -/+ mode assumes that 
% `Xs` is non-empty to have solutions, and only distinct elements of the underlying set are
% enumerated.
%
% This definition corrects for several deficiencies in other implementations of member/2:
% 1. Proper set-theoretic semantics for the -/+ mode (cf. SWI Prolog implementation)
%    e.g. no duplicate solutions to set_member(1, [1,2,3,1]).
% 2. No extra solutions for set_member(1, [1, X]) (cf. SWI Prolog implementation)
% 3. set_member(1, [1,2,3]) does not leave an extra choicepoint (cf. SWI Prolog implementation)
% 4. set_member(1, [X]) succeeds leaving no extra choicepoints (cf. memberd from "Indexing dif/2" by Neumerkel/Kral)
% 5. set_member(X, [Y]) succeeds leaving no extra choicepoints (cf. memberd from "Indexing dif/2" by Neumerkel/Kral)
%
% This new implementation was inspired by Neumerkel and Kral's excellent paper "Indexing dif/2"
% which introduced the fundamental tool: if_/3.
set_member(X, [Y|Ys]) :-
  if_(Ys = [], X = Y,
    if_(X = Y, true, set_member(X, Ys))). 


% Under consideration for this library: 
%prefix(?Part, ?Whole)
%select(?Elem, ?List1, ?List2)
%nextto(?X, ?Y, ?List)
    %True if Y directly follows X in List.
%[det]delete(+List1, @Elem, -List2)
%nth0(?Index, ?List, ?Elem)
%nth1(?Index, ?List, ?Elem)
%[det]nth0(?N, ?List, ?Elem, ?Rest)
%[det]nth1(?N, ?List, ?Elem, ?Rest)
    %As nth0/4, but counting starts at 1.
%last(?List, ?Last)
%[semidet]proper_length(@List, -Length)
%same_length(?List1, ?List2)
%reverse(?List1, ?List2)
%[nondet]permutation(?Xs, ?Ys)
%[det]flatten(+NestedList, -FlatList)
%[semidet]max_member(-Max, +List)
%[semidet]min_member(-Min, +List)
%[det]sum_list(+List, -Sum)
%[semidet]min_list(+List:list(number), -Min:number)
%[semidet]numlist(+Low, +High, -List)
%[semidet]is_set(@Set)
%[det]intersection(+Set1, +Set2, -Set3)
%[det]union(+Set1, +Set2, -Set3)
%[semidet]subset(+SubSet, +Set)
%[det]subtract(+Set, +Delete, -Result)

