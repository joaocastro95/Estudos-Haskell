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

-- Prelude>	:t	fmap
-- fmap	::	(Functor	f)	=>	(a	->	b)	->	f	a	->	f	b

-- Se	usarmos	o	currying,	podemos	enxergar		fmap	g		como	uma
-- função	que	recebe	algo	de	tipo		f	a	->	f	b	,	ou	seja,	algo	que
-- recebe		f	a		e	devolve		f	b	.	Todo	tipo	que	seja	instância	de
-- Functor		deve	ser	implementado	segundo	as	leis	dos	funtores
-- (assim	como	nos	monoides).
-- fmap	id	x	=	x	
-- fmap	(g.h)	x	=	(fmap	g	.	fmap	h)	x


-- 7.1	FUNTOR	MAYBE
-- O	tipo		Maybe		é	um	tipo	de	kind		*	->	*		definido	como:
-- data	Maybe	a	=	Just	a	|	Nothing
-- O	value	constructor		Just	,	que	possui	um	campo	de	tipo
-- variável		a	,	pode	representar	uma	computação	validada,	ao	passo
-- que		
-- Nothing		
-- representa	um	erro	ou	ausência	de	uma
-- computação.	Este	tipo	é	usado	para	validações	de	dados,	como:


divisao :: Double -> Double -> Maybe Double
divisao x 0 = Nothing
divisao x y = Just (x / y)

-- fmap (+1) (divisao 10 2)   -- Just 6.0
-- fmap (+1) (divisao 10 0)   -- Nothing

-- instance	Functor	Maybe	where
-- fmap	g	Nothing	=	Nothing
-- fmap	g	(Just	x)	=	Just	(g	x)


-- Há	também	um	operador	que	representa	o		fmap	,	chamado
-- <$>	,	que	nada	mais	é	do	que	sua	forma	infixa:
-- Prelude>	(2*)	<$>	(divisao	10	2)
-- Just	10


-- 7.2	CRIANDO	SEU	FUNTOR

-- Os	funtores	ajudam	as	funções	a	operar	mais	facilmente	com
-- tipos	similares	aos	citados.	É	possível	criar	nosso	contêiner
-- contendo	dois	espaços	para	um	mesmo	tipo		a	,	como	por
-- exemplo,	o	tipo:
data Dupla a = Dupla a a deriving Show

instance Functor Dupla where
  fmap g (Dupla x y) = Dupla (g x) (g y)

-- fmap (*2) (3, 5)       -- (3, 10)
-- fmap (*2) (Dupla 3 5)  -- Dupla 6 10



-------------------------------------------------------------------------------
-- 7.3 FUNTORES APLICATIVOS
-------------------------------------------------------------------------------

-- Problema: o fmap só funciona quando a FUNÇÃO está fora do contêiner
-- e com um parâmetro só:
--   fmap (2*) (Just 10)            -- Just 20
--
-- Mas e se a função também estiver dentro do contêiner?
--   Just (2*)  ???  Just 10
-- Para isso existe o operador <*>, da classe Applicative.

-- Definição da classe (já existe no Prelude, por isso comentada):
-- class Functor f => Applicative f where
--   pure  :: a -> f a
--   (<*>) :: f (a -> b) -> f a -> f b
--
-- pure  -> coloca um valor dentro do contêiner.   pure 5 = Just 5
-- <*>   -> aplica uma função que está DENTRO do contêiner
--          em um valor que também está dentro.

-- Comparação com o $ (aplicação normal de função):
--   ($)   ::   (a -> b) ->   a ->   b
--   (<*>) :: f (a -> b) -> f a -> f b
-- É a mesma ideia, só que tudo dentro de um f.

-- Prelude>	Just	(2*)	<*>	Just	10
-- Just	20
-- Prelude>	[(2*),	id,	(3*)]	<*>	[1,2]
-- [2,4,1,2,3,6]

-------------------------------------------------------------------------------
-- Instância para Maybe (já existe, comentada)
-------------------------------------------------------------------------------
-- instance Applicative Maybe where
--   pure x = Just x
--   (Just f) <*> (Just x) = Just (f x)   -- tem função e valor: aplica
--   _        <*> _        = Nothing      -- faltou algum: Nothing

-- Testes:
-- Just (2*) <*> Just 10    -- Just 20
-- Just (2*) <*> Nothing    -- Nothing

-------------------------------------------------------------------------------
-- Instância para listas (já existe, comentada)
-------------------------------------------------------------------------------
-- instance Applicative [] where
--   pure x    = [x]
--   fs <*> xs = [f x | f <- fs, x <- xs]
--
-- Aplica CADA função da primeira lista em CADA valor da segunda.

-- Teste:
-- [(2*), id, (3*)] <*> [1,2]
-- (2*) em 1 e 2 -> 2, 4
-- id   em 1 e 2 -> 1, 2
-- (3*) em 1 e 2 -> 3, 6
-- Resultado: [2,4,1,2,3,6]

