---
title: 'Tutorial 1'
output: 
  html_document:
    number_sections: true
---

```{r setup, include=F}
knitr::opts_chunk$set(echo = TRUE, eval=F, include=T)
```

# Começando pelo meio: data frames

Uma característica distintiva da linguagem de programação R é ter sido desenvolvida para a análise de dados. E quando pensamos em análise de dados, a protagonista do show é a _base de dados_ ou, como vamos conhecer a partir de agora, __data frame__.

Por esta razão, em vez de aprender como fazer aritmética, elaborar funções ou executar loops para repetir tarefas e outros aspectos básicos da linguagem, vamos começar olhando para o R como um software concorrente dos demais utilizados para análise de dados em ciências sociais, como SPSS, Stata, SAS e companhia.

As principais características de um data frame são: (1) cada coluna representa uma variável (ou característica) de um conjunto de observações; (2) cada linha representa uma observação e contém os valores de cada variável para tal observação. Vejamos um exemplo:

| Candidato | Partido | Votos | 
| --------- |:-------:| -----:|
| Beatriz   | PMDB    |   350 | 
| Danilo    | SOL     |  1598 | 
| Pedro     | PTB     |   784 | 
| Davi      | PSD     |   580 | 
| Mateus    | PV      |   2   | 

Note que em uma linha os elementos são de tipos de diferentes: na primeira coluna há uma nome (texto), na segunda uma sigla de partido (texto, mas limitado a um conjunto de siglas) e na terceira votos (número inteiros). 

Por outro lado, em cada coluna há somente elementos de um tipo. Por exemplo, há apenas números inteiros na coluna votos. Colunas são variáveis e por isso aceitam registros de um único tipo. Se você já fez um curso de estatísticas básica ou de métodos quantitativos deve se lembrar que as variáveis são classificadas da seguinte maneira:

1- Discretas

  - Nominais, que são categorias (normalmente texto) não ordenadas
  
  - Ordinais, que são categorias (normalmente texto) ordenadas
  
  - Inteiros, ou seja, o conjunto dos números inteiros

2- Contínuas, números que podem assumir valores não inteiros

Se destacamos uma coluna do nosso data frame, temos um __vetor__. Por exemplo, a variável "Votos" pode ser presentado da seguinte maneira: {350, 1598, 784, 580, 2}. Um data frame é um conjunto de variáveis (vetores) dispostos na vertical e combinados um ao lado do outro.

Data frame e vetores são __objetos__ na linguagem R.

Vamos ver como o R representa vetores e data frames na tela. Antes disso, é preciso "abrir" um data frame.

## Pausa para pacotes

Uma das características mais atrativas da linguagem R é o desenvolvimento de __pacotes__ pela comunidade de usuários. Pacotes são conjuntos de funções (aka comandos) e, por vezes, guardam também dados em diversos formatos.

Vamos carregar um pacote chamado _datasets_, que contém diversos conjuntos de dados úteis para fins didáticos. Para tornar as funções disponíveis para uso naquela sessão de R usamos a função _library_:

```{r}
library(datasets)
```

## De volta aos dataframes

Com a função _data_ podemos abrir um conjunto de dados disponível num pacote de R. Utilizaremos a base _mtcars_, que contém dados da revista _Motor Trend US_ sobre características (variáveis) de 32 automóveis (esse é um dos conjuntos de dados mais populares em cursos introdutórios de R).

```{r}
data(mtcars)
```

Pronto! Logo mais veremos como abrir conjuntos de dados de outras fontes (arquivos de texto, outros softwares, etc), mas já podemos começar a trabalhar com _data frames_.

Antes de avançar, vamos usar o __help__ (documentação) do R para descobrir o que há no _data frame_ chamado _mtcars_:

```{r}
?mtcars
```

Você pode ler com calma antes de avançar.

Se quiseremos olhar para os dados que acabamos de carregar podemos digitar apenas o nome do banco de dados e ele aparece na janela interativa. 

```{r}
mtcars
```

Contudo, muitas vezes é mais útil ver o _data frame_ em sua própria janela. Na aba _Environment_ (que provavelmente está no canto direito superior da sua tela) você pode ver todos os _objetos_ que você já criou/abriu e clicar para abrir numa janela separada. (Se não aparecer, você pode ter que executar o código 'mtcars' uma vez para inicializar os dados).

