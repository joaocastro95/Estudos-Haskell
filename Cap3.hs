module Cap3 where

-- DATA para criar novos tipos de dados
-- | significa "ou" e é usado para definir diferentes construtores de dados para o tipo Dia. Cada construtor representa um dia da semana.

data Dia = Domingo | Segunda | Terca | Quarta | Quinta | Sexta | Sabado  deriving (Show,Eq,Ord,Enum)

-- Podemos	agora	criar	funções	com	o	novo	tipo	criado:
agenda :: Dia -> String
agenda Domingo = "TV..."
agenda Sabado = "Festa"
agenda _ = "Trabalho"

-- Vamos	analisar,	no	exemplo	a	seguir,	o	tipo		(Int,Int)	,	que	é
-- uma	 tupla	 com	 um	 inteiro	 em	 cada	 uma	 das	 duas	 coordenadas.
-- Serão	listadas	algumas	combinações	válidas	deste	 tipo,	na	entrada de	uma	função qualquer f:
f:: (Int,Int) -> Int
f (0,0) = 0
f (0,1) = 1
f (1,0) = 1
f (x,0) = x
f (0,y) = y
f (x,y) = x + y

--Todos os casos dão o mesmo resultado que x + y: por exemplo, (7,0) dá 7, que é 7+0.
-- g	::	(Int,	Int)	->	Int
-- g	(7,7)	=	7
-- g	_	=	0

h :: [Int] -> Int
h [] = 0
h (_:[]) = 1
h (_:x:[]) = 2+x
h (x:y:z:[]) = 3+x+y+z
h (x:_:_:w:[]) = 4+x+w
h (x:xs) = x



--CAMPO DE UM CONSTRUTOR
-- Todo	value	constructor	pode	possuir	campos.
data Pessoa = Fisica String Int | Juridica String

-- Aula3>	:t	Fisica
-- Fisica	::	String	->	Int	->	Pessoa
-- Aula3>	:t	Juridica
-- Juridica	::	String	->	Pessoa

teste :: Pessoa -> (String, String)
teste (Fisica x y) = ("Nome: " ++ x, "Idade: " ++ show y)
teste (Juridica x) = ("Nome: " ++ x, "Não há idade")

newtype Dado = Dado Int
data Dado1 = Dado1 Int


-- RECORD SYNTAX
-- O	seu	uso	é	simples.	Apenas	daremos	nomes	aos	campos	que
-- os	values	construtors	carregam	e	só.	Fazendo	isso,	já	estaremos
-- usando	este	conceito.	Por	exemplo,	o	tipo		Ponto	,	que	pode	ser
-- definido	como:

-- data	Ponto	=	Ponto	Double	Double

-- Pode	ser	escrito	assim:

data Ponto = Ponto {xval,yval :: Double}

-- A	vantagem	é	a	semântica	de	os	campos	terem	nomes.	E	cada
-- nome	dado	também	pode	ser	usado	como	função	de	projeção	de
-- valores	(algo	parecido	com	o		getter		da	programação	orientada	a
-- objetos).	Podemos	inspecionar	o	tipo	das	funções	de	projeção
-- xval		e		yval		no	GHCi.
-- Prelude>	:t	xval
-- xval	::	Ponto	->	Double	
-- Prelude>	:t	yval
-- yval	::	Ponto	->	Double

-- Aula3>	Ponto	1.1	2	
-- Ponto	{xval	=	1.1,	yval	=	2.0}

distOrig :: Ponto -> Double
distOrig (Ponto x y) = sqrt(x**2 + y**2)

distOrig2 :: Ponto -> Double
distOrig2 (Ponto {xval=x, yval=y}) = sqrt(x**2 + y**2)

distOrig3 :: Ponto -> Double
distOrig3 p = sqrt(xval p**2 + yval p**2)

-- deriving Show significa: "compilador, crie sozinho o jeito de transformar esse 
-- tipo em texto". Sem ele, o Haskell não sabe exibir seu tipo na tela.

-- Sem deriving Show:

-- haskell
-- data Cor = Vermelho | Azul

-- ghci> Vermelho
-- -- erro: No instance for (Show Cor)

