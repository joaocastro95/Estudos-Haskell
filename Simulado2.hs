module Simulado2 where

-- 1. (2.5 pontos) Considere o tipo Aluno contendo os campos nome, nota e
--    turno. Os campos nome e nota são String e Double, respectivamente,
--    ao passo que turno é um tipo Turno que possui os valores
--    Manha, Tarde e Noite. Crie os dois tipos com instâncias necessárias
--    para a solução deste exercício e implemente as funções:
--    * notasNoite :: [Aluno] -> [Double]
--      que retorna uma lista com as notas dos alunos da noite;
--    * menorNotaManha :: [Aluno] -> Double
--      que retorna a menor nota entre os alunos da manhã;
--    * countAprovados :: [Aluno] -> Int
--      que retorna a quantidade de alunos com nota maior ou igual a 6.

data Turno = Manha | Tarde | Noite deriving (Show,Eq,Ord,Enum)

data Aluno = Aluno {nome :: String, nota :: Double, turno :: Turno} deriving (Show,Eq,Ord)

notasNoite :: [Aluno] -> [Double]
notasNoite xs = [nota x | x <- xs, turno x == Noite]

menorNotaManha :: [Aluno] -> Double
menorNotaManha xs = minimum [nota x | x <- xs, turno x == Manha]

countAprovados :: [Aluno] -> Int
countAprovados xs = length [x | x <- xs,  nota x >= 6]

alunos = [ Aluno "Ana" 8 Manha, Aluno "Bia" 5 Noite , Aluno "Caio" 4 Manha, Aluno "Duda" 9 Noite ]


-- 2. (2.5 pontos) Considere o tipo data Xor = Xor Bool, crie uma instância
--    de Semigroup para este tipo. A operação é "a ou b, mas não os dois"
--    (você deve traduzir para a linguagem). Esta operação é realmente um
--    semigrupo? Justifique cuidadosamente. É possível criar uma instância
--    de Monoid? Se sim, qual seria o mempty?

data Xor = Xor bool deriving Show

instance Semigroup Xor where
Xor a <> Xor b = Xor (a /= b)

-- SIM, é semigrupo: o xor é associativo.
-- (a <> b) <> c  ==  a <> (b <> c)
-- O resultado é True quando a quantidade de True é ímpar, não importa
-- a ordem em que se agrupa. Exemplo com True, True, True:
--   (True <> True) <> True = False <> True = True
--   True <> (True <> True) = True <> False = True
--
-- SIM, dá para ser Monoid, com mempty = Xor False:
--   False <> b = b   (False /= b é o próprio b)
 
instance Monoid Xor where
  mempty = Xor False

-- 3. (2.5 pontos) Considere o tipo data Par a = Par a a
--    * Qual o kind de Par?
--    * Qual o kind de Par Int?
--    * Crie uma instância de Functor para Par.
--    * Qual o tipo da expressão Par "sol" "lua"?
--    * Qual o tipo da expressão fmap length (Par "sol" "lua")?
--    * Faça uma função somaPar :: Num a => Par a -> a que soma os dois
--      valores.

data Par a = Par a a deriving Show

-- Kind de Par:      * -> *
-- Kind de Par Int:  *

instance Functor Par where
fmap g (Par x y) = Par (g x) (g y)

-- Par "sol" "lua"               :: Par String
-- fmap length (Par "sol" "lua") :: Par Int      (resultado: Par 3 3)
somaPar :: Num a => Par a -> a
somaPar (Par x y) = x + y

-- 4. (2.5 pontos) Avalie as expressões abaixo. Mostre as principais etapas
--    da avaliação. Não é necessário informar o tipo das expressões.
--    Considere as seguintes definições:
--      i = \x -> x
--      k = \x -> \y -> x
--      s = \f -> \g -> \x -> f x (g x)
--
-- (a) (\x -> x - 1) 10
--     = 10 - 1
--     = 9
 
-- (b) (\x y -> x * y) 3 7
--     = 3 * 7
--     = 21
 
-- (c) (\f x y -> f y x) (\a b -> a ++ b) "mundo" "ola "
--     = (\a b -> a ++ b) "ola " "mundo"
--     = "ola " ++ "mundo"
--     = "ola mundo"
 
-- (d) (\x -> \y -> \z -> x + y + z) 1 2 3
--     = (\y -> \z -> 1 + y + z) 2 3
--     = (\z -> 1 + 2 + z) 3
--     = 1 + 2 + 3
--     = 6
 
-- (e) (\f -> \x -> f (f (f x))) (\x -> x * 2) 1
--     f = dobra
--     = dobra (dobra (dobra 1))
--     = dobra (dobra 2)
--     = dobra 4
--     = 8
 
-- (f) (\x -> (\y -> x - y) 3) 10
--     = (\y -> 10 - y) 3
--     = 10 - 3
--     = 7
 
-- (g) k (i 7) 100
--     = i 7            (k devolve o primeiro)
--     = 7
 
-- (h) i k 1 2
--     = k 1 2          (i devolve o próprio k)
--     = 1
 
-- (i) s k i "Teste"
--     = k "Teste" (i "Teste")
--     = "Teste"
 
-- (j) s (\x y -> x * y) (\x -> x + 1) 4
--     = (\x y -> x * y) 4 ((\x -> x + 1) 4)
--     = (\x y -> x * y) 4 5
--     = 4 * 5
--     = 20

-- 5. (2.5 pontos) Dê o tipo das expressões abaixo da maneira mais genérica
--    possível:
-- (a) \x y -> y                  :: a -> b -> b
-- (b) \x -> x                    :: a -> a
-- (c) 3.5                        :: Fractional a => a
-- (d) (True, 'a', "abc", [1,2])  :: Num a => (Bool, Char, String, [a])
-- (e) length                     :: [a] -> Int
--                                   (no GHC atual: Foldable t => t a -> Int)
-- (f) map not                    :: [Bool] -> [Bool]

-- 6. (2.5 pontos) Considere data () = () e complete:
--
--    g1 :: (a,b) -> (b,a,b)
--    g1 (a,b) = (b,a,b)_______________
--
--    g2 :: a -> b -> (b,(),a)
--    g2 _a b_ = _(b,(),a)
--
--    g3 :: Either a b -> Maybe b
--    g3 (left _)= Nothig
--    g3 (right b) = Just b
--
--    g4 :: (a -> b) -> (b -> c) -> a -> c
--    g4 f g x = g (f x)
--
--    g5 :: (a -> b) -> [a] -> [b]
--    g5 g = map g