Com apenas 32 observações, não fica tão difícil "olhar" para os dados. Mas e se estívessemos trabalhando com, por exemplo, o total de candidatos vereadores no Brasil em 2016 (aprox. meio milhão de candidatos)? 

## Do editor de planilhas ao R

A partir desse ponto no curso vamos resistir à tentação de "olhar" para os dados. O hábito de quem trabalha com editores de planilha como MS Excel ou Libre Office, ou ainda com alguns softwares de análise de dados como SPSS e Minitab, é trabalhar "olhando" para os dados, ou seja, para os valores de cada célula de uma base dados.

Você perceberá em pouco tempo que isso não é necessário. Na verdade, é contraproducente. Em breve vamos nos munir de ferramentas que nos permitirão conhecer os dados sem olhá-los diretamente.

## Entendendo seus dados

Por exemplo, podemos substituir a vista da planilha pela função _head_. Veja o resultado:

```{r}
head(mtcars)
```

Com apenas as 6 primeiras linhas do _data frame_ temos noção de todo o conjunto. Sabemos rapidamente que os nomes dos carros são o nome de cada uma das linhas, e que o nome das colunas indicam qual característica está armazenada coluna (lembre-se da documentação de _mtcars_ que você acabou de ler).

Alternativamente, podemos usar a função _str_ (abreviação de "structure"):

```{r}
str(mtcars)
```

Com _str_ sabemos qual é a lista de variáveis (colunas) no _data frame_, de qual tipo são -- no caso, todas são numéricas e vamos falar sobre esse tema mais tarde -- e os primeiros valores de cada uma, além do número total de observações e variáveis mostrados no topo do __output__.

Há outras maneiras de obter o número de linhas e colunas de um _data frame_:

```{r}
nrow(mtcars)
ncol(mtcars)
dim(mtcars)
```

_nrow_ retorna o número de linhas; _ncol_, o de coluna; _dim_ as dimensões (na ordem linha e depois coluna) do objeto.

_names_, por sua vez, retorna os nomes das variáveis do _data frame_

```{r}
names(mtcars)
```

## Argumentos ou parâmetros das funções

Note que em todas as funções que utilizamos até agora, _mtcars_ está dentro do parênteses que segue o nome da função. Essa __sintaxe__ é característica das funções de R. O que vai entre parêntesis são os __argumentos__ ou __parâmetros__ da função, ou seja, os "inputs" que serão transformados.

Uma função pode receber mais de um argumento. Pode também haver argumentos não obrigatórios, ou seja, para os quais não é necessário informar nada se você não quiser alterar os valores pré-definidos. Por exemplo, a função _head_ contém o argumento _n_, que se refere ao número de linhas a serem __impressas__ na tela, pré-estabelecido em 6 (você pode conhecer os argumentos da função na documentação do R usando _?_ antes do nome da função). Para alterar o parâmetro _n_ para 10, por exemplo, basta fazer:

```{r}
head(x = mtcars, n = 10)
```

_x_ é o argumento que já havíamos utilizado anteriormente e indica em que objeto a função _head_ será aplicada. Dica: você pode omitir tanto "x =" quanto "n =" se você já conhecer a ordem de cada argumento no uso da função. Veja que neste caso estamos utilizando o símbolo "=" sem fazer a atribuição de dados a um objeto, mas para atribuir valores (ou objetos) aos argumento de uma função. Para não haver confusão é preferível usar o símbolo "<-" para atribuição e o "=" para as demais situações. Voltaremos adiante a essa discussão.

## Pausa para um comentário

Podemos fazer comentários no meio do código. Basta usar # e tudo que seguir até o final da linha não será interpertado pelo R como código. Por exemplo:

```{r}
# Imprime o nome das variaveis do data frame mtcars
names(mtcars)

names(mtcars) # Repetindo o comando acima com comentario em outro lugar
```

Comentários são extremamente úteis para documentar seu código. Documentar é parte de programar e você deve pensar nas pessoas com as quais vai compartilhar o código e no fato de que com certeza não se lembrará do que fez em pouco tempo (garanto, você vai esquecer).

# Construindo vetores e data frames

Vamos esquecer o _data frame_ com o qual estávamos trabalhando até agora. Para remover um objeto do nosso __Environment__ fazemos:

```{r}
rm(mtcars)
```

Vamos seguir este tutorial de forma menos entediante. Vamos montar um banco de dados de notícias.

