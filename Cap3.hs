module Cap3 where

-- DATA para criar novos tipos de dados
-- | significa "ou" e é usado para definir diferentes construtores de dados para o tipo Dia. Cada construtor representa um dia da semana.

data Dia = Segunda | Terca | Quarta | Quinta | Sexta | Sabado | Domingo

-- Podemos	agora	criar	funções	com	o	novo	tipo	criado:
agenda :: Dia -> String
agenda Domingo = "TV..."
agenda Sabado = "Festa"
agenda _ = "Trabalho"

-- Vamos	analisar,	no	exemplo	a	seguir,	o	tipo		(Int,Int)	,	que	é
-- uma	 tupla	 com	 um	 inteiro	 em	 cada	 uma	 das	 duas	 coordenadas.
-- Serão	listadas	algumas	combinações	válidas	deste	 tipo,	na	entrada de	uma	função qualquer f:
f:: (Int,Int) -> Int
f (0,0) = 0
f (0,1) = 1
f (1,0) = 1
f (x,0) = x
f (0,y) = y
f (x,y) = x + y

--Todos os casos dão o mesmo resultado que x + y: por exemplo, (7,0) dá 7, que é 7+0.
-- g	::	(Int,	Int)	->	Int
-- g	(7,7)	=	7
-- g	_	=	0

h :: [Int] -> Int
h [] = 0
h (_:[]) = 1
h (_:x:[]) = 2+x
h (x:y:z:[]) = 3+x+y+z
h (x:_:_:w:[]) = 4+x+w
h (x:xs) = x