module Cap5 where
import Data.Monoid
import qualified Data.Text as T
import qualified Data.ByteString as BS

-- Uma		Coisa		representará	algo	que	podemos	guardar	nenhum,
-- um	ou	dois	elementos	de	um	mesmo	tipo:
-- data Coisa a = UmaCoisa a | DuasCoisas a a | ZeroCoisa

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

data Arvore a = Nulo | Leaf a | Branch a (Arvore a) (Arvore a) deriving (Show, Eq)

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

    --         50
    --       /    \
    --     30      90
    --    /  \       \
    --  20    40      100

-- A	árvore	anterior	pode	ser	representada	pela	expressão:

-- -- Branch	50	(Branch	30	(Leaf	20)	(Leaf	40))	(Branch	90	Nulo	(Leaf	100))

-- O	percurso	em	ordem,	por	exemplo,	pode	ser	escrito	com	a
-- ajuda	da	recursão	e	do	pattern	matching:
emOrdem :: Arvore a -> [a]
emOrdem (Branch x l r) = emOrdem l ++ [x] ++ emOrdem r
emOrdem (Leaf x) = [x]
emOrdem Nulo = []

arv = Branch 50 (Branch 30 (Leaf 20) (Leaf 40)) (Branch 90 Nulo (Leaf 100))

-- arv = Branch 50 (Branch 30 (Leaf 20) (Leaf 40)) (Branch 90 Nulo (Leaf 100))
-- emOrdem arv


-- 5.2	RESTRIÇÃO	DE	TIPOS	EM	FUNÇÕES

-- Para	resolver	isso,	temos	de	avisar	que	não	pode	ser	qualquer
-- a	,	criando	uma	restrição	que	avisa	ao	compilador	que	tipos	serão
-- barrados	fora	desse	contexto	em	tempo	de	compilação.	Veja	um
-- exemplo:
-- foo	::	Show	a	=>	a	->	String
-- foo	x	=	"O	valor	de	tipo	a	é:	"	++	show	x

foo :: Show a => a -> String
foo x = "O valor de tipo a eh: " ++ show x


-- 5.3	CLASSES	DE	TIPOS
-- Se	usarmos	o	tipo:
-- data	Coisa	a	=	Nada	|	UmaCoisa	a	|	DuasCoisas	a	a
-- Não	poderíamos	mostrá-lo	na	tela	nem	comparar	(usando	a
-- função		==	).	Para	mostrar	qualquer	tipo	na	tela,	seria	necessário	o
-- uso	do	typeclass		Show		e,	para	comparar,	usaríamos	o		Eq	.
-- Reescrevendo


data Coisa a = UmaCoisa a | DuasCoisas a a | ZeroCoisa 

-- Temos	agora	que	o	tipo		Coisa	a		pode	ser	mostrado	na	tela	e
-- é	comparável.	O	Haskell	provê	para	o	tipo		Coisa	a		a	seguinte
-- regra	de	igualdade:	dois	valores	do	tipo		Coisa	a		são	iguais	se,	e
-- somente	se,	seus	value	constructors	são	iguais	e	os	campos	também.

-- DuasCoisas	5	5	==	DuasCoisas	5	5
-- True
-- DuasCoisas	7	3	==	DuasCoisas	3	7
-- False



-- CLASSE EQ
-- Esta	regra	de	igualdade	para	o	tipo	em	questão	é	obtida
-- gratuitamente,	apenas	usando		deriving	Eq		na	definição.	Se	a
-- regra	de	igualdade	para	este	tipo	for	criada	pelo	leitor,	a	instância
-- de		Eq		para	o	tipo		Coisa	a		se	faz	necessária.

instance Eq a => Eq (Coisa a) where
  (DuasCoisas x1 y1) == (DuasCoisas x2 y2) = x1 == y2
  (UmaCoisa x)       == (UmaCoisa y)       = x == y
  ZeroCoisa          == ZeroCoisa          = True
  _                  == _                  = False

--   DuasCoisas	7	3	==	DuasCoisas	3	7
-- True

-- Prelude>	DuasCoisas	7	9
-- DuasCoisas	7	9
-- Prelude>	Nada
-- Nada
-- Prelude>	UmaCoisa	True
-- UmaCoisa	True