Escolha 2 jornais ou portais de notícias diferentes. Vá em cada um deles e colete 2 notícias quaisquer. Em casa notícia, colete as seguintes informações:

- Nome do jornal ou portal (pode abreviar)
- Data da notícia (não precisa coletar a hora)
- Título
- Autor(a)
- Número de palavras no texto (use o MS Word ou Libre Office se precisar - chute se tiver preguiça, mas não perca tempo contando)
- Marque 1 se a notícia for sobre política e 0 caso contrário
- Marque TRUE se a notícia contiver vídeo e FALSE caso contrário

Insira as informações nos vetores em ordem de coleta das notícias.

Com cada informação, vamos construir um vetor. Vejam meus exemplos. Começando com o nome do jornal ou portal:

```{r}
jornal <- c("The Guardian",
            "The Guardian",
            "Folha de São Paulo", 
            "Folha de São Paulo")
```

Opa, calma! Temos um monte de coisas novas aqui!

A primeira delas é: se você criou corretamente o vetor _jornal_, então nada aconteceu na sua tela, ou seja, nenhum output foi impresso. Isso se deve ao fato de que criamos um novo __objeto__, chamado _jornal_ e __atribuímos__ a ele os valores coletados sobre os nomes dos veículos nos quais coletamos as notícias. O símbolo de __atribuição__ em R é __<-__. Note que o símbolo lembra uma seta para a esquerda, indicando que o conteúdo do vetor será armazenado no objeto _jornal_.

Objetos não são nada mais do que um nome usado para armazenar dados na memória RAM (temporária) do seu computador. No exemplo acima, _jornal_ é o objeto e o vetor é a informação armazenada. Uma vez criado, o objeto está disponível para ser usado novamente, pois ele ficará disponível no __environment__. Veremos adiante que podemos criar um _data frame_ a partir de vários vetores armazenados na memória. Especificamente no RStudio, os objetos ficam disponíveis no painel _environment_ (que provavelmente está no canto direito superior da sua tela).

Posso usar o símbolo __=__ no lugar de __<-__? Sim. Funciona. Mas nem sempre funciona e esta substituição é uma fonte grande de confusão. Quando entendermos um pouco mais da sintaxe da linguagem R ficará claro. Por enquanto, quando for atribuir dados para um objeto, use __<-__.

Se o objetivo fosse criar o vetor sem "guardá-lo" em um objeto, bastaria repetir a parte do código acima que começa após o símbolo de atribuição. _c_ ( do inglês "concatenate") é a função do R que combina valores de texto, número ou lógicos (ainda não falamos destes últimos) em um vetor. É um função muito utilizada ao programar em R.

```{r}
c("The Guardian",
  "The Guardian",
  "Folha de São Paulo",
  "Folha de São Paulo")
```

Note que há umas quebras de linha no código. Não há problema algum. Uma vez que o parêntese que indica o fim do vetor não foi encontrado, o R entende o que estiver na próxima como continuidade do código (e, portanto, do vetor). Dica: quebras de linha ajudam a vizualizar o código, sobretudo depois de uma vírgula, e com o tempo você também usará.

Vamos seguir com nossa tarefa de criar vetores. Já temos o vetor jornal (que você pode observar no Environment). Os demais, na minha coleta de dados, estão a seguir:

```{r}
# Data
# Obs: ha uma funcao em R com nome "data" - Evite dar a objetos nome de funcoes existentes
data_noticia <- c("10/03/2017",
                  "10/03/2017",
                  "10/03/2017",
                  "10/03/2017")

# Titulo
titulo <- c("'Trump lies all the time': Bernie Sanders indicts president's assault on democracy",
            "BBC interviewee interrupted by his children live on air – video",
            "Bolsista negra é hostilizada em atividade no campus da FGV de SP",
            "Meninas podem ser o que quiserem, inclusive matemáticas")

# Autor
autor <- c("Ed Pilkington ",
           NA,
           "Joana Cunha; Jairo Marques",
           "Marcelo Viana")

# Numero de caracteres
n_caracteres <- c(5873, 207, 1358, 3644)

# Conteudo sobre politica
politica <- c(1, 0, 0, 0)

# Contem video
video <- c(TRUE, TRUE, FALSE, FALSE)
```

