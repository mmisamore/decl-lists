:- include('../prolog/decl_lists.pl').

:- begin_tests(decl_lists).

% Tests for set_member/2

% + +
test('set_member_+_+_impossible', [ fail ]) :-
  set_member(1, []).

test('set_member_+_+_single_soln') :-
  set_member(1, [1, _]).     % single soln, no choicepoint

test('set_member_+_+_only_elt') :-
  set_member(1, [1]).        % no choicepoint

test('set_member_+_+_first_elt') :-
  set_member(1, [1,2]).      % no choicepoint

test('set_member_+_+_later_elt') :-
  set_member(2, [1,2]).      % no choicepoint

test('set_member_+_+_no_dupes') :-
  set_member(1, [1, 2, 1]).  % succeed exactly once, no choicepoint

% + -
test('set_member_+_-_single_soln') :-
  % Query order forces choicepoint
  findall(Xs, ( length(Xs, 2), set_member(1, Xs), Xs = [1, _] ), Ans),
  Ans = [[1,_]]. % single soln

test('set_member_+_-_only_elt') :-
  length(Xs, 1),
  set_member(1, Xs), 
  Xs = [1].

test('set_member_+_-_first_elt') :-
  % Query order forces choicepoint
  findall(Xs, ( Xs = [_, 2], set_member(1, Xs) ), Ans),
  Ans = [[1, 2]].

test('set_member_+_-_later_elt') :-
  Xs = [1, _], 
  set_member(2, Xs),
  Xs = [1, 2].

test('set_member_+_-_no_dupes') :-
  findall(Xs, ( length(Xs, 3), set_member(1, Xs), Xs = [1, 2, 1] ), Ans),
  Ans = [[1,2,1]]. % succeed exactly once

% - +
test('set_member_-_+_impossible', [ fail ]) :-
  set_member(X, []),
  X = 1.

test('set_member_-_+_single_soln') :-
  % Query order forces choicepoint
  findall(X, ( set_member(X, [1, 1]), X = 1 ), Ans),
  Ans = [1]. % single soln

test('set_member_-_+_only_elt') :-
  set_member(X, [1]),
  X = 1.

test('set_member_-_+_first_elt') :-
  % Query order forces choicepoint
  findall(X, ( set_member(X, [1, 2]), X = 1 ), Ans),
  Ans = [1].
  
test('set_member_-_+_later_elt') :-
  set_member(X, [1, 2]),
  X = 2.

test('set_member_-_+_no_dupes') :-
  % No duplicate answers
  findall(X, set_member(X, [1, 2, 1]), Ans),
  Ans = [1, 2].

% - -
test('set_member_-_-_single_soln') :-
  findall(X-Xs, ( length(Xs, 2), set_member(X, Xs), X = 1, Xs = [1, _] ), Ans),
  Ans = [1-[1,_]]. 

test('set_member_-_-_only_elt') :-
  length(Xs, 1),
  set_member(X, Xs),
  Xs = [X].

test('set_member_-_-_first_elt') :-
  findall(X-Xs, ( length(Xs, 2), set_member(X, Xs), X = 1, Xs = [1, 2]), Ans),
  Ans = [1-[1, 2]].

test('set_member_-_-_later_elt') :-
  length(Xs, 2), 
  set_member(X, Xs), 
  X = 2, 
  Xs = [1, 2].

test('set_member_-_-_no_dupes') :-
  findall(X-Xs, ( length(Xs, 3), set_member(X, Xs), X = 1, Xs = [1, 2, 1] ), Ans),
  Ans = [1-[1,2,1]].

:- end_tests(decl_lists).

