module Cap7 where

--     Em	Haskell,	um	funtor	é	simplesmente	uma	classe	(ou
-- typeclass)	que	possui	a	função		fmap		a	ser	definida	para	toda
-- instância.	Ou	seja,	todo	tipo	de	kind		*	->	*		que	seja	instância	de
-- Functor		deve	"saber"	como	levar	uma	função		g		de	tipo		a	->
-- b		para	dentro	de	um	contêiner	de	tipo		f	a	,	resultando	assim	em
-- algo	do	tipo		f	b	


-- A	entrada	de	uma	função		g		de	tipo		a	->	b		é	claramente	de
-- tipo		a	,	fazendo	com	que	algo	do	tipo		f	a		seja	barrado	com	type
-- mismatch	pelo	compilador,	já	que		a		e		f	a		são	valores	de	tipos
-- diferentes.	A	classe		Functor		é	definida	como:
-- class		Functor	f		where
-- fmap	::	(a	->	b)	->	f	a	->	f	b

-- Prelude>	:t	map
-- map	::	(a	->	b)	->	[a]	->	[b]