Para onde vão os objetos de R criados? Para o Environment. Se quisermos uma fotografia do nosso Environment, usamos a função _ls_, com parêntese vazio (ou seja, sem argumentos além dos pré-estabelecidos):

```{r}
ls()
```

## Detalhes importantes nos vetores acima

Mais alguns detalhes importantes a serem notados no exemplo acima:

- O formato da data foi arbitrariamente escolhido. Por enquanto, o R entende apenas como texto o que foi inserido. Datas são especialmente chatas de se trabalhar e há funções específicas para tanto.
- Os textos foram inseridos entre aspas. Os números, não. Se números forem inseridos com aspas o R os entenderá como texto também.
- Além de textos e números, temos no vetor _vídeo_ valores lógicos, TRUE e FALSE. _logical_ é um tipo de dado do R (e é particularmente importante).
- O texto do primeiro título que coletei contém aspas. Como colocar aspas dentro de aspas sem fazer confusão? Se você delimitou o texto com aspas duplas, use aspas simples no texto e vice-versa.
- O que são os _NA_ no meio do vetor _autor_? Quando coletei as notícias, não consegui identificar o autor(a) de algumas (eram notícias da redação). _NA_ é o símbolo do R para __missing values__ e lidar com eles é uma das partes mais importantes da análise de dados.

## Criando um data frame com vetores:

Como vimos acima, _data frames_ são um conjunto de vetores na vertical. Se você introduziu os valores em cada vetor na ordem correta de coleta dos dados, então eles podem ser __pareados__ e __combinados__. No meu exemplo, a primeira posição de cada vetor contém as informações sobre a primeira notícia, a segunda posição sobre a segunda notícia e assim por diante. 

Obviamente, se estiverem pareados, os vetores devem ter o mesmo comprimento. Há uma função bastante útil para checar o comprimento:

```{r}
length(jornal)
```
Vamos criar com os vetores que construímos um _data frame_ com o nome _dados_. Vamos produzí-lo, discutir a função _data.frame_ e depois examiná-lo:

```{r}
dados <- data.frame(jornal,
                    data_noticia,
                    titulo,
                    autor,
                    n_caracteres,
                    politica,
                    video)
```

A função _data.frame_ cria um _data frame_ a partir de vetores ou matrizes (que ainda não vimos). Quando criamos a partir de vetores, automaticamente os nomes das variáveis (colunas) no novo objeto serão os nomes dos vetores. Mas poderíamos querer nomes novos (por exemplo, em inglês). Bastaria fazer:

```{r}
dados <- data.frame(newspaper = jornal, 
                    date = data_noticia, 
                    title = titulo, 
                    author = autor, 
                    n_char = n_caracteres, 
                    politics = politica,
                    video)
```

Usando as funções que aprendemos nessa aula:

```{r}
# 6 primeiras (e unicas, no caso) linhas
head(dados)

# Estrutura do data frame
str(dados)

# Nome das variaveis (colunas)
names(dados)

# Dimensoes do data frame
dim(dados)
```

# Tipos de dados em R e vetores

Usando o que aprendemos sobre vetores, vamos examinar com cuidado os tipos de dados que podem ser armazenados em vetores:
__doubles__, __integers__, __characters__, __logicals__, __complex__, e __raw__. Neste tutorial, vamos examinar os 3 mais comumente usados na análise de dados: _doubles_, _characters_, _logicals_.

## Doubles

_doubles_ são utilizados para guardar números. Por exemplo, o vetor _n\_caracteres_, que indica o número de caracteres em cada texto, é do tipo _double_. Vamos repetir o comando que cria este vetor:

```{r}
n_caracteres <- c(5873, 6301, 358, 3644, 4086, 3454)
```

Com a função _typeof_ você consegue descobrir o tipo de cada vetor:

```{r}
typeof(n_caracteres)
```

É possível fazer operações com vetores númericos ( _integers_ também são vetores numéricos, mas vamos esquecer deles por um segundo e fazer _double_ sinônimo de numérico). Por exemplo, podemos somar 1 a todos os seus elementos, dobrar o valor de cada elemento ou somar todos:

```{r}
n_caracteres + 1
n_caracteres * 2
sum(n_caracteres)
```