-------------------------------------------------------------------------------
-- Funções com mais de um parâmetro
-------------------------------------------------------------------------------
-- Dividir Just 10 por Just 2 sem "tirar" os valores de dentro do Maybe:
--
-- pure (/) <*> Just 10 <*> Just 2    -- Just 5.0
-- (/) <$> Just 10 <*> Just 2         -- Just 5.0   (forma mais comum)
--
-- <$> é o mesmo que fmap, escrito como operador.
--
-- Passo a passo (associa à esquerda + currying):
-- (/) <$> Just 10 <*> Just 2
-- = Just (10/) <*> Just 2     -- fmap coloca o 10 como 1º argumento
-- = Just (10/2)               -- <*> aplica a função no 2
-- = Just 5.0
--
-- Se qualquer um for Nothing, o resultado é Nothing:
-- (/) <$> Just 10 <*> Nothing        -- Nothing
--
-- Conclusão do livro: fmap f x = pure f <*> x



-------------------------------------------------------------------------------
-- Exemplo do formulário (estilo Yesod)
-------------------------------------------------------------------------------
-- Form representa um valor digitado num campo de formulário.
-- Criei um Form simples para dar para testar.

newtype Form a = Form a deriving Show

instance Functor Form where
  fmap g (Form x) = Form (g x)

instance Applicative Form where
  pure x = Form x
  Form g <*> Form x = Form (g x)

-- Chamei de PessoaForm para não conflitar com o Pessoa que você já tem.
data PessoaForm = PessoaForm String Int deriving Show

-- O construtor PessoaForm é uma função: String -> Int -> PessoaForm
-- Passo a passo:
-- PessoaForm <$> Form "Joao" <*> Form 40
-- = Form (PessoaForm "Joao") <*> Form 40
-- = Form (PessoaForm "Joao" 40)

-- Teste no GHCi:
-- PessoaForm <$> Form "Joao" <*> Form 40




-------------------------------------------------------------------------------
-- 7.4 FUNTORES CONTRAVARIANTES (seção opcional)
-------------------------------------------------------------------------------

-- Nem todo tipo de kind * -> * pode ser Functor.
-- Exemplo: um tipo que guarda uma FUNÇÃO que recebe a e devolve Bool.

data Predicado a = Predicado { runPred :: a -> Bool }

-- Predicado guarda uma regra de validação.
-- runPred tira a função de dentro para poder usar.

ehMenor4 :: Predicado Int
ehMenor4 = Predicado (\x -> x < 4)

tamanhoOito :: Predicado String
tamanhoOito = Predicado (\x -> length x == 8)

-- Testes no GHCi:
-- runPred ehMenor4 8              -- False
-- runPred ehMenor4 (-5)           -- True
-- runPred tamanhoOito "Haskell"   -- False (7 letras)
-- runPred tamanhoOito "HASKELL "  -- True  (8 com o espaço)

-------------------------------------------------------------------------------
-- Por que Predicado NÃO pode ser Functor?
-------------------------------------------------------------------------------
-- O fmap precisaria ter este tipo:
--   fmap :: (a -> b) -> Predicado a -> Predicado b
--
-- Temos:  g :: a -> b      e      p :: a -> Bool
-- Queremos montar algo do tipo:   b -> Bool
--
-- Tentativa 1: g . p  -> p devolve Bool, mas g espera a. Não encaixa.
-- Tentativa 2: p . g  -> g devolve b, mas p espera a. Não encaixa.
--
-- Não existe jeito de transformar um b em a, então não dá.
-- O problema: o a está na ENTRADA da função, não na saída.

-------------------------------------------------------------------------------
-- A solução: Contravariant (a "seta invertida")
-------------------------------------------------------------------------------
-- Classe (já existe em Data.Functor.Contravariant, por isso comentada):
-- class Contravariant f where
--   contramap :: (a -> b) -> f b -> f a
--
-- Compare:
--   fmap      :: (a -> b) -> f a -> f b
--   contramap :: (a -> b) -> f b -> f a    <- o resultado "volta"

instance Contravariant Predicado where
  contramap g (Predicado p) = Predicado (p . g)

-- Agora encaixa:
--   g :: a -> b        (primeiro transforma a em b)
--   p :: b -> Bool     (depois valida o b)
--   p . g :: a -> Bool
--
-- Ou seja: contramap coloca uma função ANTES da validação,
-- mudando o tipo que o Predicado aceita.

-------------------------------------------------------------------------------
-- Exemplo: reaproveitar ehMenor4 para validar Strings
-------------------------------------------------------------------------------
-- length :: String -> Int
-- ehMenor4 :: Predicado Int
-- contramap length ehMenor4 :: Predicado String

tamanhoMenor4 :: Predicado String
tamanhoMenor4 = contramap length ehMenor4

-- runPred tamanhoMenor4 "Haskell"   -- False (7 não é < 4)
-- runPred tamanhoMenor4 "ABA"       -- True  (3 é < 4)
--
-- Passo a passo para "ABA":
-- length "ABA" = 3  ->  3 < 4  ->  True

-------------------------------------------------------------------------------
-- Para ir além (só para saber que existem):
-- Bifuntor:  aplica duas funções, ambas "sem inverter a seta".
-- Profuntor: aplica uma "sem inverter" e outra "invertendo" a seta.
-------------------------------------------------------------------------------