-- Com deriving Show:

-- haskell
-- data Cor = Vermelho | Azul deriving Show

-- ghci> Vermelho
-- Vermelho

-- data Aluno = Aluno
--   { nome  :: String
--   , idade :: Int
-- --   , nota  :: Double
-- --   } deriving Show

-- ghci> Aluno "João" 30 9.5
-- Aluno {nome = "João", idade = 30, nota = 9.5}

-- ghci> [Aluno "Ana" 20 8.0, Aluno "Pedro" 22 7.5]
-- [Aluno {nome = "Ana", idade = 20, nota = 8.0},Aluno {nome = "Pedro", idade = 22, nota = 7.5}]

-- ghci> show (Aluno "Ana" 20 8.0)
-- "Aluno {nome = \"Ana\", idade = 20, nota = 8.0}"

-- Quando você cria um tipo novo com data, o Haskell não cria o show para ele 
-- automaticamente. Ele não assume nada: você precisa dizer explicitamente o que
--o tipo sabe fazer.

-- Então:

-- Sem deriving Show: o tipo Aluno não tem show → o GHCi não consegue exibir → erro.
-- Com deriving Show: o compilador gera o show para Aluno → o GHCi consegue exibir.

-- O mesmo vale para outras capacidades: sem deriving Eq, você também não consegue 
-- comparar dois Aluno com ==.



-- DURANTE A AULA

-- o Aluno se comporta "como construtor"
-- em haskell chamamos de value constructor
data Aluno = Aluno String String Int Curso deriving  (Show,Eq,Ord)

data Curso = ADS | SI | RH | CD | GE | GP deriving (Show, Eq, Ord, Enum)

-- record syntax: Da nome aos campos, estes nomes sao funcoes de projecao (tipo um getter tlgd)
data Discente = Discente {nome :: String, ra :: String, idade :: Int, curso :: Curso} deriving (Show,Eq,Ord)

fazerAniversarioD :: Discente -> Discente
fazerAniversarioD d = Discente {
    nome    = nome d,     -- d.nome
    ra      = ra d,       -- d.ra
    idade   = idade d + 1,
    curso   = curso d
}

fazerAniversario :: Aluno -> Aluno
fazerAniversario (Aluno nome ra idade curso) = Aluno nome ra (idade + 1) curso



-- MINIPROJETO:	RH	DE	UMA	EMPRESA	DE	TI



--EXERCICIOS

-- 3.1) Crie o tipo Pergunta com os value constructors Sim ou Nao. Faça as funções seguintes, determinando seus tipos explicitamente.
-- pergNum: recebe via parâmetro uma Pergunta. Retorna 0 para Nao e 1 para Sim.
-- listPergs: recebe via parâmetro uma lista de Perguntas e retorna 0s e 1s correspondentes aos constructores contidos na lista.
-- and': recebe duas Perguntas como parâmetro e retorna a tabela verdade do and lógico, usando Sim como verdadeiro e Nao como falso.
-- or': idem ao anterior, porém deve ser usado o ou lógico.
-- not': idem aos anteriores, porém usando o not lógico.

data Pergunta = Sim | Nao deriving (Show, Eq)

pergNum :: Pergunta -> Int
pergNum Sim = 1
pergNum Nao = 0

listPergs :: [Pergunta] -> [Int]
listPergs ps = [pergNum p | p <- ps]

and' :: Pergunta -> Pergunta -> Pergunta
and' Sim Sim = Sim
and' _ _ = Nao

or' :: Pergunta -> Pergunta -> Pergunta
or' Nao Nao = Nao
or' _ _ = Sim

not' :: Pergunta -> Pergunta
not' Sim = Nao
not' Nao = Sim

-- 3.2) Faça o tipo Temperatura, que pode ter valores Celsius, Fahrenheit ou Kelvin. Implemente as funções:

-- converterCelsius: recebe um valor Double e uma Temperatura e faz a conversão para Celsius.
-- converterKelvin: recebe um valor Double e uma Temperatura e faz a conversão para Kelvin.
-- converterFahrenheit: recebe um valor Double e uma Temperatura e faz a conversão para Fahrenheit.

