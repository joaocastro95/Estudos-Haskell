module ProjetoParsers where

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
             "\", orçamento: \"" ++ show (budget p) ++
             "\", envolvidos: " ++ show (envolvidos p) ++ "}"

instance Semigroup Projeto where
  (Projeto nome1 budget1 env1) <> (Projeto nome2 budget2 env2) =
    Projeto (nome1 ++ ", " ++ nome2) (budget1 + budget2) (env1 ++ env2)

instance Monoid Projeto where
  mempty = Projeto "" 0 []