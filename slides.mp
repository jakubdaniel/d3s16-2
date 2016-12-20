verbatimtex
%&latex
\documentclass{article}
\usepackage{amsmath}
\usepackage{amssymb}

\begin{document}
etex

input TEX;

u := 15;

w = 12.8cm;
h = 9.6cm;

color blue; blue := (0, 176/255, 240/255);
color darkblue; darkblue := (0, 112/255, 192/255);

color red; red := (240/255, 0, 44/255);
color darkred; darkred := (192/255, 0, 28/255);

color green; green := (44/255, 240/255, 0);
color darkgreen; darkgreen := (28/255, 192/255, 0);

color gray; gray := (192/255, 192/255, 192/255);
color darkgray; darkgray := (86/255, 86/255, 86/255);

path frame;
picture statespace, property, error;
picture F[], F'[], F''[];

frame := (-.5w, -.5h) -- (.5w, -.5h) -- (.5w, .5h) -- (-.5w, .5h) -- cycle;

statespace := image(
  fill bbox(frame) withcolor gray;
);

property := image(
  fill fullcircle scaled 10u withpen pencircle scaled 3pt withcolor green;
  draw fullcircle scaled 10u withpen pencircle scaled 3pt withcolor darkgreen;
);

error := image(
  fill bbox(frame) withcolor darkred;
  fill fullcircle scaled 10u withcolor gray;
  draw fullcircle scaled 10u withpen pencircle scaled 3pt withcolor red;
);