data Temperatura = Celsius | Fahrenheit | Kelvin deriving (Show, Eq)

converterCelsius :: Double -> Temperatura -> Double
converterCelsius temp Celsius = temp
converterCelsius temp Fahrenheit = (temp - 32) * 5 / 9
converterCelsius temp Kelvin = temp - 273.15

converterKelvin :: Double -> Temperatura -> Double
converterKelvin temp Celsius = temp + 273.15
converterKelvin temp Fahrenheit = (temp - 32) * 5 / 9 + 273.15
converterKelvin temp Kelvin = temp

converterFahrenheit :: Double -> Temperatura -> Double
converterFahrenheit temp Celsius = (temp * 9 / 5) + 32
converterFahrenheit temp Fahrenheit = temp
converterFahrenheit temp Kelvin = (temp - 273.15) * 9 / 5 + 32

-- 3.3) Implemente uma função que simule o vencedor de uma partida de pedra, papel e tesoura usando tipos criados. Casos de empate devem ser considerados em seu tipo.
data Jogada = Pedra | Papel | Tesoura deriving (Show, Eq)
data Vencedor = Empate | Jogador1 | Jogador2 deriving (Show, Eq)
jogar :: Jogada -> Jogada -> Vencedor
jogar a b | a == b = Empate
jogar Pedra   Tesoura = Jogador1
jogar Tesoura Papel   = Jogador1
jogar Papel   Pedra   = Jogador1
jogar _       _       = Jogador2

-- 3.4) Faça uma função que retorne uma String com todas as vogais maiúsculas e minúsculas eliminadas de uma String passada por parâmetro, usando list comprehension.
semVogais :: String -> String
semVogais s = [c | c <- s, c `notElem` "aeiouAEIOU"]


-- 3.5) Sabe-se que as unidades imperiais de comprimento podem ser Inch, Yard ou Foot (há outras ignoradas aqui). Sabe-se que 1 in = 0.0254 m, 1 yd = 0.9144 m e 1 ft = 0.3048 m.
-- converterMetros: recebe a unidade imperial e o valor correspondente nessa unidade. Deve retornar o valor em metros.
-- converterImperial: recebe um valor em metros e a unidade de conversão. Deve retornar o valor convertido para a unidade desejada.

data Unidade = Inch | Yard | Foot deriving (Show, Eq)

converterMetros :: Unidade -> Double -> Double
converterMetros Inch value = value * 0.0254
converterMetros Yard value = value * 0.9144
converterMetros Foot value = value * 0.3048

converterImperial :: Double -> Unidade -> Double
converterImperial value Inch = value / 0.0254
converterImperial value Yard = value / 0.9144
converterImperial value Foot = value / 0.3048

-- 3.6) Faça um novo tipo chamado Mes, que possui como valores todos os meses do ano. Implemente:

-- checaFim: retorna o número de dias que cada mês possui (considere fevereiro com 28 dias).
-- prox: recebe um mês atual e retorna o próximo mês.
-- estacao: retorna a estação do ano de acordo com o mês e o hemisfério. Use apenas tipos criados pela palavra data aqui.

data Mes = Janeiro | Fevereiro | Marco | Abril | Maio | Junho | Julho | Agosto | Setembro | Outubro | Novembro | Dezembro deriving (Show, Eq, Enum)
data Hemisferio = Norte | Sul deriving (Show, Eq)
data Estacao = Primavera | Verao | Outono | Inverno deriving Show

checaFim :: Mes -> Int
checaFim Fevereiro = 28
checaFim m
  | m `elem` [Abril, Junho, Setembro, Novembro] = 30
  | otherwise                                     = 31

prox :: Mes -> Mes
prox Dezembro = Janeiro
prox m = succ m

estacao :: Mes -> Hemisferio -> Estacao
estacao m Sul
  | m `elem` [Dezembro, Janeiro, Fevereiro] = Verao
  | m `elem` [Marco, Abril, Maio] = Outono
  | m `elem` [Junho, Julho, Agosto] = Inverno
  | otherwise                = Primavera
estacao m Norte = oposta (estacao m Sul)
 
