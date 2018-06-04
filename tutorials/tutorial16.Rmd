## Apresentação do problema

Na primeira atividade da oficina não precisamos lidar com o conteúdo e a estrutura da página que estávamos capturando. Como o conteúdo que nos interessava estava em uma tabela, e o pacote _rvest_ contém uma função específica para extração de tabelas, gastamos poucas linhas de código para ter a informação capturada já organizada em um data frame.

O que fazer, entretanto, com páginas que não têm tabelas? Como obter apenas as informações que nos interessam quando o conteúdo está "espalhado" pela página? Utilizaremos, como veremos abaixo, a estrutura do código HTML da própria página para selecionar apenas o que desejamos e construir data frames.

Nosso objetivo nessa atividade será capturar uma única página usando a estrutura do código HTML da página. Já sabemos que, uma vez resolvida a captura de uma página, podemos usar "loop" para capturar quantas quisermos, desde que tenha uma estrutura semelhante.

Antes disso, porém, precisamos falar um pouco sobre XML e HTML.

## XML e HTML

XML significa "Extensive Markup Language". Ou seja, é uma linguagem -- e, portanto, tem sintaxe -- e é uma linguagem com marcação. Marcação, neste caso, significa que todo o conteúdo de um documento XML está dentro de "marcas", também conhecidas como "tags". É uma linguagem extremamente útil para transporte de dados -- por exemplo, a Câmara dos Deputados utiliza XML em seu Web Service para disponibilizar dados abertos (mas você não precisa saber disso se quiser usar o pacote de R bRasilLegis que nós desenvolvemos ;) -- disponível aqui: https://github.com/leobarone/bRasilLegis.

Por exemplo, se quisermos organizar a informação sobre um indivíduo que assumiu diversos postos públicos, poderíamos organizar a informação da seguinte maneira:

```{xml}
<politicos>
  <politico>
    <id> 33333 </id>
    <nome> Fulano Deputado da Silva </nome>
    <data_nascimento> 3/3/66 </data_nascimento>
    <sexo> Masculino </sexo>
    <cargos>
      <cargo> 
        <cargo> prefeito </cargo> 
        <partido> PAN </partido>
        <ano_ini> 2005 </ano_ini>
        <ano_fim> 2008 </ano_fim>
      </cargo>
      <cargo> 
        <cargo> deputado federal </cargo> 
        <partido> PAN </partido>
        <ano_ini> 2003 </ano_ini>
        <ano_fim> 2004 </ano_fim>
       </cargo>
       <cargo> 
        <cargo> deputado estadual </cargo> 
        <partido> PAN </partido>
        <ano_ini> 1998 </ano_ini>
        <ano_fim> 2002 </ano_fim>
       </cargo>
      </cargos>
  </politicos>
</politicos>
```

Exercício (difícil): se tivessemos que representar estes dados em um banco de dados (data frame), como seria? Quantas linhas teria? Quantas colunas teria?

Veja no link abaixo um exemplo de arquivo XML proveniente do Web Service da Câmara dos Deputados:

http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDetalhesDeputado?ideCadastro=141428&numLegislatura=