-- A	classe		Show		é	usada	para	a	saída	de	qualquer	dado.	Nos
-- frameworks	web	em	Haskell,	usamos	o		Show		para	injetar	saídas
-- das	funções	em	um	template	HTML.	Há	uma	instância	"padrão"	de
-- Show		que	fornece,	na	tela,		DuasCoisas	7	9	,	por	exemplo.
-- Podemos	mudar	isso	removendo	o		Show		do		deriving	:
-- data	Coisa	a	=	Nada	|	UmaCoisa	a	|	DuasCoisas	a	a


instance Show a => Show (Coisa a) where
  show ZeroCoisa        = "Nadinha..."
  show (UmaCoisa x)     = "Coisa com o elemento " ++ show x
  show (DuasCoisas x y) = "Coisa com os elementos " ++ show x ++ " e " ++ show y


-- Prelude>	DuasCoisas	7	9
-- Coisa	com	os	elementos	7	e	9
-- Prelude>	Nada
-- Nadinha...
-- Prelude>	UmaCoisa	True
-- Coisa	com	o	elemento	True

-- CLASSE READ

-- criação	de	uma	instância	para	este	tipo	pode	ser	bem
-- complicada.	Mostraremos	o	seu	uso	acompanhado	do		deriving	
-- apenas	(instância	padrão	do	Haskell).	Vamos	usar	nosso	tipo	como
-- teste:
-- module	Cap5	where
data Coisa2 a2 = Nada2 | UmaCoisa2 a2 | DuasCoisas2 a2 a2 deriving (Read, Show)
lerCoisa :: Coisa2 Int -> Coisa2 Int
lerCoisa Nada2 = UmaCoisa2 0
lerCoisa (UmaCoisa2 x) = UmaCoisa2 (x+1)
lerCoisa (DuasCoisas2 x y) = DuasCoisas2 (2*x) (y-3)


-- Classe	Num
-- A	classe		Num		é	definida	por:
-- class Num a where
--   (+), (-), (*) :: a -> a -> a
--   abs           :: a -> a
--   signum        :: a -> a
--   fromInteger   :: Integer -> a


-- Classe	Fractional
-- A	classe		Fractional		é	definida	por:
-- class (Num a) => Fractional a where
--   (/)          :: a -> a -> a
--   fromRational :: Rational -> a

-- Classe	Real
-- A	classe		Real		de	tipo		(Num	a,	Ord	a)	=>	Real	a		provê	a
-- função		toRational	::	a	->	Rational	,	que	converte	seu	tipo
-- a		em	uma	fração.	Todo	tipo	instância	de		Real		também	deve,
-- obrigatoriamente,	ser	instância	de		Num		e		Ord	.



-- Classe	Integral
-- A	classe		Integral		determina	que	um	tipo		a		é	capaz	de
-- realizar	divisões	inteiras	com	quociente.	As	funções	a	serem
-- implementadas	são:
-- quotRem	::	a	->	a	->	(a,	a)	,	que	retorna	o	quociente
-- na	primeira	coordenada	da	tupla	e	o	resto	na	segunda.
-- toInteger	::	a	->	Integer	,	que	converte	seu	tipo		a	
-- em	um		Integer	.
-- Todo	tipo	instância	da	classe		Integral		deve	ser	instância
-- também	de		Real		e		Enum	,	conforme	a	declaração		class	(Real
-- a,	Enum	a)	=>	Integral	a	.



-- Classe	Enum
-- A	classe		Enum		possui	uma	interface	para	enumerações	de	tipo,
-- por	exemplo:
-- data	Dia	=	Domingo	|	Segunda	|	Terca	|	Quarta	|	Quinta	|	Sexta	|	
-- Sabado
-- Isso	pode	ser	associado	a	um	inteiro,	por	exemplo,		Domingo	=
-- 1	,	...,		Sabado	=	7	.	Esta	classe	possui	a	definição:
-- class	Enum	a	where
-- toEnum	::	Int	->	a	
-- fromEnum	::	a	->	Int
-- Ela	converte	seu	tipo		a		nesse	inteiro	representando	uma
-- contagem.	Todo	tipo	instância	de		Enum		ganha	de	graça	as	funções
-- succ		e		pred	,	que	indicam	o	sucessor	e	o	predecessor	de	um
-- valor.	Se	colocarmos		deriving	Enum		no	tipo		Dia	,	teremos	a
-- enumeração	anterior	como:
-- Prelude>	succ	Domingo
-- Segunda
-- Prelude>	pred	Segunda
-- Domingo

