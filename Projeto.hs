module Projeto where

import Data.Functor.Contravariant

data Cargo = Estagiario | Programador | Coordenador | Gerente deriving Show

data Pessoa = Pessoa {cargo :: Cargo, nome :: String, idade :: Int} deriving Show

infixl 1 |>
(|>) :: a -> (a -> b) -> b
x |> f = f x

verSalario :: Pessoa -> Double
verSalario (Pessoa Estagiario _ _) = 1500.00
verSalario (Pessoa Programador _ _) = 3000.00
verSalario (Pessoa Coordenador _ _) = 5000.00
verSalario (Pessoa Gerente _ _) = 8000.00

verFolha :: Pessoa -> String
verFolha p = "{nome: \"" ++ nome p ++
  "\", cargo: \"" ++ show (cargo p) ++
  "\", salario: " ++ show (verSalario p) ++ "}"

promover :: Pessoa -> Pessoa
promover (Pessoa Estagiario n i)  = Pessoa Programador n i
promover (Pessoa Programador n i) = Pessoa Coordenador n i
promover (Pessoa Coordenador n i) = Pessoa Gerente n i
promover (Pessoa _ n i)           = Pessoa Gerente n i

contratarInicial :: String -> Pessoa
contratarInicial n = Pessoa Estagiario n 18

mediaSalarial :: [Pessoa] -> Double
mediaSalarial ps = foldl calculo 0 ps / fromIntegral (length ps)
  where calculo salario pessoa = salario + verSalario pessoa

contratarVariosEstag :: [String] -> [Pessoa]
contratarVariosEstag ps = map contratarInicial ps

rotinaPromocao :: Pessoa -> String
rotinaPromocao p = p 
    |> promover
    |> verFolha

rotinaPromocao2 :: Pessoa -> String
rotinaPromocao2 p = verFolha . promover $ p


--Cap5

data Projeto = Projeto { nomeProjeto :: String
                       , budget      :: Double
                       , envolvidos  :: [Int]
                       } deriving Show

class ToJSON a where
  toJSON :: a -> String

instance ToJSON Pessoa where
  toJSON p = "{nome: \"" ++ nome p ++
             "\", cargo: \"" ++ show (cargo p) ++
             "\", salario: " ++ show (verSalario p) ++ "}"

instance ToJSON Projeto where
  toJSON p = "{nome: \"" ++ nomeProjeto p ++
             "\", orcamento: \"" ++ show (budget p) ++
             "\", envolvidos: " ++ show (envolvidos p) ++ "}"

instance Semigroup Projeto where
  (Projeto nome1 budget1 env1) <> (Projeto nome2 budget2 env2) =
    Projeto (nome1 ++ ", " ++ nome2) (budget1 + budget2) (env1 ++ env2)

instance Monoid Projeto where
  mempty = Projeto "" 0 []


--  data Projeto: um registro (record) com três campos nomeados. Cada nome de campo vira automaticamente uma função, ex. budget p devolve o orçamento de p.
-- class ToJSON: classe própria (não existe no Prelude) com uma função que converte um valor em texto no formato JSON.
-- instance ToJSON Pessoa / Projeto: montam a string concatenando pedaços com ++. O \" é uma aspa dentro da string. show converte números, listas etc. em texto.
-- instance Semigroup Projeto: define como juntar dois projetos: nomes separados por vírgula, orçamentos somados, listas de envolvidos concatenadas. Usa pattern matching para desmontar cada projeto nos seus campos.
-- instance Monoid Projeto: o elemento neutro é um projeto vazio (nome "", orçamento 0, ninguém envolvido). Juntar qualquer projeto com ele não muda nada... quase: o nome ganharia um ", " sobrando, detalhe que o livro não trata.

p1 = Projeto "Site" 1000 [1,2]
p2 = Projeto "App" 500 [3]

-- toJSON (p1 <> p2)
-- -- "{nome: \"Site, App\", orçamento: \"1500.0\", envolvidos: [1,2,3]}"

-- mconcat [p1, p2]

-- toJSON p1
-- putStrLn (toJSON (p1 <> p2))
-- mconcat [p1, p2]

-- joao = Pessoa Programador "Joao" 30
-- putStrLn (toJSON joao)
-- putStrLn (rotinaPromocao joao)

data Indice a = Indice { indice :: Int, dados :: a }

-- rotinas previamente implementadas

instance Functor Indice where
  fmap f (Indice i dados) = Indice i (f dados)

-- Com a instância de Functor, agora você consegue mexer no dado de dentro sem perder o índice. O fmap aplica a função só no campo dados; o indice passa intacto.

-- No seu arquivo, isso combina com as funções que você já tem. Por exemplo:

-- haskell
-- joao = Pessoa Programador "Joao" 30

-- fmap promover (Indice 1 joao)
-- -- Indice 1 (Pessoa Gerente... não: Coordenador "Joao" 30)

-- fmap verSalario (Indice 1 joao)
-- -- Indice 1 3000.0

-- fmap toJSON (Indice 7 p1)
-- -- Indice 7 "{nome: \"Site\", ...}"


-- 7.1) Faça uma instância de Functor para o tipo Coisa, definido no
--      início do capítulo 5. A função g deve "ir para dentro" em todas
--      as coordenadas de Coisa. No caso de ZeroCoisa, o fmap deve
--      retornar ZeroCoisa.

-- 7.2) Aproveitando o exercício anterior, faça uma instância de
--      Applicative Functor para o tipo Coisa.

-- 7.3) Crie a função mult234 :: Double -> Coisa Double que multiplica
--      por 2 a primeira coordenada, por 3 a segunda, e por 4 a terceira.
--      Use a instância de Applicative feita no exercício anterior.

-- 7.4) Escreva uma instância para Functor e Applicative para o tipo
--      Arvore, visto no capítulo 5.

-- 7.5) Escreva uma instância de Functor para o tipo
--      data Fantasma a = Fantasma

-- 7.6) Escreva uma possível instância de Functor para o tipo
--      data Dupla a = Dupla a Int a

-- 7.7) É possível criar uma instância de Functor para o tipo
--      Derp a = Derp {runDerp :: Bool -> a}? Justifique e, em caso
--      positivo, crie a instância de Functor e Applicative.

-- 7.8) (Opcional) Implemente:
--      * O tipo NovoPred possui um value constructor de mesmo nome,
--        contendo o campo runNovoPred de tipo Maybe a -> Bool;
--      * Crie uma instância de Functor Contravariante para o tipo NovoPred.