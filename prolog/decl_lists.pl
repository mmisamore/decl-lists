:- use_module(library(clpfd)).
:- use_module(library(reif_utils)).
:- use_module('../reif.pl').

%! set_member(+X, +Xs:list) is semidet.
%! set_member(+X, -Xs:list) is multi.
%! set_member(-X, +Xs:list) is nondet.
%! set_member(-X, -Xs:list) is multi.
%
% True whenever `X` is a member of the underlying set of the list `Xs`. Only distinct elements of 
% the underlying set are enumerated.
%
% This definition corrects for several deficiencies in other implementations of member/2:
% 1. Proper set-theoretic semantics for the -/+ mode (cf. SWI Prolog implementation)
%    e.g. no duplicate solutions to set_member(1, [1,2,3,1]).
% 2. No extra solutions for set_member(1, [1, X]) (cf. SWI Prolog implementation)
% 3. set_member(1, [1,2,3]) does not leave an extra choicepoint (cf. SWI Prolog implementation)
% 4. set_member(1, [X]) succeeds leaving no extra choicepoints (cf. memberd/2 from "Indexing dif/2" by Neumerkel/Kral)
% 5. set_member(X, [Y]) succeeds leaving no extra choicepoints (cf. memberd/2 from "Indexing dif/2" by Neumerkel/Kral)
%
% This new implementation was inspired by Neumerkel and Kral's excellent paper "Indexing dif/2"
% which introduced the fundamental tool: if_/3.
set_member(X, [Y|Ys]) :-
  if_(Ys = [], X = Y,
    if_(X = Y, true, set_member(X, Ys))).

%! is_a_list(+Xs:list) is semidet.
%! is_a_list(-Xs:list) is multi.
%
% True whenever `Xs` is a list. Supports both + and - modes (cf. SWI Prolog's is_list/1).
is_a_list(Xs) :-
  if_(Xs = [], true,
      (Xs = [_|Ys], is_a_list(Ys))).

 
% Helper predicate
plus(X, Y, Z) :- Z #= X + Y.
 
%! list_sum(++Xs:numlist, +X:number) is semidet.
%! list_sum(++Xs:numlist, -X:number) is det.
%
%! list_sum(+Xs:intlist, +X:int) is semidet.
%! list_sum(+Xs:intlist, -X:int) is det.
%! list_sum(-Xs:intlist, +X:int) is multi.
%! list_sum(-Xs:intlist, -X:int) is multi.
%
% True whenever a list of numbers `Xs` sums to `X`. This predicate supports all modes 
% (cf. SWI Prolog's sum_list/2), but only works for integers when `Xs` is not ground. This is 
% primarily because the implementation relies on clp(Z). More general domains are not supported
% at this time.
list_sum(Xs, X) :-
  (  ground(Xs)
  -> sum_list(Xs, X)
  ;  is_a_list(Xs),
     Xs ins inf..sup,
     foldl(plus, Xs, 0, X)
   ).

% Under consideration for this library: 
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