for i=0 upto 4:
  numeric s;
  path e, e', e'';
  path c, c', c'';
  pair o;

  s := (u + 2*i*u);
  c := fullcircle scaled s;
  o := (-2u + .5i*u, -2u + .5i*u);

  e   := fullcircle scaled 1.75u shifted (.5s - .5u, 0);
  e'  := subpath (0, .5length e) of e;
  e'' := subpath (.5length e, length e) of e;
  c'  := ((c cutbefore e cutafter e) rotated 45) -- (reverse (e  cutbefore c  cutafter c ) rotated 45) -- cycle;
  c'' :=
    (reverse (e cutbefore c cutafter c) rotated 45) --
    ((c cutbefore e' rotated -45 cutafter e'') rotated 90) --
    (reverse (e cutbefore c cutafter c) rotated 90) --
    ((c cutbefore e' rotated 45 cutafter e'') rotated 45) --
    cycle
    ;

  F[i] := image(
    fill c shifted o withcolor blue;
    draw c shifted o withpen pencircle scaled 3pt withcolor darkblue;
  );
  F'[i] := image(
    fill c' shifted o withcolor blue;
    draw c' shifted o withpen pencircle scaled 3pt withcolor darkblue;
  );
  F''[i] := image(
    fill c'' shifted o withcolor blue;
    draw c'' shifted o withpen pencircle scaled 3pt withcolor darkblue;
  );
endfor;

numeric i;

i := 0;

def slide(expr c) =
  if i=0  : filenametemplate "0%c.mps"; fi
  if i=10 : filenametemplate  "%c.mps"; fi
  beginfig(i)
    draw c;
    setbounds currentpicture to bbox(frame);
  endfig;
  i := i + 1;
enddef;

slide(image(
  label(btex \Large\bf{Safety Properties} etex, (0, 0));
));

slide(image(
  % background
  label.lrt(btex \Large\bf{What is safety?} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{nothing bad ever happens}\\
\bullet&\text{assertions, null dereference, index out of bounds, \ldots}\\
\bullet&\text{close relation to reachability}\\
\bullet&\text{undecidable in general}\\
\bullet&\text{there are other classes of properties (liveness)}\\
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  label.lrt(btex \Large\bf{How to check safety?} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{model system faithfully (usually capturing state space)}\\
\bullet&\text{graph of all states connected by transitions}\\
\bullet&\text{partition nodes into those that satisfy property and the rest}\\
\bullet&\text{usually also designate initial nodes}\\
\bullet&\text{is any undesirable node reachable from any initial node?}\\
\bullet&\text{model checking}\\
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  label(btex \Large\bf{Traditional Model Checking} etex, (0, 0));
));

  % also, we might want to get a "proof" of safety (explicit model checking does not give us a convenient proof (that would be the explored state space which we would have to re-explore entirely to assess its completeness))
  % a convenient proof should be small (inductive invariant is a nice example: 2 queries: 1st exclusion of err, 2nd inductivity)
slide(image(
  label.lrt(btex \Large\bf{Explicit state model checking} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{maintain a work queue initialised with initial nodes}\\
\bullet&\text{maintain a set of seen nodes}\\
\bullet&\text{until queue empty}\\
\bullet&\text{pop node from queue}\\
\bullet&\text{note violations}\\
\bullet&\text{enqueue all unseen successors, mark as seen}\\
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  label.lrt(btex \Large\bf{Observations} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{remember predecessors for counterexample}\\
\bullet&\text{no compact proof of safety}\\
\bullet&\text{termination not guaranteed (infinite state)}\\
\bullet&\text{bounded model checking (usually symbolic though)}\\
\bullet&\text{depending on type of queue/stack}\\
\bullet&\text{DFS may get stuck in branch never revealing violation}\\
\bullet&\text{BFS runs out of resources before reaching violation}\\
\bullet&\text{bottom line: explicit state is expensive}\\
\bullet&\text{blind exploration until accidentally stumbling upon violation}\\
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  label.lrt(btex \Large\bf{Symbolic model checking} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{work with sets of states instead of individual states}\\
\bullet&\text{use logical formulas to describe sets}\\
% a bit different view: translate the problem into some well known domain for which we have advanced machinery
\bullet&\text{effectively translating model checking into iterated sat}\\
% when a naive sat solver searches for a satisfying assignment it may need to explore all $2^n$ possible assignments
\bullet&\text{similarities between sat and model checking}\\
\bullet&\text{lessons learnt from sat: focus on promising directions}\\
% give up as early as possible when doomed to fail
% we could call it goal-directed search
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  label(btex \Large\bf$\begin{array}{c}\text{Property Directed Reachability}\\\text{(PDR, aka IC3)}\end{array}$ etex, (0, 0));
  label.bot(btex \large{of flat systems (no recursion)} etex, (0, -1.5u));
));

slide(image(
  draw statespace;
  label.llft(btex \Huge\textbf{state space} etex, urcorner(statespace) - (u, u)) withcolor white;
));

slide(image(
  draw statespace;
  draw property;
  label.urt(btex \Huge\textbf{property} etex, urcorner(property) - (u, u)) withcolor darkgreen;
));

slide(image(
  draw error;
  label.ulft(btex \Huge\textbf{bad} etex, ulcorner(property) - (u, u)) withcolor white;
));

slide(image(
  draw error;
  draw F0;
  label.urt(btex \Huge\textbf{initial} etex, urcorner(F0)) withcolor darkblue;
));

slide(image(
  draw error;
  draw F1;
  draw F0;
  label.top(btex \Huge\bf$\begin{array}{c}\text{up to}\\\text{2 steps}\end{array}$ etex, (0, 0)) withcolor darkblue;
  setbounds currentpicture to bbox(frame);
));

slide(image(
  draw error;
  draw F2;
  draw F1;
  draw F0;
  label.top(btex \Huge\bf{3 steps} etex, (0, 2u)) withcolor darkblue;
));

slide(image(
  draw error;
  draw F3;
  draw F2;
  draw F1;
  draw F0;
));

slide(image(
  draw error;
  draw F4;
));

slide(image(
  draw error;
  draw F4;
  ahlength := .3u;
  ahangle := 60;
  drawarrow ((2.75u, 2.75u) {up} .. {right} (4u, 4u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (4u, 4u))) withpen pencircle scaled 2pt withcolor white;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) withcolor darkblue;
  fill fullcircle scaled .5u shifted (4u, 4u) withcolor white;
  label.top(btex \Huge\textbf{bad} etex, (4u, 5.25u)) withcolor white;
));

slide(image(
  draw error;
  draw F4;
  draw F3;
  ahlength := .3u;
  ahangle := 60;
  drawarrow ((2.75u, 2.75u) {up} .. {right} (4u, 4u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (4u, 4u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((1.5u, 1.5u) {up} .. {right} (2.75u, 2.75u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (1.5u, 1.5u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))) withpen pencircle scaled 2pt withcolor white;
  fill fullcircle scaled .5u shifted (1.5u, 1.5u) withcolor darkblue;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) withcolor white;
  fill fullcircle scaled .5u shifted (4u, 4u) withcolor white;
  label.top(btex \Huge\textbf{predecessor} etex, (4u, 5.25u)) withcolor white;
));

slide(image(
  draw error;
  draw F4;
  draw F3;
  draw F2;
  draw F1;
  draw F0;
  ahlength := .3u;
  ahangle := 60;
  drawarrow ((2.75u, 2.75u) {up} .. {right} (4u, 4u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (4u, 4u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((1.5u, 1.5u) {up} .. {right} (2.75u, 2.75u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (1.5u, 1.5u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((.25u, .25u) {up} .. {right} (1.5u, 1.5u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (.25u, .25u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (1.5u, 1.5u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((-1u, -1u) {up} .. {right} (.25u, .25u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (-1u, -1u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (.25u, .25u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((-2u, -2u) {up} .. {right} (-1u, -1u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (-2u, -2u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (-1u, -1u))) withpen pencircle scaled 2pt withcolor white;
  fill fullcircle scaled .5u shifted (-2u, -2u) withcolor white;
  fill fullcircle scaled .5u shifted (-1u, -1u) withcolor white;
  fill fullcircle scaled .5u shifted (.25u, .25u) withcolor white;
  fill fullcircle scaled .5u shifted (1.5u, 1.5u) withcolor white;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) withcolor white;
  fill fullcircle scaled .5u shifted (4u, 4u) withcolor white;
  label.lrt(btex \Huge\textbf{outcome 1} etex, ulcorner(frame)) withcolor white;
  label.top(btex \Huge\textbf{counterexample} etex, (4u, 5.25u)) withcolor white;
));

slide(image(
  draw error;
  draw F4;
  draw F3;
  draw F2;
  ahlength := .3u;
  ahangle := 60;
  drawarrow ((2.75u, 2.75u) {up} .. {right} (4u, 4u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (4u, 4u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((1.5u, 1.5u) {up} .. {right} (2.75u, 2.75u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (1.5u, 1.5u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((0, 0) {up} .. {right} (1.5u, 1.5u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (0, 0))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (1.5u, 1.5u))) withpen pencircle scaled 2pt withcolor white dashed evenly;
  fill fullcircle scaled .5u shifted (1.5u, 1.5u) withcolor darkblue;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) withcolor white;
  fill fullcircle scaled .5u shifted (4u, 4u) withcolor white;
));

slide(image(
  draw error;
  draw F4;
  draw F'3;
  ahlength := .3u;
  ahangle := 60;
  drawarrow ((2.75u, 2.75u) {up} .. {right} (4u, 4u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (4u, 4u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((1.5u, 1.5u) {up} .. {right} (2.75u, 2.75u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (1.5u, 1.5u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))) withpen pencircle scaled 2pt withcolor gray;
  fill fullcircle scaled .5u shifted (1.5u, 1.5u) withcolor gray;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) withcolor darkblue;
  fill fullcircle scaled .5u shifted (4u, 4u) withcolor white;
));

slide(image(
  draw error;
  draw F4;
  draw F'3;
  ahlength := .3u;
  ahangle := 60;
  drawarrow ((2.75u, 2.75u) {up} .. {right} (4u, 4u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (4u, 4u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((-.5u, 2.25u) {dir 30} .. {dir 0} (2.75u, 2.75u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (-.5u, 2.25u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))) withpen pencircle scaled 2pt withcolor white;
  fill fullcircle scaled .5u shifted (-.5u, 2.25u) withcolor darkblue;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) withcolor white;
  fill fullcircle scaled .5u shifted (4u, 4u) withcolor white;
));

slide(image(
  draw error;
  draw F4;
  draw F'3;
  draw F2;
  ahlength := .3u;
  ahangle := 60;
  drawarrow ((2.75u, 2.75u) {up} .. {right} (4u, 4u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (4u, 4u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((-.5u, 2.25u) {dir 30} .. {dir 0} (2.75u, 2.75u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (-.5u, 2.25u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((-1u, .5u) {dir 90} .. {dir 45} (-.5u, 2.25u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (-1u, -1u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (-.5u, 2.25u))) withpen pencircle scaled 2pt withcolor white dashed evenly;
  fill fullcircle scaled .5u shifted (-.5u, 2.25u) withcolor darkblue;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) withcolor white;
  fill fullcircle scaled .5u shifted (4u, 4u) withcolor white;
));

slide(image(
  draw error;
  draw F4;
  draw F''3;
  ahlength := .3u;
  ahangle := 60;
  drawarrow ((2.75u, 2.75u) {up} .. {right} (4u, 4u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (4u, 4u))) withpen pencircle scaled 2pt withcolor white;
  drawarrow ((0, 0) -- (2.75u, 2.75u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (0, 0))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))) withpen pencircle scaled 2pt withcolor white dashed evenly;
  drawarrow ((-.5u, 2.25u) {dir 30} .. {dir 0} (2.75u, 2.75u)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted (-.5u, 2.25u))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted (2.75u, 2.75u))) withpen pencircle scaled 2pt withcolor gray;
  fill fullcircle scaled .5u shifted (-.5u, 2.25u) withcolor gray;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) withcolor darkblue;
  fill fullcircle scaled .5u shifted (4u, 4u) withcolor white;
));

slide(image(
  draw error;
  draw F'4;
));

slide(image(
  draw error;
  draw F'4;
  drawarrow (((2.75u, 2.75u) rotated 45) {dir 135} .. {dir 45} ((4u, 4u) rotated 45)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted ((2.75u, 2.75u) rotated 45))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted ((4u, 4u) rotated 45))) withpen pencircle scaled 2pt withcolor white;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) rotated 45 withcolor darkblue;
  fill fullcircle scaled .5u shifted (4u, 4u) rotated 45 withcolor white;
));

slide(image(
  draw error;
  draw F''4;
));

slide(image(
  draw statespace;
  draw property;
  draw F''4;
  label.lrt(btex \Huge\textbf{outcome 2} etex, ulcorner(frame)) withcolor white;
  label.urt(btex \Huge\textbf{property} etex, urcorner(property) - (u, u)) withcolor darkgreen;
  label(btex \Huge\textbf{invariant} etex, (0, 0)) withcolor white;
));

slide(image(
  label.lrt(btex \Large\bf{Summary of PDR} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{addressed problem generally undecidable}\\
\bullet&\text{apply abstraction as remedy}\\
\bullet&\text{complete decision procedure for finite state}\\
\bullet&\text{directed search as opposed to blind}\\
\bullet&\text{produces certificates (counterexample or invariant)}\\
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  % zooming at the instructions
  % what to do about function calls?
  % summaries
  label.lrt(btex \Large\bf{Closer look} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{until now we assumed atomic instructions}\\
\bullet&\text{what about calls to functions?}\\
\bullet&\text{known functions can be summarised}\\
\bullet&\text{already encoding other instructions as formulas anyway}\\
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  label.lrt(btex \Large\bf{How to summarise functions?} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{relating input to output (ex. $x = x_0 + 1$)}\\
\bullet&\text{exact summary hard to find and not even necessary}\\
\bullet&\text{bracketing}\\
\bullet&\text{underapproximation (ex. $x_0 = 0 \land x = 1$) }\\
\bullet&\text{overapproximation (ex. $x > x_0$)}\\
\bullet&\text{bound recursion depth (iteratively deepen)}\\
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  label.lrt(btex \Large\bf{Possible function overapproximation} etex, (-11u, 8u));
  label.lrt(btex \large
$
\begin{array}{l}
\begin{array}{l}
\text{\tt{function T (ref t) \{}}\\
\text{\qquad\tt{if (t > 0) \{}}\\
\text{\qquad\qquad\tt{t := t - 2}}\\
\text{\qquad\qquad\tt{T(t)}}\\
\text{\qquad\qquad\tt{t := t + 1}}\\
\text{\qquad\tt{\}}}\\
\text{\tt{\}}}\\
\end{array}\\
{}\\
\def\arraystretch{1.4}
\begin{array}{l}
\text{recursion bound 0 $\rightarrow$ only else branch is viable}\\
\text{let's guess \quad $2t \le t_0 \land t \le 0$ \quad or simply \quad $2t \le t_0$}\\
\end{array}
\end{array}
$ etex, (-11u, 6u));
));

slide(image(
  label.lrt(btex \Large\bf{Inductive function overapproximation} etex, (-11u, 8u));
  label.lrt(btex \large
$
\begin{array}{l}
\begin{array}{l}
\text{\tt{function T (ref t) \{}}\\
\text{\qquad\tt{if (t > 0) \{}}\\
\text{\qquad\qquad\tt{t := t - 2}}\\
\text{\qquad\qquad\tt{T(t)}}\\
\text{\qquad\qquad\tt{t := t + 1}}\\
\text{\qquad\tt{\}}}\\
\text{\tt{\}}}\\
\end{array}\\
{}\\
\def\arraystretch{1.4}
\begin{array}{l}
\text{recursion bound 1 $\rightarrow$ replace {\tt T(t)} with its overapproximation}\\
\text{\tt t$_1$ := t$_0$ - 2}\\
\end{array}
\end{array}
$ etex, (-11u, 6u));
));

slide(image(
  label.lrt(btex \Large\bf{Inductive function overapproximation} etex, (-11u, 8u));
  label.lrt(btex \large
$
\begin{array}{l}
\begin{array}{l}
\text{\tt{function T (ref t) \{}}\\
\text{\qquad\tt{if (t > 0) \{}}\\
\text{\qquad\qquad\tt{t := t - 2}}\\
\text{\qquad\qquad\tt{T(t)}}\\
\text{\qquad\qquad\tt{t := t + 1}}\\
\text{\qquad\tt{\}}}\\
\text{\tt{\}}}\\
\end{array}\\
{}\\
\def\arraystretch{1.4}
\begin{array}{l}
\text{recursion bound 1 $\rightarrow$ replace {\tt T(t)} with its overapproximation}\\
\text{\tt t$_1$ := t$_0$ - 2; 2t$_2$ $\le$ t$_1$}\\
\end{array}
\end{array}
$ etex, (-11u, 6u));
));

slide(image(
  label.lrt(btex \Large\bf{Inductive function overapproximation} etex, (-11u, 8u));
  label.lrt(btex \large
$
\begin{array}{l}
\begin{array}{l}
\text{\tt{function T (ref t) \{}}\\
\text{\qquad\tt{if (t > 0) \{}}\\
\text{\qquad\qquad\tt{t := t - 2}}\\
\text{\qquad\qquad\tt{T(t)}}\\
\text{\qquad\qquad\tt{t := t + 1}}\\
\text{\qquad\tt{\}}}\\
\text{\tt{\}}}\\
\end{array}\\
{}\\
\def\arraystretch{1.4}
\begin{array}{l}
\text{recursion bound 1 $\rightarrow$ replace {\tt T(t)} with its overapproximation}\\
\text{\tt t$_1$ := t$_0$ - 2; 2t$_2$ $\le$ t$_1$; t$_3$ := t$_2$ + 1}\\
\end{array}
\end{array}
$ etex, (-11u, 6u));
));

slide(image(
  label.lrt(btex \Large\bf{Inductive function overapproximation} etex, (-11u, 8u));
  label.lrt(btex \large
$
\begin{array}{l}
\begin{array}{l}
\text{\tt{function T (ref t) \{}}\\
\text{\qquad\tt{if (t > 0) \{}}\\
\text{\qquad\qquad\tt{t := t - 2}}\\
\text{\qquad\qquad\tt{T(t)}}\\
\text{\qquad\qquad\tt{t := t + 1}}\\
\text{\qquad\tt{\}}}\\
\text{\tt{\}}}\\
\end{array}\\
{}\\
\def\arraystretch{1.4}
\begin{array}{l}
\text{recursion bound 1 $\rightarrow$ replace {\tt T(t)} with its overapproximation}\\
\text{\tt t$_1$ := t$_0$ - 2; 2t$_2$ $\le$ t$_1$; t$_3$ := t$_2$ + 1}\\
\text{\tt \hphantom{t$_1$ := t$_0$ - 2;} 2t$_2$ $\le$ t$_0$ - 2; t$_3$ := t$_2$ + 1}\\
\end{array}
\end{array}
$ etex, (-11u, 6u));
));

slide(image(
  label.lrt(btex \Large\bf{Inductive function overapproximation} etex, (-11u, 8u));
  label.lrt(btex \large
$
\begin{array}{l}
\begin{array}{l}
\text{\tt{function T (ref t) \{}}\\
\text{\qquad\tt{if (t > 0) \{}}\\
\text{\qquad\qquad\tt{t := t - 2}}\\
\text{\qquad\qquad\tt{T(t)}}\\
\text{\qquad\qquad\tt{t := t + 1}}\\
\text{\qquad\tt{\}}}\\
\text{\tt{\}}}\\
\end{array}\\
{}\\
\def\arraystretch{1.4}
\begin{array}{l}
\text{recursion bound 1 $\rightarrow$ replace {\tt T(t)} with its overapproximation}\\
\text{\tt t$_1$ := t$_0$ - 2; 2t$_2$ $\le$ t$_1$; t$_3$ := t$_2$ + 1}\\
\text{\tt \hphantom{t$_1$ := t$_0$ - 2;} 2t$_2$ $\le$ t$_0$ - 2; t$_3$ := t$_2$ + 1}\\
\text{\tt \hphantom{t$_1$ := t$_0$ - 2;} 2(t$_3$ - 1) $\le$ t$_0$ - 2}\\
\end{array}
\end{array}
$ etex, (-11u, 6u));
));

slide(image(
  label.lrt(btex \Large\bf{Inductive function overapproximation} etex, (-11u, 8u));
  label.lrt(btex \large
$
\begin{array}{l}
\begin{array}{l}
\text{\tt{function T (ref t) \{}}\\
\text{\qquad\tt{if (t > 0) \{}}\\
\text{\qquad\qquad\tt{t := t - 2}}\\
\text{\qquad\qquad\tt{T(t)}}\\
\text{\qquad\qquad\tt{t := t + 1}}\\
\text{\qquad\tt{\}}}\\
\text{\tt{\}}}\\
\end{array}\\
{}\\
\def\arraystretch{1.4}
\begin{array}{l}
\text{recursion bound 1 $\rightarrow$ replace {\tt T(t)} with its overapproximation}\\
\text{\tt t$_1$ := t$_0$ - 2; 2t$_2$ $\le$ t$_1$; t$_3$ := t$_2$ + 1}\\
\text{\tt \hphantom{t$_1$ := t$_0$ - 2;} 2t$_2$ $\le$ t$_0$ - 2; t$_3$ := t$_2$ + 1}\\
\text{\tt \hphantom{t$_1$ := t$_0$ - 2;} 2(t$_3$ - 1) $\le$ t$_0$ - 2}\\
\text{\tt \hphantom{t$_1$ := t$_0$ - 2;} 2t$_3$ $\le$ t$_0$}\\
\end{array}
\end{array}
$ etex, (-11u, 6u));
));

slide(image(
  label(btex \Large\bf$\begin{array}{c}\text{Property Directed Function Summary Discovery}\\\text{(RecMC)}\end{array}$ etex, (0, 0));
));

slide(image(
  label.lrt(btex \Large\bf{RecMC} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{both under/over-approximations of all functions}\\
\bullet&\text{approximations for increasing bound on recursion depth}\\
\bullet&\text{initially $\bot$ under, $\top$ over}\\
\bullet&\text{work list of proof obligations}\\
\bullet&\text{falsify property using under}\\
\bullet&\text{prove property using over}\\
\bullet&\text{learn new approximations}\\
\bullet&\text{stop when over inductive}\\
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  draw statespace;
  draw property;
  label.top(btex \Huge\bf{current function state space} etex, (0, 6.5u)) withcolor white;
  label.bot(btex \Huge\bf{current level property} etex, (0, -6.5u)) withcolor darkgreen;
));

slide(image(
  draw statespace;
  draw property;
  drawdot (-2u,-2u) withpen pencircle scaled 12pt;
  drawdot (-u,0) withpen pencircle scaled 12pt;
  drawdot (u,-.5u) withpen pencircle scaled 12pt;
  drawdot (3u,1.5u) withpen pencircle scaled 12pt;
  drawdot (6u,2u) withpen pencircle scaled 12pt;
  drawarrow (((-2u, -2u) -- (-u, 0)) cutafter (fullcircle scaled 12pt shifted (-u, 0))) withpen pencircle scaled 3pt;
  drawarrow (((-u, 0) -- (u, -.5u)) cutafter (fullcircle scaled 12pt shifted (u, -.5u))) withpen pencircle scaled 3pt;
  drawarrow (((u, -.5u) -- (3u, 1.5u)) cutafter (fullcircle scaled 12pt shifted (3u, 1.5u))) withpen pencircle scaled 3pt;
  drawarrow (((3u, 1.5u) -- (6u, 2u)) cutafter (fullcircle scaled 12pt shifted (6u, 2u))) withpen pencircle scaled 3pt;
  label.rt(btex \huge\bf{under} etex, (6.5u, 2.25u));
  label.top(btex \Huge\bf{current function state space} etex, (0, 6.5u)) withcolor white;
  label.bot(btex \Huge\bf{falsified, update under} etex, (0, -6.5u)) withcolor darkred;
));

slide(image(
  draw statespace;
  draw property;
  s := (u + 2*4*u);
  c := fullcircle scaled s;
  o := (-2u + .5*4*u, -2u + .5*4*u);
  fill c shifted o withcolor .5white;
  draw c shifted o withpen pencircle scaled 3pt;
  label(btex \huge\bf{over} etex, (0, 0));
  label.top(btex \Huge\bf{current function state space} etex, (0, 6.5u)) withcolor white;
  label.bot(btex \Huge\bf{proven, update over} etex, (0, -6.5u)) withcolor darkblue;
));

slide(image(
  draw statespace;
  draw property;
  s := (u + 2*4*u);
  c := fullcircle scaled s;
  o := (-2u + .5*4*u, -2u + .5*4*u);
  fill c shifted o withcolor .5white;
  draw c shifted o withpen pencircle scaled 3pt;
  drawarrow (((-2u, -2u) -- (-u, 0)) cutafter (fullcircle scaled 12pt shifted (-u, 0))) withpen pencircle scaled 3pt withcolor .25white;
  drawarrow (((-u, 0) -- (u, -.5u)) cutafter (fullcircle scaled 12pt shifted (u, -.5u))) withpen pencircle scaled 3pt withcolor .25white;
  drawarrow (((u, -.5u) -- (3u, 1.5u)) cutafter (fullcircle scaled 12pt shifted (3u, 1.5u))) withpen pencircle scaled 3pt;
   drawarrow (((3u, 1.5u) -- (6u, 2u)) cutafter (fullcircle scaled 12pt shifted (6u, 2u))) withpen pencircle scaled 3pt withcolor .25white;
  drawdot (-2u,-2u) withpen pencircle scaled 12pt withcolor .25white;
  drawdot (-u,0) withpen pencircle scaled 12pt withcolor .25white;
  drawdot (u,-.5u) withpen pencircle scaled 12pt;
  drawdot (3u,1.5u) withpen pencircle scaled 12pt;
  drawdot (6u,2u) withpen pencircle scaled 12pt withcolor .25white;
  label(btex \Large\textbf{f($\overline{\text{a}}$)} etex, (u, u));
  label.top(btex \Huge\bf{current function state space} etex, (0, 6.5u)) withcolor white;
  label.bot(btex \Huge\bf{derive target property for f} etex, (0, -6.5u));
));

slide(image(
  label.lrt(btex \Large\bf{Language} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{PDR+RecMC expressed in terms of states, sets, relations}\\
\bullet&\text{formulas in appropriate theories}\\
\bullet&\text{in general any finite domain as in abstract interpretation}\\
\end{array}
$ etex, (-11u, 0));
));

slide(image(
  label.lrt(btex \Large\bf{Domains} etex, (-11u, 8u));
  % all of this works for any finite domain (may diverge for infinite state - to be expected in light of undecidability of the problem)
  % linear interger arithmetic domain
  % future: domains for capturing properties of data containers
  label.lrt(btex \large\bf{Linear Integer Arithmetic Domain} etex, (-11u, 6u));
  label.lrt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{abstraction predicates $P$ induce finite state space}\\
\bullet&\text{states: conjunction of $P$ and $\neg P$}\\
\bullet&\text{set of states: arbitrary formula over $X$}\\
\bullet&\text{relation: arbitrary formula over $X$ and $X'$}\\
\end{array}
$ etex, (-11u, 5u));
  label.lrt(btex \large\bf{Data Container Domain} etex, (-11u, -3u));
  label.lrt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{our future direction}\\
\bullet&\text{properties of data not memory layout}\\
\end{array}
$ etex, (-11u, -4u));
));

slide(image(
  label.lrt(btex \Large\bf{Conclusion} etex, (-11u, 8u));
  label.rt(btex \large
$
\def\arraystretch{1.5}
\begin{array}{cl}
\bullet&\text{developing \textbf{bacon}}\\
\bullet&\text{implementing PDR, RecMC}\\
\bullet&\text{allows custom elementary domains}\\
\bullet&\text{provides composition of domains}\\
% (currently cross product with option of added custom constraints)
\bullet&\text{about 3000 of mighty Haskell source lines}\\
\end{array}
$ etex, (-11u, 0));
));

end

verbatimtex
\end{document}
etex

.
