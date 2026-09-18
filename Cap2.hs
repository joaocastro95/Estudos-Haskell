-- :l Cap2.hs  (para carregar o arquivo Cap2.hs)
-- :r Comando de recarregar o arquivo Cap2.hs
-- :t Comando para saber o tipo de uma expressão
module Cap2 where

-- Teste>	2+2
-- 4
-- Teste>	3<4
-- True
-- Teste>	"Ola	"	++	"Mundo"
-- "Ola	Mundo"
-- Teste>:t	True
-- True	::	Bool
-- Note	que	o símbolo :: foi lido como "tem o tipo"



-- FUNÇÕES
--nomeDaFuncao	p1	p2	p3	...	pN	=	expressão	que	depende	dos	N parâme
-- tros.

maiorQue :: Int -> Int -> Bool
maiorQue x y = x > y

-- Uma dica a seguir é que o número de flechas ( -> ) acompanha o número de parâmetros da função. Por exemplo, a função maiorQue tem dois parâmetros, então ela tem duas flechas. 

-- Observe agora esta função declarada
u :: Int
u = 7

-- u = 6

-- a partir do momento em que tentamos compilar o trecho anterior, o compilador acusa um erro, pois não é possível declarar duas vezes a mesma função.



-- OPERAÇÃO COM LISTAS
-- Prelude>:t	[True,	False,	True]
-- [True,	False,	True]	::	[Bool]
-- Prelude>	[1,2]	++	[3,4]
-- [1,2,3,4]
-- Prelude>	[1,2]	++	[]
-- [1,2]
-- Prelude>	[True,False]	++	[True]
-- [True,	False,	True]
-- Prelude>	"ABCD"	++	"EFG"
-- "ABCDEFG"

-- String (aspas duplas) é um apelido para [Char], ou seja, uma lista de caracteres. Por isso, podemos usar as mesmas funções de listas para manipular strings.
--Prelude>	head	"ABCDEFG"
-- 'A'
-- Prelude>	last	"ABCDEFG"
-- 'G'
-- Prelude>	tail	"ABCDEFG"
-- "BCDEFG"
-- -- Prelude>	head	[]
-- ***	Exception:	Prelude.head:	empty	list
-- Prelude>	last	[]
-- ***	Exception:	Prelude.last:	empty	list
-- Prelude>	tail	[]
-- ***	Exception:	Prelude.last:	empty	list
-- ghci> head [1,2,3]
-- 1

-- Prelude>	reverse	"HASKELL"
-- "LLEKSAH"
-- Prelude>	reverse	[1,2,3]
-- [3,2,1]
-- Prelude>	reverse	[]
-- []

-- Prelude>	(head . reverse) "HASKELL"
-- 'L'
-- Prelude>	last	"HASKELL"
-- 'L'

-- Prelude>	[1,2,3,4]	!!	2
-- 3
-- Prelude>	[1,2,3,4]	!!	0
-- 1

-- A função cons (:) recebe um elemento e uma lista, e	devolve
-- este	elemento	na	frente	da	lista:
-- Prelude>	3	:	[3,4,5,6,-1]
-- [3,3,4,5,6,-1]
-- Prelude>	'A'	:	"BCDE"
-- "ABCDE"
-- Prelude>	2	:	[]
-- [2]
-- Prelude>	'A'	:	[]
-- "A"
-- Também	é	possível	chamar	esta	função	sucessivas	vezes.	Veja:
-- Prelude>	3	:	[4,5,2]
-- [3,4,5,2]
-- Prelude>	3	:	4	:	[5,2]
-- [3,4,5,2]
-- Prelude>	3	:	4	:	5	:	[2]
-- [3,4,5,2]
-- Prelude>	3	:	4	:	5	:	2	:	[]
-- [3,4,5,2]


--  Prelude> length	[1,2,3]
-- 3
-- Prelude>	length	['a']
-- 1
-- Prelude>	length	"a"
-- 1
-- Prelude>	length	[]
-- 0






-- COMPREENSÕES DE LISTAS
-- Uma compreensão de listas é uma forma de construir listas a partir de outras listas. A sintaxe geral é a seguinte:
-- [expressão(var) | var<-LISTA, FILTRO_1, FILTRO_2, ..., FILTRO_N]
-- | = "tal que" "onde" "para" "dado"
-- <- = "pertence a" "é um elemento de"
-- [0 .. 10] = [0,1,2,3,4,5,6,7,8,9,10]
-- /= = "diferente de"
dobroLista :: [Int] -> [Int]
dobroLista xs = [2*x | x <- xs]

