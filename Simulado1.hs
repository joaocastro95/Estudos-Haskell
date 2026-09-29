module Simulado1 where

-- 1. (2.5 pontos) Considere o tipo Produto contendo os campos nome, valor e
--    categoria. Os campos nome e valor são String e Double, respectivamente,
--    ao passo que categoria é um tipo Categoria que possui os valores
--    Livro, Brinquedo e Escritorio. Crie os dois tipos com instâncias
--    necessárias para a solução deste exercício e implemente as funções:
--    * extrairLivros :: [Produto] -> [Double]
--      que retorna uma lista com todos os preços de livros;
--    * maxValorBrinq :: [Produto] -> Double
--      que retorna o preço do produto de valor máximo de um brinquedo;
--    * countEscr :: [Produto] -> Int
--      que retorna a quantidade de itens de Escritório.

data Categoria = Livro | Brinquedo | Escritorio deriving (Show,Eq,Ord,Enum)

data Produto = Produto { nome :: String, valor :: Double, categoria :: Categoria } deriving (Show,Eq,Ord)

extrairLivros :: [Produto] -> [Double]
extrairLivros ps = [valor p | p <- ps, categoria p == Livro]

maxValorBrinq :: [Produto] -> Double
maxValorBrinq ps = maximum [valor p | p <- ps, categoria p == Brinquedo]

countEscr :: [Produto] -> Int
countEscr ps = length [p | p <- ps, categoria p == Escritorio]

produtos = [ Produto "Duna" 50 Livro, Produto "Lego" 200 Brinquedo, Produto "Bola" 30 Brinquedo, Produto "Caneta" 3 Escritorio, Produto "1984" 40 Livro ]

-- 2. (2.5 pontos) Considere o tipo data DeMorgan = DeMorgan Bool, crie uma
--    instância de Semigroup para este tipo. A operação de DeMorgan é
--    "não a ou b" (você deve traduzir para a linguagem). Esta operação é
--    realmente um semigrupo? Justifique cuidadosamente.

data DeMorgan = DeMorgan Bool deriving Show

instance Semigroup DeMorgan where
    DeMorgan a <> DeMorgan b = DeMorgan (not a || b)


-- NÃO é um semigrupo de verdade. O código compila, mas quebra a lei da
-- associatividade, que todo semigrupo precisa cumprir:
--   (x <> y) <> z  ==  x <> (y <> z)
--
-- Contraexemplo com a = False, b = False, c = False:
--
-- Esquerda: (False <> False) <> False
--         = (not False || False) <> False
--         = True <> False
--         = not True || False
--         = False
--
-- Direita:  False <> (False <> False)
--         = False <> (not False || False)
--         = False <> True
--         = not False || True
--         = True
--
-- False /= True, logo a operação não é associativa e não forma semigrupo.
--
-- Teste:
-- (DeMorgan False <> DeMorgan False) <> DeMorgan False   -- DeMorgan False
-- DeMorgan False <> (DeMorgan False <> DeMorgan False)   -- DeMorgan True

-- 3. (2.5 pontos) Considere o tipo data Tupla a = Tupla a a a
--    * Qual o kind de Tupla String?
--    * Crie uma instância de Functor para Tupla.
--    * Qual o tipo da expressão Tupla True False False?
--    * Qual o tipo da expressão Tupla '4' '3' '3'?
--    * Faça uma função mostra :: Tupla a -> [a] que converte tuplas em listas.

data Tupla a = Tupla a a a deriving Show
--   (Tupla sozinho é * -> *; com o String já "preenchido", vira *)

instance Functor Tupla where
    fmap g (Tupla x y z) = Tupla (g x) (g y) (g z)

-- Qual o tipo da expressão Tupla True False False?
--   Tupla Bool
 
-- Qual o tipo da expressão Tupla '4' '3' '3'?
--   Tupla Char

mostra :: Tupla a -> [a]
mostra (Tupla x y z) = [x, y, z]

-- 4. (2.5 pontos) Avalie as expressões abaixo. Mostre as principais etapas
--    da avaliação. Não é necessário informar o tipo das expressões.
--    Considere as seguintes definições:

i = \x -> x
k = \x -> \y -> x
s = \f -> \g -> \x -> f x (g x)
 
-- (a) (\x -> x) 7
--     = 7
 
-- (b) (\x -> x + 2) 5
--     = 5 + 2
--     = 7
 
-- (c) (\f x y -> f y x) k "Haskell" "Java"
--     = k "Java" "Haskell"
--     = "Java"
 
-- (d) (\x -> \y -> x + y) 4 6
--     = (\y -> 4 + y) 6
--     = 4 + 6
--     = 10
 
-- (e) (\f -> \x -> f (f x)) (\x -> x + 1) 3
--     = (\x -> x + 1) ((\x -> x + 1) 3)
--     = (\x -> x + 1) 4
--     = 5
 
-- (f) (\x -> (\y -> x * y) 4) 5
--     = (\y -> 5 * y) 4
--     = 5 * 4
--     = 20
 
-- (g) i "Lambda"
--     = (\x -> x) "Lambda"
--     = "Lambda"
 
-- (h) k 10 20
--     = (\y -> 10) 20
--     = 10
 
-- (i) s k k "Haskell"
--     = k "Haskell" (k "Haskell")
--     = "Haskell"
 
-- (j) s (k (\x -> x + 1)) (k 4) 10
--     = k (\x -> x + 1) 10 (k 4 10)
--     = (\x -> x + 1) (k 4 10)
--     = (\x -> x + 1) 4
--     = 5


-- 5. (2.5 pontos) Dê o tipo das expressões abaixo da maneira mais genérica
--    possível:

-- (a) \x y -> x                      :: a -> b -> a
-- (b) not True                       :: Bool
-- (c) 6                              :: Num a => a
-- (d) (False, "False", 'K', "K")     :: (Bool, String, Char, String)
-- (e) ['E','Y','3']                  :: [Char]   (ou String)
-- (f) map id                         :: [a] -> [a]

-- 6. (2.5 pontos) Considere data () = () e complete:
--
--    f1 :: (a,b,c) -> (c,b,b,a)
--    f1 (a,b,c ) = (c,b,b,a)

--    f2 :: a -> ((),a,())
--    f2 a = ((),a,())
--
--    f3 :: Maybe a -> Either a ()
--    f3 (Just a) = Left a
--    f3 Nothing  = Right ()
--
--    f4 :: (a -> b) -> a -> b
--    f4 g x = g x
--
--    f5 :: (a -> b) -> (c,a,()) -> (c,b,())
--    f5  g = \(c,a,u) -> (c, g a, u)