Note que as duas primeiras funções retornam vetores de tamanho igual ao original, enquanto a aplicação da função _sum_ a um vetor retorna apenas um número, ou melhor, um __vetor atômico__ (que contém um único elemento). Tal como aplicamos as operações matemáticas e a função _sum_, podemos aplicar diversas outras operações matemáticas e funções que descrevem de forma sintética os dados (média, desvio padrão, etc) a vetores numéricos. Veremos operações e funções com calma num futuro breve.

## Logicals

O vetor _politica_ também são do tipo _double_. Mesmo registrando apenas a presença e ausência de uma característica, os valores inseridos são números. Mas o vetor _video_? Vejamos:

```{r}
typeof(politica)
typeof(video)
```

Em vez de armazenarmos a sim/não, presença/ausência, etc com os números 0 e 1, podemos em R usar o tipo _logical_, cujos valores são TRUE e FALSE (ou T e F maiúsculos, para poupar tempo e dígitos). Diversas operações e resultados no R usam vetores lógicos (por exemplo, "filtrar uma base dados") e os utilizaremos com frequência.

O que acontece se fizermos operações matemáticas com vetores lógicos?

```{r}
video + 1
sum(video)
```
Automaticamente, o R transforma FALSE em 0 e TRUE em 1. Por exemplo, ao somar 2 FALSE e 2 TRUE obtemos o valor 2, que é o total de notícias que contêm vídeos.

## Character

Finalmente, vetores que contêm texto são do tipo _character_. O nome dos jornais, data, título e autor são informações que foram inseridas como texto (lembre-se, o R não sabe por enquanto que no vetor _data\_noticia_ há uma data). Operações matemáticas não valem pare estes vetores.

## Tipo e classe

Veremos em momento oportuno que os objetos em R também tem um atributo denominado __class__. A classe diz respeito às características dos objetos enquanto tipo diz respeito ao tipo de dado armazenado. No futuro ignoraremos o tipo e daremos mais atenção à classe, mas é sempre bom saber distinguir os tipos de dados que podemos inserir na memória do computador usando R.

# Abrindo dados de fontes externas

R é uma linguagem extremamente flexível quanto ao formato de dados que podem ser importados. Comumente, utilizaremos dados provenientes de arquivos de texto (.txt, .csv, .tab, etc). Mas estas estão longe de serem as únicas possibilidades.

Com o pacote _haven_ abriremos arquivos produzidos por outros softwares -- como Stata e SPSS. Podemos também conectar o R a sistemas de gerenciamento de bancos de dados relacionais (SGBD), como o SQL Server. Finalmente, podemos receber via web arquivos em formato XML ou Json e transformá-los em _data frames_ em poucos passos.

Vamos começar com o exemplo simples. Baixe os dados com resultados eleitorais (votação nominal por município e zona) do Acre em 2014 disponíveis [aqui](https://raw.githubusercontent.com/leobarone/FLS6397/master/data/votacao_candidato_munzona_2014_AC.txt) (clique em "Save link as" e faça o download ou vá [aqui](https://github.com/leobarone/FLS6397/blob/master/data/votacao_candidato_munzona_2014_AC.txt) e clique em download). Estes dados são provenientes do [Repositório de Dados Eleitorais](http://www.tse.jus.br/eleicoes/estatisticas/repositorio-de-dados-eleitorais) do TSE. O Tribunal disponibiliza para cada ano eleitoral arquivos por UF em formato de texto (.txt) e numa pasta comprimida em formato .zip.

Obs: se você tiver algum problema com o download, encoding, ou outro, pode ir direto ao Repositório e fazer o download de lá.

Para abrir o arquivo de dados podemos usar a função _read.table_ e alguns argumentos. Em primeiro lugar, digitamos o 'path' do nosso arquivo - você deve ajustar isso dependendo de onde você salvou o arquivo de dados eleitorais no seu computador. Note que Windows e R tem uma dificuldade relacionados as barras nos endereços. Tente usar / (uma barra) ou \\ (duas barras invertidas) no lugar de uma barra invertida.

Em segundo lugar, nós especificamos o caractere que separa cada coluna no arquivo .txt, um ponto-e-vírgula neste caso (além deste, vírgula e tab são separadores bastante encontrados em arquivos de texto). Em terceiro lugar, o _fileEncoding_ identifica qual forma de codificar bites em texto e números, foi usado ao salvar o arquivo, neste caso _latin1_ (conforme documentado pelo TSE). Este argumento é particularmente importante para evitar bagunça de caracteres quando trocamos arquivos entre diferentes sistemas operacionais -- IOS, Linux e Windows).

