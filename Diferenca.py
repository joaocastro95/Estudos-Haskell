##IMUTABILIDADE
# Imperativo: altera a lista original
nums = [1, 2, 3]
nums.append(4)

# Funcional: cria uma nova lista
nums = (1, 2, 3)
novos = nums + (4,)   # nums continua (1, 2, 3)



##DECLARATIVO VS IMPERATIVO
precos = [10, 25, 40]

# Imperativo: você descreve o passo a passo
dobro = []
for p in precos:
    dobro.append(p * 2)

# Declarativo: você diz o que quer
dobro = list(map(lambda p: p * 2, precos))



##FUNCOES PURAS (SEM EFEITOS COLATERAIS)
total = 0
def soma_impura(x):     # mexe em algo fora dela
    global total
    total += x

def soma_pura(a, b):    # mesma entrada → sempre mesma saída
    return a + b





##FUNCOES COMO VALORES (E FUNCOES DE ORDEM SUPERIOR)
def aplicar(f, x):          # recebe função como parâmetro
    return f(x)

def multiplicador(n):       # retorna uma função
    return lambda x: x * n

triplo = multiplicador(3)
aplicar(triplo, 5)          # 15



# Tempo de compilação vs. tempo de execução

# Compilação: quando o compilador traduz seu código para algo que o computador roda, antes do programa funcionar. Erros aqui impedem o programa de ser gerado.
# Execução: quando o programa já está rodando e sendo usado. Erros aqui aparecem para o usuário.

# Uma analogia: a compilação é o corretor revisando a redação antes de entregar; a execução é o professor lendo a redação já entregue. É melhor pegar o erro na revisão.

# Exemplo de link quebrado

# Em um site comum, a URL é só um texto:

# html
# <a href="/produtoss">Ver produtos</a>   <!-- erro de digitação -->

# O programa compila normalmente. O erro só aparece quando alguém clica e recebe 404, ou seja, em tempo de execução.

# No Yesod, as rotas são declaradas uma vez e viram tipos do Haskell:

# haskell
# /produtos  ProdutosR  GET

# No template, o link usa esse tipo, não um texto solto:

# haskell
# <a href=@{ProdutosR}>Ver produtos

# Se você escrever @{ProdutossR}, o compilador recusa, porque essa rota não existe. O erro é pego antes de o site ir ao ar. Isso é a segurança de tipos nas URLs (type-safety).

# O resto do texto, resumido

# Yesod, Scotty, Happstack, Snap: frameworks web em Haskell. O texto foca no Yesod.
# REST: suporte para criar APIs.
# i18n: suporte a vários idiomas.
# Persistência: salvar dados em banco, também com checagem de tipos.
# Shakespearean templates: mini-linguagens (DSLs) para montar páginas:
# Hamlet para HTML
# Lucius/Cassius para CSS
# Julius para JavaScript
# Elas também são verificadas na compilação.

# A conclusão do texto: Haskell deixou de ser só acadêmico e já dá para usar em aplicações reais em produção.