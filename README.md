# Estudos Haskell

Repositório com anotações, exemplos e exercícios feitos durante meus estudos de Haskell.

## Conteúdo

| Arquivo | Descrição |
|---|---|
| [`Aula1.hs`](Aula1.hs) | Primeiras anotações do curso |
| [`Cap2.hs`](Cap2.hs) | Funções, listas, compreensões de lista, tuplas e exercícios resolvidos |
| [`Cap3.hs`](Cap3.hs) | Tipos de dados com `data`, pattern matching em tuplas e listas |
| [`Diferenca.py`](Diferenca.py) | Comparação entre programação imperativa/funcional (Python) e notas sobre segurança de tipos em Haskell/Yesod |

## Tópicos abordados

- Declaração de funções e assinaturas de tipo
- Operações com listas (`++`, `head`, `tail`, `reverse`, `!!`, cons `:`, `length`)
- Compreensões de listas (list comprehensions)
- Tuplas
- Tipos de dados personalizados (`data`)
- Pattern matching
- Imutabilidade, funções puras e funções de ordem superior
- Diferença entre erros em tempo de compilação e em tempo de execução

## Como executar

Com o [GHC](https://www.haskell.org/ghc/) instalado, carregue um arquivo no GHCi:

```bash
ghci Cap2.hs
```

E use `:r` para recarregar após alterações ou `:t` para consultar o tipo de uma expressão.
