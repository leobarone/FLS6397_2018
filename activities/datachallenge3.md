#  FLS 6397 - Introdução à Programação e Ferramentas Computacionais para as Ciências Sociais

- Responsável: Leonardo S. Barone e Jonathan Phillips

## Desafio 3

## Instruções para Entrega

Data: 01/06

Formato: arquivo .pdf ou .html produzido com RMarkdown, acompanhado de script em formato .R

Via: e-mail com título "[FLS6397] - D3".

## Instruções para a atividade

Siga as instruções abaixo. Faça no arquivo de RMarkdown uma síntese de sua atividade e apresente apenas o essencial do código (você deve julgar o que é essencial).

Documente __TODOS__ os seus passos no arquivo de script. Comente no seu script __TODOS__ os seus passos e explique a si mesm@ suas escolhas e estratégias.

As primeiras linhas do seu script devem conter suas informações pessoais como comentário, tal qual o modelo abaixo:

```{r}
### nome <- "Fulano da Silva Sauro"
### programa <- "Mestrado em Paleontologia"
### n_usp <- 32165498
### data_entrega: "29/02/2017"
```

### Parte 1 - Combinando fontes de dados diferentes

Construa um data.frame único com as seguintes características: as observações (linhas) devem ser municípios e as colunas características dos municípios.

Você deve construir esse data frame combinando pelo menos 3 das seguintes fontes:

- [Perfil dos Municípios Brasileiros 2015](http://www.ibge.gov.br/home/estatistica/economia/perfilmunic/2015/default.shtm) - Bases de dados em .xls no menu do lado esquerdo
- [Informações Financeiras e Fiscais dos Municípios](https://siconfi.tesouro.gov.br/siconfi/pages/public/consulta_finbra/finbra_list.jsf)
- [Estatísticas sobre óbitos - DATASUS](http://tabnet.datasus.gov.br/cgi/deftohtm.exe?sim/cnv/pobt10br.def)
- [CEPESPData](http://cepesp.io) (usando o pacote _cepespr_)
- Outra fonte de sua escolha, desde que devidamente indicada no documento.

Quem tiver dificuldades com a obtenção/abertura de algumas das bases de dados, pode utilizar as cópias armazenadas no repositório do curso: [MUNIC15](https://raw.githubusercontent.com/leobarone/FLS6397/master/data/Base_MUNIC_2015_xls.zip), [DATASUS](https://raw.githubusercontent.com/leobarone/FLS6397/master/data/obitos_datasus.csv) e [FINBRA](https://raw.githubusercontent.com/leobarone/FLS6397/master/data/receitas_orc_finbra.zip)

Lembre-se que as bases devem ser combinadas utilizando o código de município. Algumas fontes podem conter códigos com 6 ou 7 dígitos e você deve ignorar o 7o dígito se isso ocorrer. Para tranformar um código de 7 dígitos em um de 6 dígitos faça:

```{r setup, include=FALSE}
cod_ibge6 <- as.numeric(substr(cod_ibge7, 1, 6))
```

Escolha as variáveis de seu interesse em cada fonte e mantenha apenas estas no data frame.

Sugestão: use _inner\_join_ para fazer as combinações de bases para ficar apenas com os casos completos em todas as variáveis de seu interesse. Não esqueça, porém, de notar que alguns casos serão perdidos.

### Parte 2 - Análise exploratória e gráfica dos dados

Utilizando os tutoriais de sala de aula sobre _ggplot2_ e os capítulos [Cap 3. Visualização de dados](http://r4ds.had.co.nz/data-visualisation.html) e [Cap 7. Análise exploratória de dados](http://r4ds.had.co.nz/exploratory-data-analysis.html), faça uma apresentação criativa dos dados e explore relações entre variáveis das diversas fontes. Considere, para facilitar seu processo criativo, visualizar variáveis e relações entre elas para os quais você consegue formular explicações ou hipóteses.

Sua apresentação deve conter pelo menos: 1 gráfico para uma variável contínua; 1 gráfico para uma variável discreta; 1 gráfico para duas variáveis, sendo uma discreta e uma contínua; e 1 gráfico para duas variáveis contínuas.

Em todos os gráficos, insira título e rótulos dos eixos. Quando necessário, inclua legenda. Altere os elementos da geometria (cor, tamanho, formato, etc de linhas, pontos e barras) para tornar as visualizações o mais elegange possível. Explique brevemente - em duas ou três frases - o que podemos aprender a partir de cada gráfico.

Finalmente, seu arquivo de RMarkdown deve conter pelo menos 3 informações provenientes dos dados (exemplo: contagem de casos, médias de variáveis, somatórios) no meio dos parágrafos (_"inline code"_).
