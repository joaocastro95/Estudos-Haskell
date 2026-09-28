module Cap4 where


--LAMBDAS
-- Funções	podem	ser	usadas	como	valores	e	não	necessariamente
-- em	um	contexto	explícito,	como	fizemos	até	aqui.	Por	exemplo,
-- não	é	preciso	declarar	a	função	em	um	contexto	para	usá-la.	Em
-- vez	disso,	é	possível	usá-las	naturalmente	como	se	estivessem
-- declaradas.	De	uma	maneira	geral,	lambdas	têm	a	seguinte	forma:
-- \p1	p2	p3	p4	...	pn	->	EXPR(p1,	p2,	p3,	p4,	...	,	pn)

-- Prelude>	(\x	->	2*x)	4
-- 8

-- Prelude>	(\x	xs	->	x	:	reverse	xs)	'A'	"UOIE"
-- "AEIOU"



--ALTA ORDEM
-- Como	dito	na	introdução,	funções	podem	ser	passadas	como
-- parâmetro	ou	retornar	outras	funções.	Uma	função	que	possua
-- alguma	das	duas	características	citadas	é	chamada	de	função	de
-- alta	ordem,	ou	high-order	function.

ev :: (Int -> Int) -> Int
ev f = 1 + f 5

dobro    ::    Int    ->    Int
dobro    x    =    2*x

triplo    ::    Int    ->    Int
triplo    x    =    3*x


-- Prelude>	ev	dobro
-- 11
-- Prelude>	ev	triplo
-- 16

-- Prelude>	ev	(\x	->	2*x)
-- 11
-- Prelude>	ev	(\x	->	3*x)
-- 16


--CURRYING

-- Currying	é	uma	técnica	que	consiste	em	transformar	a
-- chamada	de	uma	função	(retorno	valorado),	que	recebe	múltiplos
-- argumentos,	em	uma	avaliação	de	uma	sequência	de	funções.	Você
-- pode	fixar	uma	quantidade	de	argumentos	e	deixar	o	restante
-- variável.
somarTresNum :: Int -> Int -> Int -> Int
somarTresNum x y z = x+y+z
somarCurr :: Int -> Int
somarCurr = somarTresNum 4 5

-- A	função		somarCurr		possui	fixo	os	parâmetros		x		e		y		da
-- função		somarTresNum	,	deixando		z		livre	para	variar.	Portanto,
-- podemos	inspecionar	o	tipo	de		somarCurr	.
-- Prelude>		:t		somarCurr
-- somarCurr	::	Int	->	Int
-- somarTresNum	::	Int	->	Int	->	(Int	->	Int)
-- Fazendo	isso,	fica	claro	que,	a	partir	da	função
-- somarTresNum	,	se	passarmos	dois	argumentos	a	ela,	o	retorno
-- será	uma	função	de	um	parâmetro		Int		e	seu	retorno		Int	,
-- fazendo	com	que	ela	se	torne	de	alta	ordem.	Sempre	que	houver
-- parênteses	encobrindo	flechas	e	tipos,	consideraremos	que	o
-- parâmetro	ou	o	retorno	é	uma	função

-- Prelude>	somarCurr	1
-- 10





-- ==Map/foldl/filter

-- :t map
-- map	::	(a	->	b)	->	[a]	->	[b]

-- Aula4>	map	(+2)	[1..5]
-- [3,4,5,6,7]


-- :t foldl
-- foldl	::	(b	->	a	->	b)	->	b	->	[a]	->	b

-- Aula4>	foldl	(+)	0	[1..4]
-- 10

-- (+)	0	1	[2,3,4]
-- (+)	1	2	[3,4]	
-- (+)	3	3	[4]	
-- (+)	6	4	[]	
-- 10


-- Aula4>	foldl	(\xs	x	->	x	:	xs)	[]	"FATEC"
-- "CETAF"


-- Isto	produzirá	as	seguintes	chamadas:
-- 'F':[]	"ATEC"	
-- 'A':'F':[]	"TEC"
-- 'T':'A':'F':[]	"EC"	
-- 'E':'T':'A':'F':[]	"C"	


-- Aula4>	:t	filter
-- filter	::	(a	->	Bool)	->	[a]	->	[a]
-- O		filter		é	uma	função	que	recebe	uma	outra	função		f		de
-- retorno	booleano	e	uma	lista	de	elementos.	Ele	retorna	uma	outra
-- lista	contendo	os	elementos	que	foram	argumentos	de		f		e	que
-- tiveram		True		como	retorno.
-- Aula4>	filter	(>0)	[-4..4]
-- [1,2,3,4]