Abra agora a página inicial da [Folha de São Paulo](http://www.folha.uol.com.br/). Posicione o mouse em qualquer elemento da página e, com o botão direito, selecione "Inspecionar" (varia de navegador para navegador, mas recomendo utilizar o Chrome para esta tarefa a despeito da superioridade do Firefox, rs). Você verá o código HTML da página.

Sem precisar observar muito, é fácil identificar que o código HTML da ALESP se assemelha ao nosso breve exemplo de arquivo XML. Não por acaso: HTML é um tipo de XML. Em outra palavras, toda página de internet está em um formato de dados conhecido e, como veremos a seguir, pode ser re-organizado facilmente.

## Tags, nodes, atributos, valores e conteúdo na linguagem XML

Todas as informações em um documento XML estão dispostas em "tags" (id, nome, etc são as tags do nosso exemplo). Um documento XML é um conjunto de "tags" com hierarquia. Um conjunto de "tags" hierarquicamente organizado é chamado de "node". Por exemplo, no arquivo XML da Câmara dos Deputados apresentado acima, cada tag político contêm diversos outras "tags" e formam "nodes", ou seja, pedaços do arquivo XML.

Em geral, as "tags" vÊm em pares: uma de abertura e outra de fechamento. O que as diferencia é a barra invertida presente na tag de fechamento. Entre as "tags" de abertura e fechamento vemos o conteúdo da tag, que pode, inclusive, ser outras "tags". Veja os exemplos abaixo:

```{xml}
<minha_tag> Este é o conteúdo da tag </minha_tag>

<tag_pai>
  <tag_filha>
  </tag_filha>
</tag_pai>

<tag_pai> Conteúdo da tag Pai
  <tag_filha> Conteúdo da tag Filha
  </tag_filha>
</tag_pai>
```

Identação (espaços) nos ajudam a ver a hierarquia entre as tags, mas não é obrigatória. Também as quebras de linha são opcionais.

Além do conteúdo e do nome da tag, é extremamente comum encontrarmos "atributos" nas tags em bancos de dados e, sobretudo, em códigos HTML. Atributos ajudam a especificar a tag, ou seja, identificam qual é o seu uso ou carregam quaisquer outras informações referentes. Voltando ao exemplo fictício acima, poderíamos transformar a informação do cargo, que hoje é uma tag cargo dentro de outra tag cargo (horrível, não?) em atributo.

Em vez de:

```{xml}
<politicos>
  <politico>
    <id> 33333 </id>
    <nome> Fulano Deputado da Silva </nome>
    <data_nascimento> 3/3/66 </data_nascimento>
    <sexo> Masculino </sexo>
    <cargos>
      <cargo> 
        <cargo> prefeito </cargo> 
        <partido> PAN </partido>
        <ano_ini> 2005 </ano_ini>
        <ano_fim> 2008 </ano_fim>
      </cargo>
      <cargo> 
        <cargo> deputado federal </cargo> 
        <partido> PAN </partido>
        <ano_ini> 2003 </ano_ini>
        <ano_fim> 2004 </ano_fim>
       </cargo>
       <cargo> 
        <cargo> deputado estadual </cargo> 
        <partido> PRONA </partido>
        <ano_ini> 1998 </ano_ini>
        <ano_fim> 2002 </ano_fim>
       </cargo>
      </cargos>
  </politicos>
</politicos>
```

Teríamos:

```{xml}
<politicos>
  <politico>
    <id> 33333 </id>
    <nome> Fulano Deputado da Silva </nome>
    <data_nascimento> 3/3/66 </data_nascimento>
    <sexo> Masculino </sexo>
    <cargos>
      <cargo tipo = 'prefeito'>
        <partido> PAN </partido>
        <ano_ini> 2005 </ano_ini>
        <ano_fim> 2008 </ano_fim>
      </cargo>
      <cargo tipo = 'deputado federal'>
        <partido> PAN </partido>
        <ano_ini> 2003 </ano_ini>
        <ano_fim> 2004 </ano_fim>
       </cargo>
      <cargo tipo = 'deputado estadual'>
        <partido> PRONA </partido>
        <ano_ini> 1998 </ano_ini>
        <ano_fim> 2002 </ano_fim>
       </cargo>
      </cargos>
  </politicos>
</politicos>
```

Veja que agora a tag "cargo" tem um atributo -- "tipo" -- cujos valores são "prefeito", "deputado federal" ou "deputado estadual". Estranho, não? Para bancos de dados em formato XML, faz menos sentido o uso de atributos. Mas para páginas de internet, atributos são essenciais. Por exemplo, sempre que encontrarmos um hyperlink em uma página, contido sempre nas tags de nome "a", veremos apenas o "texto clicável" (conteúdo), pois o hyperlink estará, na verdade, no atributo "href".  Veja o exemplo

```{html}
<a href="http://acervo.folha.com.br/?cmpid=menupe">Acervo Folha</a>
```

Tente, no próprio site da [Folha de São Paulo](http://www.folha.uol.com.br/), clicar com o botão direito em um hyperlink qualquer para observar algo semelhante ao exemplo acima. Adiante vamos ver como atributos são extremamente úteis ao nosso propósito.

## Caminhos no XML e no HTML

O fato de haver hierarquia nos códigos XML e HTML nos permite construir "caminhos", como se fossem caminhos de pastas em um computador, dentro do código.

Por exemplo, o caminho das "tags" que contém a informação "nome" em nosso exemplo fictício é:

```{xml}
/politicos/politico/nome 
```

O caminho das "tags" que contém a informação "partido" em nosso exemplo fictício, por sua vez, é: 

```{xml}
/politicos/politico/cargos/cargo/partido
```

Seguindo tal caminho chegamos às três "tags" que contém a informação desejada.

Simples, não? Mas há um problema: o que fazer quando chegamos a 3 informações diferentes (o indivíuo em nosso exemplo foi eleito duas vezes pelo PAN e uma pelo PRONA)? Há duas alternativa: a primeira, ficamos com as 3 informações armazenadas em um vetor, pois as 3 informações interessam. Isso ocorrerá com frequência.

Mas se quisermos apenas uma das informações, por exemplo, a de quando o indivíduo foi eleito deputado estadual? Podemos usar os atributos e os valores dos atributos das tag para construir o caminho. Neste caso, teríamos como caminho: 

```{xml}
/politicos/politico/cargos/cargo[@tipo = 'deputado estadual']/partido
```

Guarde bem este exemplo: ele será nosso modelo quando tentarmos capturar páginas.

Vamos supor que queremos poupar nosso trabalho e sabemos que as únicas "tags" com nome "partido" no nosso documento são aquelas que nos interessam (isso nunca é verdade em um documento HTML). Podemos simplicar nosso caminho de forma a identificar "todas as 'tags' '', não importa em qual nível hierarquíco do documento". Neste caso, basta usar duas barras:

```{xml}
//partido
```

Ou "todas as tags 'partido' que sejam descendentes de 'politico', não importa em qual nível hierarquíco do documento": 

```{xml}
/politicos/politico//partido
```

Ou ainda "todas as tags 'partido' que sejam descendentes de quaisquer tag 'politico', não importa em qual nível hierarquíco do documento para qualquer uma das duas": 

```{xml}
//politico//partido
```

Ou "todas as 'tags' filhas de qualquer 'tag' 'cargo'" (usa-se um asterisco para indicar 'todas'):

```{xml}
//cargo/*
```

Observe o potencial dos "caminhos" para a captura de dados: podemos localizar em qualquer documento XML ou HTML uma informação usando a própria estrutura do documento. Não precisamos organizar o documento todo, basta extrair cirurgicamente o que queremos -- o que é a regra na raspagem de páginas de internet.

## Links na página de busca da Folha de São Paulo

Vamos entrar na página principal da [Folha de São Paulo](http://www.folha.uol.com.br/) e fazer uma pesquisa simples na caixa de busca -- exatamente como faríamos em um jornal ou qualquer outro portal de internet (o processo seria o mesmo em buscadores como Google ou DuckDuckGo). Por exemplo, vamos pesquisar a palavra "merenda". A ferramenta de busca nos retorna uma lista de links que nos encaminharia para diversos documentos ou páginas da ALESP relacionadas ao termo buscado.

Nosso objetivo é construir um vetor com os links dos resultados. Em qualquer página de internet, links estão dentro da tag "a". Uma maneira equivocada de encontrar todos os links da página usando "caminhos em XML" seria:

```{html}
//a
```

Entretanto, há diversos outros elementos "clicáveis" na página além dos links que nos interessam -- por exemplo, as barras laterais, o banner com os logotipos, os links do mapa do portal, etc. Precisamos, portanto, especificar bem o "caminho" para que obtivéssemos apenas os links que nos interessam.

Infelizmente não temos tempo para aprender aprofundadamente HTML, mas podemos usar lógica e intuição para obter caminhos unívocos. Neste exemplo, todos as "tags" "a" que nos interessam são filhas de alguma tag "div", que por sua vez é filha de outra "div", esta filha de "li" (que é abreviação de "list" e indica um único elemento de uma lista). Podemos melhorar nosso caminho:

```{html}
//li/div/div/a
```

A tag li, por sua vez, é filha da tag "ol" ("ordered list"), ou seja, é a tag que dá início à lista não ordenada formada pelos elementos "li". Novamente, melhoramos nosso caminho:

```{html}
//ol/li/div/div//a
```

E se houver mais de uma "ordered list" na página? Observe que essa tag "ul" tem atributos: class="search-results-title". Bem específico, não?

Alguns atributos têm "função" para o usuário da página -- por exemplo, as tags "a" contém o atributo "href", que é o link do elemento "clicável". Mas, em geral, em uma página de internet os atributos não fazem nada além de identificar as tags para @ programador@. Diversos programas para construção de páginas criam atributos automaticamente. Por exemplo, se vocë fizer um blog em uma ferramenta qualquer de construção de blogs, sua página terá tags com atributos que você sequer escolheu.

As tags mais comum em páginas HTML são: head, body, div, p, a, table, tbody, td, ul, ol, li, etc. Os atributos mais comuns são: class, id, href (para links), src (para imagens), etc. Em qualquer tutorial básico de HTML você aprenderá sobre elas. Novamente, não precisamos aprender nada sobre HTML e suas tags. Apenas precisamos compreender sua estrutura e saber navegar nela.

Voltando ao nosso exemplo, se usarmos o atributo para especificar o "caminho" para os links teremos:

```{html}
//ol[@class='u-list-unstyled c-search'/li/div/div/a
```

Pegou o espírito? Vamos agora dar o nome correto a este "caminho": xPath.

Vamos agora voltar ao R e aprender a usar os caminhos para criar objetos no R.

## Capturar uma página e examinar sua estrutura

O primeiro passo na captura de uma página de internet é criar um objeto que contenha o código HTML da página. Para tanto, usamos a função _read\_html_  do pacote _rvest_, que utilizamos na aula anterior. Vamos usar a segunda página da busca pela palavra "merenda" na [Folha de São Paulo](http://www.folha.uol.com.br/) como exemplo:

```{r}
library(rvest)
url <- "http://search.folha.uol.com.br/search?q=merenda&site=todos&results_count=3769&search_time=0.033&url=http%3A%2F%2Fsearch.folha.uol.com.br%2Fsearch%3Fq%3Dmerenda%26site%3Dtodos&sr=26"
pagina <- read_html(url)
```

Note que a estrutura do endereço URL é relativamente simples: "q" é o primeiro parâmetro e informa o texto buscado. "site=todos", informa que a busca é feita em todas as páginas do grupo Folha/UOL. "results_count", é o total de resultados e "search_time" o tempo que demorou para realização da busca. "url" é o próprio endereço. E, muito importante, "sr" é o número do primeiro resultado da página, que, no caso da Folha, pula de 25 em 25. Nesta atividade vamos capturar apenas a página 2, mas você já aprendeu na atividade anterior como capturar todas as páginas usando loops.

```{r}
class(pagina)
```

Observe (usando a função "class") que o objeto "pagina" que contém o HTML da página em análise pertence às classes "xml_document" e "xml_node". Ou seja, o R sabe que este objeto é um XML e, portanto, é capaz de identificar a estrutura do documento -- tags, atributos, valores e conteúdos. 
Para páginas em HTML, usaremos a função "htmlParse":

## Extraindo os conteúdos de uma página com a biblioteca _rvest_

Vamos agora aprender a "navegar" um objeto XML dentro do R e extrair dele apenas as informações que nos interessam. Estas informações podem estar no conteúdo das tags ("text") ou nos atributos ("attr").

Voltando ao nosso exemplo da busca na Folha de São Paulo, vamos obter os títulos e os links das notícias, cujo caminho construímos acima. Já temos o conteúdo da página capturado no objeto "pagina".

Em primeiro lugar, com o caminho do título e a função _html\_nodes_, extraímos os "nodes" com as "tags" que nos interessam:

Obs: como o título está dentro de uma tag "h2" dentro da tag "a", adicionamos o h2 no final do caminho.

```{r}
nodes_titulos <- html_nodes(pagina, xpath = "//ol/li/div/div/a")
```

Use a função "print" para observar o que capturamos.

Agora, tendo apenas os "nodes" que nos interessam por conter os títulos das notícias (e seus elementos clicáveis), usamos a função _html\_text_ para extrair os títulos:

```{r}
titulos <- html_text(nodes_titulos)
View(titulos)
```

E a função _html\_attr_ para extrair os atributos "href", que contêm os títulos das notícias:

```{r}
links <- html_attr(nodes_titulos, name = "href")
```

Note que uma "tag" pode conter mais de um atributo e por isso usamos o argumento "name" da função _html\_attr_ para especificar qual atributo queremos.

Veja que as funções _html\_text_ e _html\_attr_ cumprem a mesma tarefa da função _html\_table_: retirar de um objeto XML (que é uma página capturada) as informações que nos interessam.

O resultado de ambas funções é um vetor com todos os títulos e links das notícias, respectivamente. Podemos colocar os vetores lado a lado (verticalmente) e criar um data_frame que contém duas variáveis, título e link da notícia:

```{r}
tabela_titulos <- data.frame(titulos, links)
```

Use a função _View_ para visualizar os dados capturados.

O desafio a partir de agora é conectar o que aprendemos da raspagem de dados de várias páginas com "for loop", mas usando a função _html\_table_, com as novas funções de raspagem de páginas que extraem com precisão o que conteúdo que nos interessa. Esta será nossa próxima atividade.
