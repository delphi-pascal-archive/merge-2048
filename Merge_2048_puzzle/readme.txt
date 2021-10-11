Merge jeu puzzle 2048---------------------
Url     : http://codes-sources.commentcamarche.net/source/100467-merge-jeu-puzzle-2048Auteur  : zwyxDate    : 15/04/2014
Licence :
=========

Ce document intitul� � Merge jeu puzzle 2048 � issu de CommentCaMarche
(codes-sources.commentcamarche.net) est mis � disposition sous les termes de
la licence Creative Commons. Vous pouvez copier, modifier des copies de cette
source, dans les conditions fix�es par la licence, tant que cette note
appara�t clairement.

Description :
=============

<b>Merge</b> est un jeu, puzzle ou casse-t�te, imitant <b>2048</b> de Gabriele C
irulli, lui m�me bas� sur <b>1024</b> de Veewo Studio, conceptuellement similair
e � <b>Threes</b> de Asher Vollmer. 
<br />
<br />Il se joue � l'aide des quat
res fl�ches directionelles du clavier, des touches ECHAP, F1, F2 et F3. 
<br />

<br />Les cellules peuvent �tre d�plac�es � l'aide des quatres fl�ches du clav
ier. Lorsque deux cellules ayant la m�me valeur sont r�unies, elle fusionnent en
 une seule. Le but est d'obtenir une cellule atteignant la valeur 2048. 
<br />

<br />Le code se compose d'une forme principale (unit� <span style='text-decor
ation: underline;'>FMain</span>) ne pr�sentant qu'une unique <i>StringGrid</i>, 
interrogeant un objet <i>Grid</i>. L'objet <i>Grid</i> (unit� <span style='text-
decoration: underline;'>UGrid</span>) poss�de une liste d'objets de type <i>Cell
</i>. Chaque objet <i>Cell</i> (unit� <span style='text-decoration: underline;'>
UCell</span>) pointe sur ses �ventuelles cellules 4-connexes, � la mani�re d'une
 liste cha�n�e. 
<br />
<br />Merci d'avance pour les retours sur votre exp�ri
ence de jeu (anomalies, am�liorations).