-- FUNCAO
traseira :: String -> String
traseira []     = []
traseira (x:xs) = xs

contar :: String -> Int
contar = length

-- contar(traseira	"Haskell")	

-- mais próximo da matematica, USAR O PONTO .
-- Prelude>	(contar	.	traseira)	"Haskell"
-- 6


--FUNCAO $

-- Prelude>	contar	$	"Ola"
-- 3
-- Aparentemente,	não	há	diferença	alguma	com	uma	chamada
-- de	função	simples:
-- Prelude>	contar	"Ola"
-- 3

-- Prelude>	contar	("Ola"	++	"Alo")
-- 6
-- Fazemos	isso	para	indicar	que	a	concatenação	será	efetuada	e
-- seu	retorno	entrará	na	função		contar	.
-- A	função		$		é	uma	maneira	fácil	de	se	livrar	da	poluição
-- causada	pelo	uso	excessivo	de	parênteses	-	como	é	habitual	em
-- muitas	linguagens	-,	deixando	o	código	mais	claro.
-- Prelude>	contar	$	"Ola"	++	"Alo"
-- 6


--Função|>

(|>) :: a -> (a -> b) -> b
(|>) x f = f x
infixl 9 |>

-- O		infixl		indica	alta	precedência	à	esquerda.	A	linguagem	de
-- programação	funcional	para	front-end		Elm		usa	muito	esta
-- função	e,	em	seu	ambiente,	este	conceito	é	chamado	de	pipelining.
-- Aqui	em	Haskell,	este	operador	terá	mais	utilidade	mais	à	frente,
-- porém	usando-o	é	possível	reescrever	a	seguinte	função:

func :: String -> String
func x = x ++ (tail (take 3 (reverse x)))

-- Da	seguinte	forma:
funcI :: String -> String
funcI x = x
  |> reverse
  |> take 3
  |> tail
  |> (x ++)




--SINTAXE	EM	FUNÇÕES
-- Os	guards	são	uma	maneira	de	testar	várias	condições	em	uma
-- função,	de	maneira	similar	a	um		if		encadeado.

imc :: Double -> Double -> String
imc p a
  | valor < 18.5 = "Abaixo do peso"
  | valor < 25   = "Peso normal"
  | valor < 30   = "Sobrepeso"
  | otherwise    = "Obesidade"
  where valor = p / (a * a)



--RECURSAO

-- Recursão	é	um	método	de	resolução	de	problemas	que	consiste
-- na	solução	de	pequenas	instâncias	do	problema	até	achar	a	solução
-- global.	A	recursão	precisa	de	uma	condição	de	base	(de	parada	ou
-- inicial)	para	que	não	se	caia	em	loops	infinitos.
-- Em	Haskell,	é	uma	técnica	fundamental	para	resolver
-- problemas,	pois,	não	há	instruções	de	loop	como		repeat		ou
-- for	.
-- fat	n
-- |	n	<=	1	=	1	
-- |	otherwise	=	n*fat(n-1)


fat :: Int-> Int
fat n
  | n <= 1    = 1
  | otherwise = n * fat (n - 1)

-- As	operações	são	realizadas	conforme	a	ordem	de	chamada	da
-- função.	Por	exemplo,	se	calcularmos	o	fatorial	de		5	:
-- Prelude>	fat	5
-- 120
-- A	primeira	expressão	a	ser	calculada	é		fat	5	=	5*fat	4	,	e	a
-- próxima	chamada	será		fat	4	.	O	quadro	seguinte	mostra	a	ordem
-- das	operações:
-- fat	5	=	5*fat	4
-- fat	4	=	4*fat	3
-- fat	3	=	3*fat	2
-- fat	2	=	2*fat	1

-- fat	1
-- fat	2
-- fat	3
-- fat	4
-- fat	5



-- fat	1	=	1
-- fat	2	=	2*fat	1	=	2*1	=	2
-- fat	3	=	3*fat	2	=	3*2	=	6
-- fat	4	=	4*fat	3	=	6*4	=	24
-- fat	5	=	5*fat	4	=	24*5	=	120.


reverse' :: String -> String
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]