data Dia = Domingo | Segunda | Terca | Quarta | Quinta | Sexta | Sabado

-- class Enum a where
--   toEnum   :: Int -> a
--   fromEnum :: a -> Int


-- Classe	Ord
-- A	classe		Ord		indica	que	seu	tipo	possui	ordenação	por	meio
-- do	operador		<=	.	A	classe		Ord		é	definida	como:

-- class	Eq	a	=>	Ord	a	where
-- (<=)	::	a	->	a	->	Bool

-- Prelude>	"HASKELL"	>	"OLA"
-- True


-- Classe	Bounded
-- Finalmente,	vemos	a	classe		Bounded	:
-- class	Bounded	a	where
-- minBound,	maxBound	::	a
-- As	funções	que	não	possuem	entrada		minBound		e		maxBound	
-- representam	os	limites	mínimo	e	máximo	do	seu	tipo.	Para	o	tipo
-- Dia	,	poderíamos	criar	a	instância:
-- instance	Bounded	Dia	where
-- minBound	=	Domingo
-- maxBound	=	Sabado


-- Criando	uma	classe
-- Quando	é	necessário,	por	exemplo,	ler	diferentes	tipos	de
-- arquivo	cujo	conteúdo	deve	ser	representado	por	um	tipo	em
-- Haskell,	ou	criar	uma	interface	para	validação	de	vários	tipos	de
-- dados,	precisamos	criar	uma	classe.

-- Aqui, diferente dos exemplos anteriores, você cria sua própria classe, então pode colar como código normal:
-- O que cada parte faz:

-- class SimNao a: cria uma "interface". Todo tipo que quiser fazer parte dela precisa implementar simnao, 
-- que recebe um valor e responde True ou False.
-- instance SimNao Int: define o que simnao significa para inteiros. Aqui funciona como validação de idade: 
-- abaixo de 18 é False. O | são guardas (condições testadas em ordem) e otherwise é o "senão".
-- instance SimNao [a]: define para qualquer lista. Lista vazia é False, qualquer outra é True. Como String é
-- uma lista de Char, serve para validar se um campo de texto foi preenchido.
class SimNao a where
  simnao :: a -> Bool

instance SimNao Int where
  simnao x
    | x < 18    = False
    | otherwise = True

instance SimNao [a] where
  simnao [] = False
  simnao _  = True

-- simnao (1::Int)    -- False
-- simnao (20::Int)   -- True
-- simnao "João"      -- True
-- simnao ""          -- False


-- 5.5	SEMIGRUPOS
-- Associatividade:		(a	<>	b)	<>	c	=	a	<>	(b	<>	c)		para
-- quaisquer	valores		a	,		b		e		c		de		m	

-- class Semigroup a where
--   (<>) :: a -> a -> a

--  Prelude>	[1,2,4]	<>	[0,9]	<>	[8,5]
-- [1,2,4,0,9,8,5]


-- 5.6	MONOIDES
-- Associatividade:		(a	<>	b)	<>	c	=	a	<>	(b	<>	c)		para
-- quaisquer	valores		a	,		b	,		c		de		m	.

-- Elemento	neutro:	existe	um	elemento		e		em		m	,	tal	que		a
-- <>	e	=	a		e		e	<>	a	=	a		para	todo	valor		a		de		m


-- No	Haskell,	o	elemento	neutro	é	chamado	de		mempty	.	A	classe
-- Monoid		vive	no	Prelude	e,	desde	o	GHC	8.4,	tem	a		Semigroup	
-- como	superclasse.	Isso	quer	dizer	que,	para	um	tipo	ser	monoide,
-- ele	obrigatoriamente	já	deve	ser	semigrupo.	Sua	definição
-- (simplificada)	é:
-- class	Semigroup	a	=>	Monoid	a	where
-- mempty	::	a


