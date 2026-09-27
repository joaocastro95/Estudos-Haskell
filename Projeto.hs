module Projeto where

data Cargo = Estagiario | Programador | Coordenador | Gerente deriving Show

data Pessoa = Pessoa {cargo :: Cargo, nome :: String, idade :: Int} deriving Show

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

