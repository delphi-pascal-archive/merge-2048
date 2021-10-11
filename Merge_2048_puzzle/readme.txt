Merge jeu puzzle 2048---------------------
Url     : http://codes-sources.commentcamarche.net/source/100467-merge-jeu-puzzle-2048Auteur  : zwyxDate    : 15/04/2014
Licence :
=========

Ce document intitulé « Merge jeu puzzle 2048 » issu de CommentCaMarche
(codes-sources.commentcamarche.net) est mis à disposition sous les termes de
la licence Creative Commons. Vous pouvez copier, modifier des copies de cette
source, dans les conditions fixées par la licence, tant que cette note
apparaît clairement.

Description :
=============

<b>Merge</b> est un jeu, puzzle ou casse-tête, imitant <b>2048</b> de Gabriele C
irulli, lui même basé sur <b>1024</b> de Veewo Studio, conceptuellement similair
e à <b>Threes</b> de Asher Vollmer. 
<br />
<br />Il se joue à l'aide des quat
res flèches directionelles du clavier, des touches ECHAP, F1, F2 et F3. 
<br />

<br />Les cellules peuvent être déplacées à l'aide des quatres flèches du clav
ier. Lorsque deux cellules ayant la même valeur sont réunies, elle fusionnent en
 une seule. Le but est d'obtenir une cellule atteignant la valeur 2048. 
<br />

<br />Le code se compose d'une forme principale (unité <span style='text-decor
ation: underline;'>FMain</span>) ne présentant qu'une unique <i>StringGrid</i>, 
interrogeant un objet <i>Grid</i>. L'objet <i>Grid</i> (unité <span style='text-
decoration: underline;'>UGrid</span>) possède une liste d'objets de type <i>Cell
</i>. Chaque objet <i>Cell</i> (unité <span style='text-decoration: underline;'>
UCell</span>) pointe sur ses éventuelles cellules 4-connexes, à la manière d'une
 liste chaînée. 
<br />
<br />Merci d'avance pour les retours sur votre expéri
ence de jeu (anomalies, améliorations).