-- Observe	que	o	elemento	neutro	da	soma	é	o	número
-- 0	,	pois		x	+	0	=	x		para	qualquer	número		x	;	e	o	da
-- multiplicação	é	o	número		1	,	pois		y	*	1	=	y		para	qualquer
-- número		y	.	Como	a	soma	e	a	multiplicação	são	associativas,	por
-- exemplo,		(5+3)+2	=	5+(3+2)	=	10		e		(5*3)*2	=	5*(3*2)	=
-- 30	,	ambas	formam	monoides


-- Porém,	em	Haskell,	só	conseguimos	ter	uma	instância	de	cada
-- classe	para	cada	tipo	por	vez.	Se	déssemos	uma	instância	de
-- Monoid		direto	para		Int	,	teríamos	de	escolher	entre	a	soma	e	a
-- multiplicação,	causando	uma	ambiguidade.	Será	que	devemos
-- escolher	uma	ou	outra?	Por	isso	o		Int		não	tem	instância	de
-- Monoid	.	Para	resolver	esse	problema,	há	dois		newtype	s	de	kind
-- *	->	*		no	módulo		Data.Monoid		que	embrulham	um	número	e
-- escolhem	a	operação	para	nós.	São	eles		Sum		e		Product	,
-- declarados	(de	forma	simplificada)	como:

-- newtype Sum a     = Sum     { getSum     :: a }
-- newtype Product a = Product { getProduct :: a }

-- instance Num a => Semigroup (Sum a) where
--   Sum x <> Sum y = Sum (x + y)

-- instance Num a => Monoid (Sum a) where
--   mempty = Sum 0

-- instance Num a => Semigroup (Product a) where
--   Product x <> Product y = Product (x * y)

-- instance Num a => Monoid (Product a) where
--   mempty = Product 1


-- Prelude>	:m	Data.Monoid
-- Prelude	Data.Monoid>	Sum	5	<>	Sum	6
-- Sum	{getSum	=	11}
-- Prelude	Data.Monoid>	getSum	(Sum	5	<>	Sum	6)
-- 11
-- Prelude	Data.Monoid>	Product	5	<>	Product	6
-- Product	{getProduct	=	30}
-- :set prompt "%s> "


-- Instâncias	de	monoide
-- instance Semigroup [a] where
--   (<>) = (++)

-- instance Monoid [a] where
--   mempty = []

--     Seu		<>		é	a	concatenação	e,	com	isso,	seu		mempty		é	a	lista
-- vazia,	pois	ao	concatenarmos	qualquer	lista	à	lista	vazia,	não
-- teremos	efeito	algum.	Essa	operação	é	claramente	associativa,
-- então,	não	importa	por	onde	começamos	a	concatenar,	o	resultado
-- será	o	mesmo.	Por	exemplo:		[1,2,4]	<>	([0,9]	<>	[8,5])	=
-- ([1,2,4]	<>	[0,9])	<>	[8,5]	=	[1,2,4,0,9,8,5]
-- mconcat :: (Monoid a) => [a] -> a
-- mconcat xs = foldr (<>) mempty xs

-- Prelude	Data.Monoid>	mconcat	[Sum	7,	Sum	3,	Sum	10]
-- Sum	{getSum	=	20}
-- Prelude	Data.Monoid>	mconcat	["Ola	Mundo",	"	Haskell",	"!!!"]
-- "Ola	Mundo	Haskell!!!





-- 5.1) Crie o tipo TipoProduto que possui os value constructors
--      Escritorio, Informatica, Livro, Filme e Total.
--      O tipo Produto possui um value constructor — de mesmo nome — com os
--      campos valor (Double) e tp (TipoProduto), e um value constructor
--      Nada, que representa a ausência de um Produto.
--      Deseja-se calcular o valor total de uma compra, sem nenhuma conversão
--      para inteiro e de forma combinável. Crie uma instância de monoide
--      para Produto, de modo que o retorno sempre tenha Total no campo tp
--      e a soma dos dois produtos em valor.
--      Explique como seria o exercício sem o uso de monoides.
--      Qual(is) seria(m) a(s) diferença(s)?

data TipoProduto = Escritorio | Informatica | Livro | Filme | Total deriving Show

data Produto = Produto {valor:: Double, tp :: TipoProduto} | Nada deriving Show

instance Semigroup Produto where
  Produto v1 _ <> Produto v2 _ = Produto (v1 + v2) Total
  Nada         <> p            = p
  p            <> Nada         = p
 
