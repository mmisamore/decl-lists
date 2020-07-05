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


% Tests for is_a_list/1 

% +
test('is_a_list_+_nonlist', [ fail ]) :-
  is_a_list(1).

test('is_a_list_+_empty') :-
  is_a_list([]).

test('is_a_list_+_singleton') :-
  is_a_list([1]).

test('is_a_list_+_multi') :-
  is_a_list([1,2]).

% -
test('is_a_list_-_empty') :-
  % Query order forces choicepoint
  findall(Xs, (N #>= 0, N #=< 2, indomain(N), length(Xs, N), is_a_list(Xs)), Ans),
  set_member([], Ans).

test('is_a_list_-_singleton') :-
  % Query order forces choicepoint
  findall(Xs, (N #>= 0, N #=< 2, indomain(N), length(Xs, N), is_a_list(Xs), Xs = [1]), Ans),
  Ans = [[1]]. 

test('is_a_list_-_multi') :-
  % Query order forces choicepoint
  findall(Xs, (N #>= 0, N #=< 2, indomain(N), length(Xs, N), is_a_list(Xs), Xs = [1,2]), Ans),
  Ans = [[1,2]].

test('is_a_list_-_returns_all_lists') :-
  findall(Xs, (N #>= 0, N #=< 2, indomain(N), length(Xs, N), is_a_list(Xs)), Ans),
  length(Ans, 3).

% Tests for list_sum/2 

% + +
test('list_sum_+_+_doesnt_sum', [ fail ]) :-
  list_sum([1,2,3], 3).

test('list_sum_+_+_empty') :-
  list_sum([], 0).

test('list_sum_+_+_singleton') :-
  list_sum([1], 1).

test('list_sum_+_+_multi') :-
  list_sum([1,2], 3).

test('list_sum_+_+_nonint') :-
  list_sum([1.2, 2.3], 3.5).

test('list_sum_+_+_nonground_list') :-
  list_sum([1, _], 3).

% + -
test('list_sum_+_-_doesnt_sum', [ fail ]) :-
  list_sum([1,2,3], X),
  X = 3.

test('list_sum_+_-_empty') :-
  list_sum([], X),
  X = 0.

test('list_sum_+_-_singleton') :-
  list_sum([1], X),
  X = 1.

test('list_sum_+_-_multi') :-
  list_sum([1,2], X),
  X = 3.

test('list_sum_+_-_nonint') :-
  list_sum([1.2, 2.3], X),
  X = 3.5.

test('list_sum_+_-_nonground_list') :-
  list_sum([1, _], X),
  X = 3.

% - +
test('list_sum_-_+_doesnt_sum', [ fail ]) :-
  length(Xs, 3),
  list_sum(Xs, 3),
  Xs = [1,2,3].

test('list_sum_-_+_empty') :-
  findall(Xs, (N #>= 0, N #=< 1, indomain(N), length(Xs, N), list_sum(Xs, 0)), Ans),
  set_member([], Ans). 

test('list_sum_-_+_singleton') :-
  length(Xs, 1), 
  list_sum(Xs, 1),
  Xs = [1].

test('list_sum_-_+_multi') :-
  length(Xs, 2),
  list_sum(Xs, 1),
  Xs = [-2, 3].

test('list_sum_-_+_nonground_list') :-
  length(Xs, 2),
  list_sum(Xs, 2),
  Xs = [1, _].

% - -
test('list_sum_-_-_doesnt_sum', [ fail ]) :-
  length(Xs, 3),
  list_sum(Xs, X),
  Xs = [1,2,3],
  X  = 3.

test('list_sum_-_-_empty') :-
  findall(Xs-X, (N #>= 0, N #=< 1, indomain(N), length(Xs, N), list_sum(Xs, X)), Ans),
  set_member([]-0, Ans). 

test('list_sum_-_-_singleton') :-
  length(Xs, 1),
  list_sum(Xs, X),
  Xs = [1],
  X = 1.

test('list_sum_-_-_multi') :-
  length(Xs, 2),
  list_sum(Xs, X),
  Xs = [-2,3],
  X  = 1.

test('list_sum_-_-_nonground_list') :-
  length(Xs, 2),
  list_sum(Xs, X),
  Xs = [1, _],
  X  = 2.

:- end_tests(decl_lists).