oposta :: Estacao -> Estacao
oposta Verao     = Inverno
oposta Inverno   = Verao
oposta Outono    = Primavera
oposta Primavera = Outono

-- 3.7) Faça uma função que receba uma String e retorne True se ela for um palíndromo; caso contrário, False.

isPalindromo :: String -> Bool
isPalindromo s = s == reverse s


-- 3.8) Faça uma função que elimine todos os números pares, todos os ímpares múltiplos de 7 e os negativos de uma lista de inteiros passada via parâmetro. Retorne essa lista em ordem reversa em comparação à do parâmetro.

filtrar :: [Int] -> [Int]
filtrar xs = reverse [x | x <- xs, x > 0, odd x, x `mod` 7 /= 0]


-- 3.9) Faça uma função que recebe três Strings x, y e z como parâmetro. A função retorna uma tupla com três coordenadas contendo a ordem reversa de cada uma. A primeira coordenada deve conter a string reversa do primeiro parâmetro, e assim por diante.

reversas :: String -> String -> String -> (String, String, String)
reversas x y z = (reverse x, reverse y, reverse z)


-- 3.10) Faça uma função chamada revNum, que receba um Int n e uma String s (nessa ordem). Ela deve retornar as n primeiras letras em ordem reversa e o restante em sua ordem normal.
-- haskell
-- revNum 4 "FATEC" = "ETAFC"
revNum :: Int -> String -> String
revNum n s = reverse (take n s) ++ drop n s

-- 3.11) Crie o tipo de dado Binario, que pode ser Zero ou Um. Faça outro tipo chamado Funcao, que pode ser Soma2, Maior, Menor ou Mult2. Implemente a função aplicar, que recebe uma Funcao e dois Binarios, e retorna o resultado da operação desejada.
-- haskell
-- aplicar Soma2 Um Um = Zero
data Binario = Zero | Um deriving (Show, Eq)
data Funcao = Soma2 | Maior | Menor | Mult2 deriving (Show, Eq)

aplicar :: Funcao -> Binario -> Binario -> Binario
aplicar Soma2 Um Um = Zero
aplicar Soma2 Um Zero = Um
aplicar Soma2 Zero Um = Um
aplicar Soma2 Zero Zero = Zero
aplicar Maior Um _ = Um
aplicar Maior _ Um = Um
aplicar Maior Zero Zero = Zero
aplicar Menor Zero _ = Zero
aplicar Menor _ Zero = Zero
aplicar Menor Um Um = Um
aplicar Mult2 Um Um = Um
aplicar Mult2 _ _ = Zero

-- 3.12) Faça uma função chamada binList, usando list comprehension, que recebe uma lista de Binarios (ver exercício anterior) e retorna outra lista com cada elemento somado a Um e convertido para Int.
-- haskell
-- binList [Um, Zero, Zero, Um, Zero] = [0,1,1,0,1]

binToInt :: Binario -> Int
binToInt Zero = 0
binToInt Um   = 1

binList :: [Binario] -> [Int]
binList bs = [binToInt (aplicar Soma2 b Um) | b <- bs]

-- 3.13) Faça um novo tipo chamado Metros, que possui um value constructor de mesmo nome cujos parâmetros são: Int, que representa a dimensão, e Double, que representa o valor da medida; e outro value constructor chamado MetragemInvalida. Implemente as funções:
-- areaQuadrado :: Metros -> Metros: calcula a área de um quadrado.
-- areaRet :: Metros -> Metros -> Metros: calcula a área de um retângulo.
-- areaCubo :: Metros -> Metros: calcula a área de um cubo.
-- haskell
-- Prelude> areaQuadrado (Metros 1 2.0)
-- Metros 2 4.0

-- Use pattern matching para ignorar metragens erradas (calcular a área de um quadrado com dimensão 4 não é válido).

data Metros = Metros Int Double | MetragemInvalida deriving (Show, Eq)

areaQuadrado :: Metros -> Metros
areaQuadrado (Metros 1 l) = Metros 2 (l * l)
areaQuadrado _            = MetragemInvalida