```{r}
votacao_candidato_munzona_2014_AC <- read.table(
  "~/FLS6397/data/votacao_candidato_munzona_2014_AC.txt", 
  sep = ";",
  fileEncoding="latin1")

```

Agora você encontrará o objeto _votacao\_candidato\_munzona\_2014\_AC_ na aba _Environment_.

Diferentemente de outros softwares, no R a "interface Windows", aka "menus e janelas", não oferece a possibilidade executar funções. Porém, na aba _Environment_ há um botão muito útil chamado "Import Dataset", que serve para importar para o _Enivronment_ arquivos em qualquer formato de texto ("From CSV"), MS Excel, Stata, SAS e SPSS. No curso, vamos evitar usar o botão para que possamos documentar e replicar facilmente nossa análise de dados.

Um detalhe importante: agora temos dois _data frames_ (_dados_ e _votacao\_candidato\_munzona\_2014\_AC_ ) em nosso _Environment_ convivendo com os vetores que criamos. Veja:

```{r}
ls()
```

Em outros softwares, como Stata e SPSS, costumamos trabalhar com um único objeto, que é o banco de dados. Apenas um _data frame_ por vez vai para a memória do software. No R, entretanto, temos um "espaço" no qual vários objetos coexistem.

Alguns outros argumentos da função _read.table_ a se notar: 
1. _header_, que recebe valores lógicos, indica se a primeira linha contém os nomes das variáveis (T) ou é a primeira linha dos dados (F);
2. _dec_ indica qual é o separador de decimais (ponto ou vírgula); 
3. _quote_, se os dados em cada "célula" estão contidos entre aspas; 
4. _stringsAsFactors_ indica se textos devem ser vistos como textos ou variáveis categóricas ( __factors__, que é uma classe de objetos que veremos em breve);  

# Breve exerício:

1. Quantas linhas e quantas colunas têm o data frame _votacao\_candidato\_munzona\_2014\_AC_? Use as funções que você aprendeu no tutorial.

2. Observe as 4 primeiras linhas do _data frame_ com o comando _head_ (só as 4 primeiras).

3. Use o comando _str_ para examinar o _data frame_.

## Cadê os nomes das variáveis?

Nem sempre teremos os nomes das variáveis na primeira linha do arquivo (e por isso podemos utilizar _header_ = F). Quando isso ocorre o R preenche automaticamente os nomes com V1, V2, ..., Vn, onde n é o total de colunas. Veja:

```{r}
names(votacao_candidato_munzona_2014_AC)
```

Onde obter os nomes das colunas? No caso do TSE, no arquivo LEIAME. Em geral, precisamos de um arquivo que acompanhe o arquivo de dados para compreender a base de dados. Ou teremos que advinhar.

No próximo tutorial aprenderemos a transformar o _data frame_ e alterar os nomes das variáveis.

## Colunas como vetores

Uma vez que importamos os dados, podemos trabalhar com as colunas do _data frame_ como se fossem vetores. Por exemplo, vamos tirar a média (com a função _mean_) da coluna V29, que é a coluna "votos" -- no caso, de cada candidato em cada zona eleitoral. Veja:

```{r, error=TRUE}
mean(V29)
```

Opa! O vetor V29 não foi encontrado! Isso ocorre porque V29 não é um __objeto__ no nosso _Environment_. Como podemos ter mais de um _data frame_, se houvesse mais de um _data frame_ com a variável com nome V29 haveria confusão. O vetor com o qual queremos trabalhar está dentro do objeto _votacao\_candidato\_munzona\_2014\_AC_. Indicamos sua localização colocando primeiro o nome do _data frame_, seguido do símbolo $ e depois do nome da coluna:

```{r, error=TRUE}
mean(votacao_candidato_munzona_2014_AC$V29)
```

## Exerício continuado:

4. Qual é o 'tipo' de colunas V1, V8, V15 e V23?

5. Qual é a média de colunas V8 e V23?

6. Qual é a __mediana__ de colunas V8 e V23?

## Paramos por aqui

Fizemos neste tutorial uma rápida introdução a vetores e _data frames_. Vamos agora dar inúmeros passos para trás e aprender os fundamentos da linguagem R. De um forma ou de outra, tenha certeza de que você já começou a se acostumar com a linguagem, sua sintaxe, léxico e peculiaridades.