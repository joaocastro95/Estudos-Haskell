# Estudos Haskell

Repositório com anotações, exemplos e exercícios feitos durante meus estudos de Haskell.

## Conteúdo

| Arquivo | Descrição |
|---|---|
| [`Aula1.hs`](Aula1.hs) | Primeiras anotações do curso |
| [`Cap2.hs`](Cap2.hs) | Funções, listas, compreensões de lista, tuplas e exercícios resolvidos |
| [`Cap3.hs`](Cap3.hs) | Tipos de dados com `data`, pattern matching em tuplas e listas |
| [`Cap4.hs`](Cap4.hs) | Lambdas, funções de alta ordem e currying |
| [`Cap5.hs`](Cap5.hs) | Tipos paramétricos, kinds, árvores, classes de tipos (`Eq`, `Show`), semigrupos e monoides |
| [`Cap7.hs`](Cap7.hs) | Funtores (`Functor`) e funtores aplicativos (`Applicative`) |
| [`Projeto.hs`](Projeto.hs) | Projeto do livro: `Pessoa`, `Projeto`, classe `ToJSON`, instâncias de `Semigroup`/`Monoid` |
| [`ProjetoParsers.hs`](ProjetoParsers.hs) | Continuação do projeto usando funtores e aplicativos |
| [`ex3aula.hs`](ex3aula.hs) | Exercício de aula: moedas, conversão e soma com `Maybe`/`Either` |
| [`Simulado1.hs`](Simulado1.hs) | Simulado resolvido: records, `Semigroup` (associatividade), `Functor`, kinds, cálculo lambda e inferência de tipos |
| [`Diferenca.py`](Diferenca.py) | Comparação entre programação imperativa/funcional (Python) e notas sobre segurança de tipos em Haskell/Yesod |

## Tópicos abordados

- Declaração de funções e assinaturas de tipo
- Operações com listas (`++`, `head`, `tail`, `reverse`, `!!`, cons `:`, `length`)
- Compreensões de listas (list comprehensions)
- Tuplas
- Tipos de dados personalizados (`data`)
- Pattern matching
- Lambdas, currying e funções de alta ordem
- Tipos paramétricos e kinds (`* -> *`)
- Classes de tipos e instâncias (`Eq`, `Show`, `Ord`, `Enum`)
- Semigrupos e monoides (e suas leis)
- Funtores e aplicativos (`fmap`, `pure`, `<*>`)
- `Maybe` e `Either` para tratamento de falhas
- Imutabilidade, funções puras e funções de ordem superior
- Diferença entre erros em tempo de compilação e em tempo de execução

## Como executar

Com o [GHC](https://www.haskell.org/ghc/) instalado, carregue um arquivo no GHCi:

```bash
ghci Cap2.hs
```

E use `:r` para recarregar após alterações ou `:t` para consultar o tipo de uma expressão.