instance Monoid Produto where
  mempty = Nada

-- 5.2) Crie uma função totalGeral que recebe uma lista de produtos e
--      retorna o preço total deles usando o monoide anterior.
totalGeral :: [Produto] -> Double
totalGeral ps = valor (mconcat ps)


-- 5.3) A função min no Haskell retorna o menor entre dois números,
--      por exemplo, min 4 5 = 4.
--      * Crie um tipo Min com um campo inteiro, que seja instância de
--        Ord, Eq e Show (deriving).
--      * Crie uma instância de Semigroup e de Monoid para Min
--        (maxBound representa o maior inteiro existente no Haskell).
--      * Quanto vale a expressão Min (-32) <> Min (-34) <> Min (-33)?
--      * Explique sua escolha para o mempty.

data Min = Min Int deriving (Ord, Eq, Show)

instance Semigroup Min where
  Min a <> Min b = Min (min a b)
 
instance Monoid Min where
  mempty = Min maxBound

-- 5.4) Crie uma função minAll que recebe um [Min] e retorna um Min
--      contendo o menor valor.
minAll :: [Min] -> Min
minAll = mconcat

-- 5.5) A função max no Haskell retorna o maior entre dois números,
--      por exemplo: max 4 5 = 5.
--      * Crie um tipo Max com um campo inteiro que seja instância de
--        Ord, Eq e Show (deriving).
--      * Crie uma instância de Semigroup e de Monoid para Max
--        (minBound representa o menor inteiro existente no Haskell).
--      * Quanto vale a expressão Max 10 <> Max 13 <> Max 5?
--      * Explique sua escolha para o mempty.
--      * Crie uma função maxAll que recebe um [Max] e retorna um Max
--        contendo o maior valor.
data Max = Max Int deriving (Ord, Eq, Show)

instance Semigroup Max where
  Max a <> Max b = Max (max a b)

instance Monoid Max where
  mempty = Max minBound


-- 5.6) Crie o tipo Paridade com os value constructors Par e Impar.
--      Crie o typeclass ParImpar que contém a função
--      decide :: a -> Paridade e possui as instâncias:
--      * Para Int: noção de Par/Impar de Int.
--      * Para [a]: uma lista de elementos qualquer é Par se o número de
--        elementos o for.
--      * Bool: False como Par, True como Impar.

data Paridade = Par | Impar deriving Show

class ParImpar a where
  decide :: a -> Paridade

instance ParImpar Int where
  decide n
    | n `mod` 2 == 0 = Par
    | otherwise      = Impar
 
instance ParImpar [a] where
  decide xs = decide (length xs)
 
instance ParImpar Bool where
  decide False = Par
  decide True  = Impar

-- 5.7) Usando a estrutura de árvore, monte uma função mapa, que jogue uma
--      função passada por parâmetro para todos os elementos de uma árvore.
--      Deixe explícito o tipo desta função.

mapa :: (a -> b) -> Arvore a -> Arvore b
mapa _ Nulo           = Nulo
mapa f (Leaf x)       = Leaf (f x)
mapa f (Branch x l r) = Branch (f x) (mapa f l) (mapa f r)

-- 5.8) Usando o exercício anterior, some 5 a cada elemento de uma árvore
--      de inteiros.
somaCinco :: Arvore Int -> Arvore Int
somaCinco = mapa (+5)

-- 5.9) Usando a estrutura de árvore vista, faça uma função que some todos
--      os elementos de uma árvore de números.
somaArvore :: Num a => Arvore a -> a
somaArvore Nulo           = 0
somaArvore (Leaf x)       = x
somaArvore (Branch x l r) = x + somaArvore l + somaArvore r

-- 5.10) Implemente os percursos pós-ordem e pré-ordem. Via comentário,
--       faça os "testes de mesa" para os dois percursos da árvore:
--       Branch 15 (Branch 11 (Leaf 6) (Branch 12 (Leaf 10) Nulo))
--                 (Branch 20 Nulo (Branch 22 (Leaf 21) Nulo))

preOrdem :: Arvore a -> [a]
preOrdem Nulo           = []
preOrdem (Leaf x)       = [x]
preOrdem (Branch x l r) = [x] ++ preOrdem l ++ preOrdem r
 