-- 4.1) Faça uma função que retorne a média de um [Double], usando foldl.
media :: [Double] -> Double
media xs = foldl (+) 0 xs / fromIntegral (length xs)


-- 4.2) Faça uma função que receba uma [String] e retorne todos os elementos
--      palíndromos. Ver exercício 3.7.
palindromo :: String -> Bool
palindromo s = s == reverse s
 
palindromos :: [String] -> [String]
palindromos xs = filter palindromo xs

-- 4.3) Implemente uma função que filtre os números pares e outra que filtre
--      os ímpares de uma lista recebida via parâmetro.
pares :: [Int] -> [Int]
pares xs = filter even xs
 
impares :: [Int] -> [Int]
impares xs = filter odd xs

-- 4.4) Filtre os números primos de uma lista recebida por parâmetro.
primo :: Int -> Bool
primo n = n > 1 && all (\d -> n `mod` d /= 0) [2 .. n - 1]
 
primos :: [Int] -> [Int]
primos xs = filter primo xs

-- 4.5) Implemente uma função que receba uma lista de inteiros e retorne o
--      dobro de todos, eliminando os múltiplos de 4.
dobroSem4 :: [Int] -> [Int]
dobroSem4 xs = map (* 2) (filter (\x -> x `mod` 4 /= 0) xs)

-- 4.6) Faça uma função func que receba uma função f do tipo (String -> String)
--      e uma String s, e que retorne o reverso de s concatenado com a
--      aplicação da função f em s.
func1 :: (String -> String) -> String -> String
func1 f s = reverse s ++ f s

-- 4.7) Crie um tipo Dia contendo os dias da semana. Faça uma função que
--      receba uma lista de Dias e filtre as Tercas.
data DiaSemana = Domingo | Segunda | Terca | Quarta | Quinta | Sexta | Sabado
  deriving (Show, Eq, Enum)
 
type Dia = DiaSemana
 
filtrarTercas :: [Dia] -> [Dia]
filtrarTercas ds = filter (== Terca) ds

-- 4.8) Implemente o tipo Dinheiro, que contenha os campos valor e correncia
--      (Real ou Dolar), e uma função que converta todos os "dinheiros" de uma
--      lista para dólar (e outra para real). Com isso, implemente funções para:
--        - Filtrar todos os Dolares de uma lista de Dinheiro.
--        - Somar todos os Dolares de uma lista.
--        - Contar a quantidade de Dolares de uma lista.
data Correncia = Real | Dolar deriving (Show, Eq)
 
data Dinheiro = Dinheiro { valor :: Double, correncia :: Correncia }
  deriving Show
 
cotacao :: Double
cotacao = 5.30   -- 1 dólar = 5,30 reais
 
paraDolar :: Dinheiro -> Dinheiro
paraDolar (Dinheiro v Real) = Dinheiro (v / cotacao) Dolar
paraDolar d                 = d
 
paraReal :: Dinheiro -> Dinheiro
paraReal (Dinheiro v Dolar) = Dinheiro (v * cotacao) Real
paraReal d                  = d
 
converterTodosDolar :: [Dinheiro] -> [Dinheiro]
converterTodosDolar ds = map paraDolar ds
 
converterTodosReal :: [Dinheiro] -> [Dinheiro]
converterTodosReal ds = map paraReal ds
 
filtrarDolares :: [Dinheiro] -> [Dinheiro]
filtrarDolares ds = filter (\d -> correncia d == Dolar) ds
 
somarDolares :: [Dinheiro] -> Double
somarDolares ds = sum (map valor (filtrarDolares ds))
 
contarDolares :: [Dinheiro] -> Int
contarDolares ds = length (filtrarDolares ds)


-- 4.9) Usando a função foldl, crie lambdas para:
--        - Contar os números negativos de uma lista de Int.
--        - Contar as letras 'P' de uma String.
--        - Contar os Sabados em uma lista [DiaSemana].
--        - A partir de uma lista [DiaSemana], retornar a soma dos dias.
--          Use uma função auxiliar para converter DiaSemana para Int.
--          Exemplo: [Segunda, Segunda, Quarta] deve retornar 5.
contarNegativos :: [Int] -> Int
contarNegativos xs = foldl (\acc x -> if x < 0 then acc + 1 else acc) 0 xs
 
contarP :: String -> Int
contarP s = foldl (\acc c -> if c == 'P' then acc + 1 else acc) 0 s
 