lista :: [Int]
lista = [2*x+1 | x<-[0 .. 10], x/=5]






--TUPLAS
-- Uma tupla é uma coleção de valores, possivelmente de tipos diferentes. A sintaxe geral é a seguinte:
-- (valor_1, valor_2, ..., valor_N)

-- Prelude>:t	('A',"ALO")
-- ('A',"ALO")	::	(Char,	[Char])

foo :: Char -> Int -> (Int, String)
foo x y = (y+9, x:[x])

-- Prelude>	fst	('A',"ALO")
-- 'A'
-- Prelude>	snd	('A',"ALO")
-- "ALO"


-- Mais

dobro :: Int -> Int
dobro x = x * 2

somar :: Int -> Int -> Int
somar x y = x + y

func :: Int -> [Int] -> [Int]
func x xs = (x + 1) : xs

func2 :: String -> Bool
func2 ps = even (length ps)


-- list comprehension (permite criar listas a partir de oexpressoes e filtros)
-- eh um filtro denumeros primos
ehPrimo :: Int -> Bool
ehPrimo n = length [x | x <- [1 .. n], mod n x == 0] == 2


-- Exercícios
-- 2.1)	Gere as	listas:
-- a) [1,11,121,1331,14641,161051,1771561]	
elevadoOnze :: [Int]
elevadoOnze = [11^x | x<-[0 .. 6]]

-- b) [1,2,3,5,6,7,9,10,11,13,14,15,17,18,19,21,22,23,25,26,27,29,30,31,33,34,35,37,38,39]	
naoMultiploDe4 :: [Int]
naoMultiploDe4 = [x | x<-[1 .. 39], x `mod` 4 /= 0]

-- c)		["AaBB",	 "AbBB",	 "AcBB",	 "AdBB",	 "AeBB",	 "AfBB","AgBB"]	
letraAG :: [String]
letraAG = ["A" ++ [x] ++"BB" | x<-['a'..'g']]

-- d)		[5,8,11,17,20,26,29,32,38,41]	

letraD :: [Int]
letraD = [x | x <- [5,8..41], x `notElem` [14,23,35]]
-- || OU

-- e)		[1.0,0.5,0.25,0.125,0.0625,0.03125]	
letraE :: [Double]
letraE = [0.5^x | x <- [0..5]]

-- f)		[1,10,19,28,37,46,55,64]	
letraF :: [Int]
letraF = [1 + 9*x | x <- [0..7]]

-- g)		[2,4,8,10,12,16,18,22,24,28,30]	
letraG :: [Int]
letraG = [x | x <- [2,4..30], x `notElem` [6,14,20,26]]

-- h)		['@','A','C','D','E','G','J','L']	
letraH :: [Char]
letraH = [ch | ch <- ['@'..'L'], ch `notElem` "BFHIK"]

--2.2)	 Crie	 uma	 função	 que	 verifique	 se	 o	 tamanho	 de	 uma String	é par	ou	não.	Use		Bool		como	retorno.
ehPar :: String -> Bool
ehPar str = length str `mod` 2 == 0

-- 2.3)	 Escreva	 uma	 função	 que	 receba	 um	 vetor	 de	 Strings	 e retorne	uma	lista	com	todos	os	elementos	em	ordem	reversa.
reverso :: [String] -> [String]
reverso xs = [reverse x | x <- xs]

-- 2.4)	 Escreva	 uma	 função	 que	 receba	 um	 vetor	 de	 Strings	 e retorne	 uma	lista	 com	 o	 tamanho	 de	 cada	 String.	As	palavras	 de tamanho	par	devem	ser	excluídas	da	resposta.
tamanhoImpar :: [String] -> [Int]
tamanhoImpar xs = [length x | x <- xs, length x `mod` 2 /= 0]

-- 2.5)	Escreva	a	função		head		como	composição	de	duas	outras
head' :: [a] -> a
head' = last . reverse

--2.6)	Faça	uma	função	que	receba	uma	String	e	retorne		True	se	esta	for	um	palíndromo;	caso	contrário,		False	.
palindromo :: String -> Bool
palindromo str = str == reverse str

--2.7	 Faça	 uma	 função	 que	 receba	 um	 inteiro	 e	 retorne	 uma tupla,	contendo:	o	dobro	deste	número	na	primeira	coordenada,	o triplo	na	segunda,	o	quádruplo	na	terceira	e	o	quíntuplo	na	quarta.
multiplos :: Int -> (Int, Int, Int, Int)
multiplos n = (2*n, 3*n, 4*n, 5*n)