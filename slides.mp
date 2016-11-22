verbatimtex
%&latex
\documentclass{article}
\usepackage{amsmath}
\usepackage{amssymb}

\begin{document}
etex

input TEX;

filenametemplate "0%c.mps";

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

beginfig(0)
  label(btex \Large\bf{Precise Invariant Proving} etex, (0, 0));
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(1)
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(2)
  label(btex \Large\bf$\begin{array}{c}\text{Property Directed Reachability}\\\text{(PDR, aka IC3)}\end{array}$ etex, (0, 0));
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(3)
  draw statespace;
  label.llft(btex \Huge\textbf{state space} etex, urcorner(statespace) - (u, u)) withcolor white;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(4)
  draw statespace;
  draw property;
  label.urt(btex \Huge\textbf{property} etex, urcorner(property) - (u, u)) withcolor darkgreen;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(5)
  draw error;
  label.ulft(btex \Huge\textbf{bad} etex, ulcorner(property) - (u, u)) withcolor white;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(6)
  draw error;
  draw F0;
  label.urt(btex \Huge\textbf{initial} etex, urcorner(F0)) withcolor darkblue;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(7)
  draw error;
  draw F1;
  draw F0;
  label.top(btex \Huge\bf$\begin{array}{c}\text{up to}\\\text{2 steps}\end{array}$ etex, (0, 0)) withcolor darkblue;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(8)
  draw error;
  draw F2;
  draw F1;
  draw F0;
  label.top(btex \Huge\bf{3 steps} etex, (0, 2u)) withcolor darkblue;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(9)
  draw error;
  draw F3;
  draw F2;
  draw F1;
  draw F0;
  setbounds currentpicture to bbox(frame);
endfig;

filenametemplate "%c.mps";

beginfig(10)
  draw error;
  draw F4;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(11)
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
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(12)
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
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(13)
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
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(14)
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
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(15)
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
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(16)
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
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(17)
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
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(18)
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
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(19)
  draw error;
  draw F'4;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(20)
  draw error;
  draw F'4;
  drawarrow (((2.75u, 2.75u) rotated 45) {dir 135} .. {dir 45} ((4u, 4u) rotated 45)
    cutbefore (fullcircle scaled (.5u + 3pt) shifted ((2.75u, 2.75u) rotated 45))
    cutafter  (fullcircle scaled (.5u + 3pt) shifted ((4u, 4u) rotated 45))) withpen pencircle scaled 2pt withcolor white;
  fill fullcircle scaled .5u shifted (2.75u, 2.75u) rotated 45 withcolor darkblue;
  fill fullcircle scaled .5u shifted (4u, 4u) rotated 45 withcolor white;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(21)
  draw error;
  draw F''4;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(22)
  draw statespace;
  draw property;
  draw F''4;
  label.lrt(btex \Huge\textbf{outcome 2} etex, ulcorner(frame)) withcolor white;
  label.urt(btex \Huge\textbf{property} etex, urcorner(property) - (u, u)) withcolor darkgreen;
  label(btex \Huge\textbf{invariant} etex, (0, 0)) withcolor white;
  setbounds currentpicture to bbox(frame);
endfig;

beginfig(23)
  label(btex
$
\begin{array}{l}
\text{problem of invariant checking generally undecidable}\\
\text{decidable for finite state}\\
\text{ic3 works for finite state, is complete}\\
\text{apply abstraction (values, function summaries, heap, \ldots)}\\
\end{array}
$ etex, (0, 0));
  setbounds currentpicture to bbox(frame);
endfig;

end

verbatimtex
\end{document}
etex

.
