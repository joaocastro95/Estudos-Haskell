module Cap5 where

-- Uma		Coisa		representará	algo	que	podemos	guardar	nenhum,
-- um	ou	dois	elementos	de	um	mesmo	tipo:
data Coisa a = UmaCoisa a | DuasCoisas a a | ZeroCoisa

-- :t	(DuasCoisas	"OLA"	"Mundo")	
-- (DuasCoisas	"OLA"	"Mundo")	::	Coisa	String

-- :t	(UmaCoisa	True)
-- (UmaCoisa	True)	::	Coisa	Bool

-- Ao	trabalharmos	com	contêineres,	o	comando		:kind		do
-- GHCi	vai	indicar	quantos	type	parameters	existem	em	seu	tipo.
-- Quanto	mais	existirem,	mais	complexo	será	trabalhar	com	ele.
-- Prelude>	:kind	Int
-- Int	::	*
-- Prelude>	:kind	Coisa
-- Coisa	::	*	->	*
-- Prelude>	:kind	[]
-- []	::	*	->	*
data Foo a b = Foo a b

-- Prelude>	:t	(Foo	True	'A')
-- (Foo	True	'A')	::	Foo	Bool	Char
-- Esse	código	é	compilado	sem	erros,	por	ser	um	contêiner	de
-- kind			*	->	*	->	*	

data Arvore a = Nulo | Leaf a | Branch (Arvore a) (Arvore a) Deriving (Show, Eq)

-- O	tipo		Arvore		possui	três	value	constructors:		Nulo	,	que	não
-- possui	nenhum	campo;		Leaf	a	,	que	possui	um	campo	de	tipo
-- a	;	e		Branch	a	(Arvore	a)	(Arvore	a)	,	que	possui	um	campo
-- a	,	um	campo	para	representar	o	nó	do	filho	esquerdo	de	tipo
-- Arvore	a		(que	pode	ser	novamente		Nulo	,		Leaf		ou		Branch	)	e
-- um	campo	para	representar	o	nó	do	filho	direito	de	tipo		Arvore
-- a	.
-- Os	campos	de	tipo		a		representam	o	elemento	a	ser	guardado
-- na	árvore,	enquanto	os	campos	de	tipo		Arvore	a		fazem	a
-- continuação	da	estrutura,	tanto	para	a	esquerda	quanto	para	a
-- direita.


Branch	50	(Branch	30	(Leaf	20)	(Leaf	40))	(Branch	90	Nulo	(Leaf	1
00))