posOrdem :: Arvore a -> [a]
posOrdem Nulo           = []
posOrdem (Leaf x)       = [x]
posOrdem (Branch x l r) = posOrdem l ++ posOrdem r ++ [x]
 
arvTeste :: Arvore Int
arvTeste = Branch 15 (Branch 11 (Leaf 6) (Branch 12 (Leaf 10) Nulo))
                     (Branch 20 Nulo (Branch 22 (Leaf 21) Nulo))
 
--          15
--        /    \
--      11      20
--     /  \       \
--    6    12      22
--        /       /
--      10      21
--
-- Pré-ordem (raiz, esquerda, direita): [15,11,6,12,10,20,22,21]
-- Pós-ordem (esquerda, direita, raiz): [6,10,12,11,21,22,20,15]

-- 5.11) Faça uma função para inserir um elemento em uma árvore de busca
--       binária (use a mesma estrutura vista).

inserirArv :: Ord a => a -> Arvore a -> Arvore a
inserirArv x Nulo     = Leaf x
inserirArv x (Leaf y) = inserirArv x (Branch y Nulo Nulo)
inserirArv x (Branch y l r)
  | x < y     = Branch y (inserirArv x l) r
  | otherwise = Branch y l (inserirArv x r)

-- 5.12) Faça uma função que, a partir de uma lista de elementos de um
--       tipo, insira todos os elementos desta lista na árvore e
--       retorne-a, usando o exercício anterior.
daLista :: Ord a => [a] -> Arvore a
daLista xs = foldr inserirArv Nulo (reverse xs)


-- 5.13) Uma lista ordenada é uma lista cujos elementos são inseridos de
--       forma ordenada (crescente). Usando o tipo
--       data ListaOrd a = a :?: (ListaOrd a) | Nulo deriving Show
--       crie as funções:
--         inserir :: (Ord a) => a -> ListaOrd a -> ListaOrd a
--         remover :: (Eq a)  => a -> ListaOrd a -> ListaOrd a
--         tamanho :: ListaOrd a -> Int
--       Observação: a função remover deve buscar um elemento. Se não
--       achar, a lista deve se manter intacta.

data ListaOrd a = a :?: (ListaOrd a) | Vazia deriving Show
 
inserir :: Ord a => a -> ListaOrd a -> ListaOrd a
inserir x Vazia = x :?: Vazia
inserir x (y :?: ys)
  | x <= y    = x :?: (y :?: ys)
  | otherwise = y :?: inserir x ys

remover :: Eq a => a -> ListaOrd a -> ListaOrd a
remover _ Vazia = Vazia
remover x (y :?: ys)
  | x == y    = ys
  | otherwise = y :?: remover x ys
 
tamanho :: ListaOrd a -> Int
tamanho Vazia      = 0
tamanho (_ :?: ys) = 1 + tamanho ys

-- 5.14) Mostramos que Min e Max formam monoides porque os tipos Int têm um
--       maior e um menor valor (maxBound e minBound). Considere agora o
--       tipo das listas não vazias NonEmpty (do módulo
--       Data.List.NonEmpty), cujo <> é a concatenação.
--       * Por que NonEmpty é um Semigroup, mas não é um Monoid?
--         (Dica: pense em qual seria o mempty.)
--       * Dê outro exemplo de um tipo que seja semigrupo, mas não
--         monoide, e justifique.

-- 5.15) Crie o tipo data Mediana = Mediana {soma :: Double, qtd :: Int},
--       que acumula a soma de vários números e a quantidade deles.
--       Crie instâncias de Semigroup e Monoid para Mediana (some as somas
--       e some as quantidades; o mempty deve ser o elemento neutro).
--       Em seguida, crie a função media :: Mediana -> Double e use mconcat
--       para calcular, em uma só passada, a média de uma lista de Mediana.

data Mediana = Mediana { soma :: Double, qtd :: Int } deriving Show

instance Semigroup Mediana where
  Mediana s1 q1 <> Mediana s2 q2 = Mediana (s1 + s2) (q1 + q2)
 
instance Monoid Mediana where
  mempty = Mediana 0 0
 
media :: Mediana -> Double
media (Mediana s q) = s / fromIntegral q
 
-- media (mconcat [Mediana 10 1, Mediana 20 1, Mediana 30 1])  -- 20.0