areaRet :: Metros -> Metros -> Metros
areaRet (Metros 1 l) (Metros 1 w) = Metros 2 (l * w)
areaRet _ _ = MetragemInvalida

areaCubo :: Metros -> Metros
areaCubo (Metros 1 l) = Metros 3 (l * l * l)
areaCubo _ = MetragemInvalida

-- 3.14) Faça o novo tipo Valido, que possui dois value constructors, Sim e Nao. O value constructor Sim possui um parâmetro (campo) String. Implemente a função isNomeValido, que recebe um nome e retorna Nao caso a String seja vazia; caso contrário, Sim.

data Valido = Sim2 String | Nao2 deriving (Show, Eq)

isNomeValido :: String -> Valido
isNomeValido "" = Nao2
isNomeValido nome = Sim2 nome

-- 3.15) Refaça o exercício 3 do capítulo anterior usando record syntax e tipos com parâmetro (siga o exemplo da conversão de medidas SI para imperial).

-- 3.16) Faça o tipo Numero, que possui um value constructor Ok com um campo Double e outro value constructor Erro com um campo String. Faça a função dividir, que divide dois números e, caso o segundo seja 0, emite um erro (use pattern matching).
-- haskell
-- Prelude> dividir (Numero 6) (Numero 5)
-- Numero 1.2

data Numero = OK Double | Erro String deriving (Show, Eq)

dividir :: Numero -> Numero -> Numero
dividir (OK _) (OK 0) = Erro "Divisão por zero"
dividir (OK x) (OK y) = OK (x / y)

-- 3.17) Faça o tipo Cripto, que possua dois value constructors, Mensagem e Cifrado, ambos com um campo String, e um value constructor Erro. Faça as funções encriptar e decriptar, seguindo os exemplos:
-- haskell
-- Prelude> encriptar (Mensagem "FATEC")
-- Cifrado "GBUFD"

data Cripto = Mensagem String | Cifrado String | Erro2 deriving (Show, Eq)

encriptar :: Cripto -> Cripto
encriptar (Mensagem s) = Cifrado [succ c | c <- s]
encriptar _            = Erro2

decriptar :: Cripto -> Cripto
decriptar (Cifrado s) = Mensagem [pred c | c <- s]
decriptar _            = Erro2

-- Prelude> decriptar (Cifrado "DBTB")
-- Mensagem "CASA"

-- A encriptação deve empurrar cada letra uma posição à frente, e a decriptação faz o inverso, empurrando uma letra para trás. Use as funções succ e pred e também list comprehensions. Não é possível encriptar mensagens cifradas nem decriptar mensagens.

-- 3.18) Faça uma função encriptarTodos, que encripta (ou dá erro) todos os elementos de uma lista de Cripto.


encriptarTodos :: [Cripto] -> [Cripto]
encriptarTodos cs = [encriptar c | c <- cs]

-- 3.19) Tendo como base o exercício de conversão de medidas, crie uma função que faça conversão de câmbio. Crie o tipo Cambio, contendo os value constructors Euro, Real e Dollar. Crie também o tipo Moeda, que possui os campos val :: Double e cur :: Cambio. Use record syntax e as taxas de conversão do dia em que você fizer o exercício.
data Cambio = Euro | Real | Dollar deriving (Show, Eq)
 
data Moeda = Moeda { val :: Double, cur :: Cambio } deriving Show
 
-- quantos reais vale 1 unidade de cada moeda
taxa :: Cambio -> Double
taxa Real   = 1.0
taxa Dollar = 5.30
taxa Euro   = 6.20
 
converter :: Moeda -> Cambio -> Moeda
converter m destino = Moeda (val m * taxa (cur m) / taxa destino) destino

-- 3.20) Crie a função converterTodosReal, que recebe uma lista de moedas e retorna outra lista com todos os elementos convertidos para Real. Use list comprehension.

-- 3.21) Crie a função maxMoeda, que recebe uma lista de moedas e retorna o valor máximo absoluto (sem conversão alguma) entre os campos val dessa lista. Use a função maximum.

-- haskell
-- Prelude> maxMoeda [Moeda 3 Real, Moeda 7 Dollar, Moeda 1 Euro]
-- 7