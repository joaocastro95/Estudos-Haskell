module Projeto where

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