contarSabados :: [DiaSemana] -> Int
contarSabados ds = foldl (\acc d -> if d == Sabado then acc + 1 else acc) 0 ds
 
-- Domingo = 0, Segunda = 1, ..., Sabado = 6
diaParaInt :: DiaSemana -> Int
diaParaInt d = fromEnum d
 
somaDias :: [DiaSemana] -> Int
somaDias ds = foldl (\acc d -> acc + diaParaInt d) 0 ds



-- 4.10) Reescreva os exercícios anteriores usando: . , $ e |>.
-- 4.1 com $
media' :: [Double] -> Double
media' xs = foldl (+) 0 xs / (fromIntegral $ length xs)
 
-- 4.2 com |>
palindromos' :: [String] -> [String]
palindromos' xs = xs |> filter palindromo
 
-- 4.3 com . (point-free)
pares', impares' :: [Int] -> [Int]
pares'   = filter (not . odd)
impares' = filter (not . even)
 
-- 4.4 com $
primos' :: [Int] -> [Int]
primos' xs = filter primo $ xs
 
-- 4.5 com .
dobroSem4' :: [Int] -> [Int]
dobroSem4' = map (* 2) . filter (\x -> x `mod` 4 /= 0)
 
-- 4.6 com |>
func' :: (String -> String) -> String -> String
func' f s = s |> f |> (reverse s ++)
 
-- 4.7 com |>
filtrarTercas' :: [Dia] -> [Dia]
filtrarTercas' ds = ds |> filter (== Terca)
 
-- 4.8 com . , $ e |>
somarDolares' :: [Dinheiro] -> Double
somarDolares' = sum . map valor . filtrarDolares
 
contarDolares' :: [Dinheiro] -> Int
contarDolares' ds = length $ filtrarDolares ds
 
converterTodosDolar' :: [Dinheiro] -> [Dinheiro]
converterTodosDolar' ds = ds |> map paraDolar
 
-- 4.9 com . e |>
contarSabados' :: [DiaSemana] -> Int
contarSabados' ds = ds |> filter (== Sabado) |> length
 
somaDias' :: [DiaSemana] -> Int
somaDias' = sum . map diaParaInt


-- 4.11) Implemente a função fatorial usando foldl (ou foldr) em vez de
--       recursão explícita, a partir da lista [1..n].
fatorial :: Integer -> Integer
fatorial n = foldl (*) 1 [1 .. n]

-- 4.12) Usando currying, defina a função somar10 :: Int -> Int a partir da
--       função (+), sem escrever lambdas nem o parâmetro. Em seguida, escreva
--       aplicarDuasVezes :: (a -> a) -> a -> a, uma função de alta ordem que
--       aplica uma função duas vezes ao seu argumento.
--       Teste: aplicarDuasVezes somar10 5

somar10 :: Int -> Int
somar10 = (+) 10
 
aplicarDuasVezes :: (a -> a) -> a -> a
aplicarDuasVezes f x = f (f x)














-- ** Lambdas: São funcoes anonimas e sao enxergadas pelo compilador como valor do tipo FUNÇÃO (o lambida eh a barra invertida!!)

-- ghci> (\x -> x + 1) 5            "o 5 assume papel do x e o resultado é 6"
-- ghci> (\x y -> x ++ y ++ "!!") "OI" " FATEC"        "o resultado é OI FATEC!!"
-- ghci> (\x y z -> x * y * z) 2 3 4         "o resultado é 24"
-- ghci> (\x y z  -> y) 2 1 3            "1"
-- ghci> (\x y   -> (x,y)) "True" "K"            "(True, "k")"
-- ghci> (\x y z  -> 8) 2 5 3            "8"


-- ** Funções de alta ordem (High-Order functions): São funções que recebem e/ou retornam outras funções.
-- exercicios com isso na prova precisa colocar a linha de raciocionio, se nn ele desconsidera!!!

-- a)
-- ghci> (\f -> f 5) (\x -> 3*x)
-- = (\x -> 3 * x) 5
-- = 3 * 5 = 15

-- b)
-- ghci> (\g f -> g(f 3)) (\x -> x) (\y -> 4)
-- = (\x -> x) ((\y -> 4) 3)
-- = (\x -> x) 4
-- = 4

-- c)
-- ghci (\f -> f 1) 3
-- = 3 1  ----> ERRO

-- d)
-- ghci (\g x -> x ++ g x) reverse "Fatec "
-- = "Fatec " ++ reverse "Fatec "
-- = "Fatec  cetaF"

-- e)
-- ghci (\f g x -> f x ++ g x) reverse (\x -> x ++ "AB") "SANTOS"
-- = reverse "SANTOS" ++ (\X -> X ++ "AB") "SANTOS"
-- = reverse "SANTOS" ++ "SANTOSAB" 
-- = "SOTNASSANTOSAB"

-- f)
-- ghci (\f g -> (f(f 1)),g 2)) (\x -> 2 * x) (\x -> 9)
-- = ( (\x -> 2 * x)((\x -> 2 * x) 1),(\x -> 9)2) )
-- = ((\x -> 2 * x) 2),9 )
-- = (4,9)

-- ** Currying: ato de chamar uma função com o número de argumentos menor que o pedido, retornando uma função.

-- a)
-- ghci s = (\x y z -> x + y + z) 1 3
-- Logo , s = (\z -> 1 + 3 + z)
-- ghci (\f -> f 1) s
-- = (\z -> 1 + 3 + z) 1
-- = 5

-- b)
-- ghci (2+) = (\x y -> x + y)2        "o haskkel interpreta o (2+) assim porque ficaria (\y -> 2 + y)"

-- c)
-- ghci (\f g -> g(f 1))(+2)(3*)
-- = (3*)((+2)1)
-- = (3*)3
-- = 9

-- d)
-- ghci (\f -> 1 + f 3) (+5)
-- = 1 + (+5)3
-- = 1 + 8
-- = 9

-- e)
-- ghci (\f -> f 3) (== 2)
-- = (==2) 3
-- = False

-- f)
-- ghci (\x f g -> f x (g x))7 (+) (2*)
-- = (+) 7 ((2*)7)
-- = (\x y -> x + y)7 ((2*)7)
-- = (7+) 14
-- = 21

-- g)
-- ghci (\x f -> x == f x) 5 (\x -> x)
-- = 5 == (\x -> x)5
-- = 5 == 5
-- TRUE

-- h)
-- ghci (\f -> f 2) (>3)
-- = (>3) 2
-- = FALSE

-- i)
-- ghci s = (\x y z -> x * y * z) 3
-- (\x -> s x x) 5
-- = ((\x y z -> x * y * z) 3 5 5)
-- = 75 

-- f alternativo -> (\x f g -> f x (g x)) (+) (2*)
-- == (\g -> (2*)(+) (g(+)) -> ERRO DE COMPILAÇÃO!!!


-- ** Map: a função de alta ordem  map recebe uma função e uma lista como parâmetros. 
-- Esta função retorna uma lista com a função aplicada em todos os elementos.

-- map f [] = []   e    map f [e1,e2,...,en] = [fe1,fe2,...,fen]

-- a) map (+2) [1,2,3,4] = [3,4,5,6]
-- b) map reverse ["oi", "fatec"] = [reverse "oi", reverse "fatec"] -> ["oi","cetaf"]
-- c) map (==2) [1..5] = [false,true,false,false,false]
-- d) map (\x -> x) [1,2,3] = [1,2,3]
-- e) map (\x -> 8) [1 .. 4] = [8,8,8,8]

-- ** Filter: o filter é uma função de alta ordem que recebe um predicado (função que retorna bool) e uma lista.
-- a mesma retorna os elementos que são TRUE de acordo com o predicado.

-- a) filter (>1) [1,2,3] = [2,3]
-- b) filter (\x -> x == "oi") ["oi", "fatec"] = ["oi"]
-- c) filter (5==) [1,2,3,4] = []
-- d) filter (\x -> x + 2 > 4) [1,2,3,4] = [3,4]

-- ** Fold-Left : fold-left é uma função de alta ordem que recebe um operador binario (função com 2 parametros), um valor inicial
-- e uma lista. A função retorna um valor que é fruto de sucessivas aplicações do operador no valor acumulado e no valor da lista.

-- foldl f v [] = v    e   foldl f v [e1,e2,...,en] = f(f(f v e1) e2)en)

-- a) foldl (+) 0 [1,2,3]    -> isso basicamente ta somando todos os itens
-- = (+)((+)((+) 0 1)2)3
-- = 6

-- b) foldl (*) 1 [1..5]
-- = 1*1*2*3*4*5 = 120

-- c) foldl (++) "" ["oi","fatec","santos"]
-- = "oifatecsantos"