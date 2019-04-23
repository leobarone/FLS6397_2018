# Mapas em R

```{r, echo=F}
knitr::opts_chunk$set(echo = TRUE, eval=F)
```
# Antes de começar

Antes de iniciar o tutorial, certifique-se de que os pacotes _sf_, _devtools_, a versão de desenvolvedor _ggplot2_, _mapview_ e _ggmap_.

```{r, echo=F}
install.packages("sf")
install.packages("devtools")
devtools::install_github("tidyverse/ggplot2", force = T)
install.packages("mapview")
install.packages("ggmap")
devtools::install_github("Cepesp-Fgv/cepesp-r")
```

# Início

Dados espaciais são dados organizados por localização e permitem novos tipos de análise e visualização. Explorar mapas em R nos permite praticar e estender muitas das ferramentas que aprendemos nas últimas semanas - análises de dados com dplyr, joins e gráficos com ggplot2.

# Mapeando Pontos Geográficos

Vamos começar a trabalhar com mapas a partir de um exemplo que, veremos, utilizará as ferramentas que aprendemos até então para produzir nossos primeiros mapas. Para tanto, vamos utilizar o cadastro de escolas que a Prefeitura Municipal de São Paulo disponibiliza [aqui](http://dados.prefeitura.sp.gov.br/).

Nossa primeira tarefa é baixar os dados e faremos isso de forma inteligente e sem "cliques". A partir do url do arquivo do cadastro, que guardaremos no objeto "url\_cadatros\_escolas", faremos o download do arquivo e guardaremos o arquivo .csv baixado como o nome "temp.csv":
  
```{r}
url_cadatros_escolas <- "http://dados.prefeitura.sp.gov.br/dataset/8da55b0e-b385-4b54-9296-d0000014ddd5/resource/39db5031-7238-4139-bcaa-e620a3180188/download/escolasr34fev2017.csv"
download.file(url_cadatros_escolas, "temp.csv")
```

Vamos abrir o arquivo:
  
```{r}
library(readr)
escolas <- read_delim("temp.csv", delim = ";")
```

Explore o arquivo com o comando _glimpse_:
  
```{r}
library(dplyr)
glimpse(escolas)
```

Não há nada de extraordinário no arquivo, que se assemelha aos que vimos até então. Há, porém, uma dupla de variáveis que nos permite trabalhar "geograficamente" com os dados: LATITUDE e LONGITUDE. "Lat e Long" são a informação fundamental de um dos sistemas de coordenadas (coordinate reference system, CRS) mais utilizados para localização de objetos na superfície da terra.

Por uma razão desconhecida, a informação fornecida pela PMSP está em formato diferente do convencional. Latitudes são representadas por números entre -90 e 90, com 8 casas decimais, e Longitudes por números entre -180 e 180, também com 8 casas decimais. Em nosso par de variáveis, o separador de decimal está omitido e por esta razão faremos um pequena modificação na variável. Aproveitaremos também para renomear algumas variáveis de nosso interesse -- como tipo da escola (CEI, EMEI, EMEF, CEU, etc) e o ano de início do funcionamento::
  
```{r}
escolas <- escolas  %>%
  rename(lat = LATITUDE, lon = LONGITUDE, tipo = TIPOESC) %>% 
  mutate(lat = lat / 1000000, 
         lon = lon / 1000000,
         ano = as.numeric(substr(DT_INI_FUNC, 7, 10))) %>%
  filter(is.na(lat)==FALSE & is.na(lon)==FALSE)
```

Pronto! Temos agora uma informação geográfica das EMEFs e uma variável de interesse -- ano -- que utilizaremos para investigar a expansão da rede.

Para analisar estes dados como dados espaciais precisamos dizer a R quais são as variáveis de localização e transformá-lo em um objeto 'simple features' usando o biblioteca _sf_ e a função _st\_as\_sf_ para criar um objeto tipo "simple features". Lembre-se de instalar o pacote antes de carregá-lo.

```{r}
library(sf)
escolas <- escolas %>% st_as_sf(coords=c("lon","lat"), crs=4326)
```

O parâmetro 'coords' indica os colunas de latitude e longitude, e o 'crs' indica o sistema de coordenadas (a "projeção") que queremos usar. Na verdade, o sistema de coordenadas não é uma opção nossa - precisamos especificar o mesmo sistema de coordenadas com o qual os dados foram salvos. Às vezes isso é difícil de saber. Aqui, como o longitude e latitude parece que eles estão em graus (entre -180 e 180) é provável que devemos usar o sistema "WGS84" (um sistema de coordenadas geográficas (não projetadas)). Um 'shortcut' para especificar o WGS84 é usar o numero _4326_ no argumento 'crs'. Para outros shortcuts para sistemas de coordenados que pode usar com dados salvados em outros sistemas de coordenados, pode aproveitar do site [http://epsg.io/](http://epsg.io/). Não se preocupe muito com sistemas de coordenadas - vamos discuti-los mais em aula.

Qual tipo de objeto é `emef` agora?

```{r}
class(escolas)
```

Temos vários resultados aqui - é um objeto 'simple features', mas também um _tbl_ (tibble) e _data.frame_! Isso significa que podemos aplicar todas as funções do dplyr com dados espaciais também. Por exemplo, selecionaremos apenas as linhas referentes a EMEF (Escolas Municipal de Ensino Fundamental) usando _filter_ e as variáveis NOMESC e SITUACAO:

```{r}
emef <- escolas  %>%
  filter(tipo == "EMEF") %>%
  select(NOMESC,SITUACAO)
```

Vamos olhar em detalhe o conteúdo de nosso objeto:

```{r}
emef
```

Quando olhamos num objeto simple features, tem vários coisas importantes a observar:  
1. Na descrição imprimido em Rstudio, podemos ver 'geometry type: POINT' - isso significa que cada elemento espacial é um ponto único (também pode ser um polígono ou linha);  
2. O CRS (e o código epsg);  
3. O número de 'features' (unidades espaciais) e 'fields' (variáveis/colunas);  
4. No data.frame mesmo, temos duas colunas de NOMESC e SITUACAO, e uma terceira de 'geometry' - isso é uma coluna especial que contém as informações de localização para cada unidade. Aqui são as coordenadas dos nossos pontos.

## Visualisando mapas
Lembra que nossos gráficos em ggplot foram conectados diretamente com um data.frame? Como um objeto de 'simple features' __é__ um data.frame, podemos usar ggplot para criar mapas! Para fazer isso, precisamos instalar a versão de desenvolvimento do ggplot2 (se não tem o pacote _devtools_, pode precisa instalar):

```{r}
devtools::install_github("tidyverse/ggplot2")
library(ggplot2)
```

Para visualizar o nosso mapa, vamos usar uma camada de geometria especial (e espacial) se chama _geom\_sf_, e o formato dos parâmetros são os mais simples possíveis: branco!

```{r}
emef %>% ggplot() +
  geom_sf()
```

Já criou o seu primeiro mapa! O eixo _x_ é o longitude e o eixo _y_ é o latitude. Debaixo, vamos ver como a representar outros aspectos de nosso data.frame em mapas. Agora, tem um outro abordagem para criar um mapa interativo, com um mapa de terra no fundo. Usamos o pacote 'mapview' e, de novo, não precisamos especificar nenhum parâmetro.

```{r}
library(mapview)
emef %>% mapview()
```

### Exercício
Criar um mapa de escolas de tipo "EMEBS" (Escolas Municipais de Educação Bilíngue para Surdos). 

## Georeferencing 
Um outro fonte de dados espaciais é georeferenciar um endereço usando uma ferramenta de busca como o google maps, por exemplo com o pacote _ggmap_. 

Vamos agora criar um novo data frame a partir dos dados do cadastro da PMSP que contém apenas os CEUs. Vamos juntar todas as informações de endereço e agregar a elas o texto ", Sao Paulo, Brazil"

```{r}
ceu <- escolas  %>%
  filter(tipo == "CEU") %>%
  mutate(endereco = paste(ENDERECO, NUMERO, BAIRRO, CEP, ", Sao Paulo, Brazil"))
```

Com a função _geocode_, procuraremos a latitude e longitude dos 46 CEUs. Vamos ver o exemplo do primeiro CEU, criando um objeto tipo 'sf' com o sistema de referência de coordenadas usado pelo google maps (WGS84 = epsg 4326):
  
```{r}
library(ggmap)
ceu1 <- geocode(ceu$endereco[1]) %>% 
  st_as_sf(coords=c("lon","lat"),crs=4326)
```

Podemos mapear os resultados:

```{r}
ceu1 %>% mapview()
```

Usando o que já havíamos visto, obtivemos um mapa com um único ponto. De fato, se procurarmos a informação original deste CEU (CEU Alvarenga), veremos que obtivemos a latitude e longitude bem pertos.

```{r}
rbind(ceu1 %>% st_coordinates(),
      ceu[1,] %>% st_coordinates())
```

Para georeferenciar todos os endereços de CEUs é a mesma lógica. Só precisamos resolver um problema de encoding irritante primeiro. Procuraremos a latitude e longitude dos 46 endereços, e tiramos aqueles que falharem (aqueles que tem _NA_):
  
```{r}
ceu$endereco <- iconv(ceu$endereco, to = "ASCII//TRANSLIT")
ceu_all <- geocode(ceu$endereco) %>% 
  filter(is.na(lat)==F & is.na(lon)==FALSE) %>%
  st_as_sf(coords=c("lon","lat"),crs=4326)

ceu_all %>% mapview()
```

Simples, não! O principal problema da função _geocode_ - e por que você pode ver menos de 46 pontos em seu mapa - é que há um limite de consultas por conta dos termos da Google Maps API. A alternativa é usar como argumento de _geocode_ "source = 'dsk'" [Data Science Toolkit](http://www.datasciencetoolkit.org/about), que reune uma série de fontes de dados e utiliza outra API para a consulta de latitude e longitude de logradouros.

### Exercício
Use a função _geocode_ para geolocalizar três endereços com os quais você está familiarizado em São Paulo e criar um mapa com _ggplot_ e um mapa interativa com _mapview_.

## Trabalhando com Polígonos

Áreas administrativas são geralmente representadas como polígonos em mapas. Em geral, obtemos esses polígonos como 'shapefiles' produzidos por uma agência oficial. Podemos abrir qualquer tipo de shapefile (pontos, linhas ou polígonos) com a função _read\_sf_. Vamos abrir um shapefile (simplificado) de IBGE dos municipios do Brasil.

```{r}
download.file("https://github.com/JonnyPhillips/Curso_R/raw/master/Brazil_s.zip",destfile="Brazil_s.zip")
unzip("Brazil_s.zip")
municipios <- read_sf("Brazil_s.shp")
```

Como podemos visualizar este mapa? Exatamente o mesmo que antes:

```{r}
municipios %>% ggplot() +
  geom_sf()
```

Enquanto trabalhando com dados espaciais de diversas fontes (ex. as escolas e os municipios), __é essencial ter certeza que estamos trabalhando com a mesma projeção para todos os objetos__ - caso contrário nossos mapas podem não aparecer corretamente e nossas medidas espaciais serão imprecisas. Dar uma olhada na CRS/projeção de 'municipios' - está escrito "+proj=longlat +ellps=GRS80 +no_defs" - em contraste de CRS/projeção de 'escolas' - "+proj=longlat +datum=WGS84 +no_defs". O parte 'WGS84' é o mais comum então vamos transformar os dados dos municipios para a mesma projeção usando a função _st\_transform_ e o shortcut 4326 para WGS84. Agora estamos tudo pronto para fazer analises ou mapas incorporando as duas camadas espaciais.

```{r}
municipios <- municipios %>% st_transform(4326)
```

## Joins Não-Espaciais

Se abre o objeto _municipios_ vai ver os detalhes de CRS/projeção e o data.frame dele mesmo, incluindo a coluna de 'geometry' e também todas as colunas normais, incluindo o código municipal (CD_GEOCODM). Isso é uma oportunidade para nós - se tivermos dados em todos os municípios, podemos simplesmente 'join' estes dados no shapefile e, em seguida, podemos visualizar mapas dessas variáveis.

Por exemplo, vamos baixar os dados eleitorais de 2010 para cada município e calcular o percentagem de voto da Dilma no segundo turno. 

```{r}
library(cepespR)
dados_eletorais <- get_elections(year=2010, position="President", regional_aggregation="Municipality", political_aggregation="Candidate")

dados_eletorais <- dados_eletorais %>% filter(NUM_TURNO==2) %>% 
  group_by(COD_MUN_IBGE) %>%
  mutate(pct_voto=100*(QTDE_VOTOS/sum(QTDE_VOTOS))) %>%
  filter(NOME_URNA_CANDIDATO=="DILMA")
```

Agora, se quisermos tornar esses dados eleitorais espaciais podemos fazer um _left\_join_ com o nosso shapefile, contanto que, como normal, os nomes e tipo de colunas chaves - o código do IBGE - nos dois bancos de dados são os mesmos. 

```{r}
municipios <- municipios %>% rename("COD_MUN_IBGE"="CD_GEOCODM") %>% 
  mutate(COD_MUN_IBGE=as.numeric(COD_MUN_IBGE)) %>%
  left_join(dados_eletorais,by="COD_MUN_IBGE")
```

Quantas colunas o nosso objeto _municipios_ tem agora? Muitos - todos os dados eletorais também.

```{r}
municipios
```

Para visualizar a coluna 'pct_voto' num mapa, podemos trabalhar em ggplot como normal. Para polígonos, colocamos o nome de coluna para o parâmetro _fill_ ( _color_ com pontos e linhas). Um mapa de todo o Brasil pode ser esmagador, então vamos nos concentrar em São Paulo com um _filter_.

```{r}
municipios %>% filter(SIGLA_UE=="SP") %>% 
  ggplot() +
  geom_sf(aes(fill=pct_voto))
```

Vamos destacar as fronteiras em branco, aplicar um tema e tirar as linhas de longitude/latitude.

```{r}
municipios %>% filter(SIGLA_UE=="SP") %>% 
  ggplot() +
  geom_sf(aes(fill=pct_voto),color="white") +
  theme_classic() +
  coord_sf(datum=NA)
```

Além disso, podemos alterar as escalas de cores como normal em ggplot. 

```{r}
municipios %>% filter(SIGLA_UE=="SP") %>% 
  ggplot() +
  geom_sf(aes(fill=pct_voto),color="white") +
  theme_classic() +
  coord_sf(datum=NA) +
  scale_fill_gradient(low="white",high="red")
```

Podemos colocar os pontos no mesmo mapa? Sim - apenas especificamos o parâmetro de dados para uma nova camada dentro de _geom\_sf_. (Isto assume que nós confirmamos que ambas as camadas têm a mesma projeção, como confirmamos acima).

```{r}
municipios %>% filter(SIGLA_UE=="SP") %>% 
  ggplot() +
  geom_sf(aes(fill=pct_voto),color="white") +
  theme_classic() +
  scale_fill_gradient(low="white",high="red") +
  geom_sf(data=ceu,color="dark green") +
  coord_sf(datum=NA)
```

### Exercício
Crie um mapa do percentagem de voto de Serra nos municipios de Tocantins no segundo turno da eleição presidencial de 2010.

## Joins Espaciais

O mundo espacial abre um novo tipo de join entre diversas bancos de dados - joins espaciais que são definido pela localização semelhante e não por uma chave comum nas tabelas de dados. Existe diversas tipos de joins espaciais mas vamos focar sobre um join entre uma camada de polígonos e uma camada de pontos. Queremos pegar os dados de polígono (município) em que fica cada ponto (escola). Vamos usar _st\_join_ para fazer um join espacial e usar o tipo de comparação de _st\_intersects_ (que simplesmente significa que um join existe quando um ponto é dentro de um polígono). (Lembra-se que é importante confirmar que ambas as camadas têm a mesma projeção, como confirmamos acima).

```{r}
joined <- ceu %>% st_join(municipios,st_intersects)
```

Agora, o objeto 'joined' contém os dados de escolas e colunas adicionais com dados dos polígonos em que cada escola existe. Isso facilita comparações entre cada escola e os dados eleitorais da sua região, mas também podemos simplesmente contar o número de escolas em cada polígono (município). Claro que neste caso, a maioria das escolas estão localizadas na PMSP.

```{r}
joined %>% group_by(NM_MUNICIP) %>% count()
```

## Outras operações espaciais

O pacote simple features inclui muitas metodologias espaciais. Como exemplo, podemos calcular a distancia entre cada um das escolas CEU (em metros) com _st\_distance_. O resultado é um matriz (simétrico) com distancias entre escolas.

```{r}
ceu %>% st_distance()
```

## Rasters
Existe um outro formato para dados espaciais que não é baseado em formas geométricas (polígonos, pontos e linhas), mas em uma grade regular com valores específicos em cada célula x, y - isto é um 'raster' e para trabalhar com ele usamos o pacote 'raster'. Vamos usar o código debaixo para abrir um arquivo raster de densidade populacional no Camboja, que é simplesmente um imagem com extensão _.tif_.

```{r}
library(raster)
download.file("https://github.com/JonnyPhillips/Curso_R/raw/master/khm_popdenr_landscan_2011.zip",destfile="khm_popdenr_landscan_2011.zip")
unzip("khm_popdenr_landscan_2011.zip")
cambodia <- raster("khm_popdenr_landscan_2011.tif")
```

Para visualizar o nosso raster, precisamos transformar ele em um data.frame simples e usar o ggplot com _geom_tile_.

```{r}
cambodia %>% as("SpatialPixelsDataFrame") %>% 
  as.data.frame() %>% 
  ggplot() + 
  geom_tile(aes(x=x,y=y,fill=khm_popdenr_landscan_2011))
```

Este mapa parece bem chato porque os dados são altamente skewed, com grandes outliers apenas na capital. Frequentemente com rasters é útil transformá-los em uma escala de log antes de visualizar. Vamos também limpar o fundo e adicionar uma escala de cores.

```{r}
cambodia %>% as("SpatialPixelsDataFrame") %>% 
  as.data.frame() %>% 
  ggplot() + 
  geom_tile(aes(x=x,y=y,fill=log(khm_popdenr_landscan_2011))) +
  coord_equal() +
  theme_void() +
  scale_fill_gradient(low="white",high="red",na.value="white")
```

Também podemos criar mapas de raster interativos com mapview. (Adicionamos uma pequena quantidade ao log para evitar valores infinitos e erros).

```{r}
log(cambodia+0.00001) %>% 
  brick() %>% 
  mapview(layer.name="khm_popdenr_landscan_2011")
```


#### Exercício:

Vá a uma das duas fontes de mapas indicadas -- [Prefeitura de São Paulo](http://www.prefeitura.sp.gov.br/cidade/secretarias/urbanismo/dados_estatisticos/index.php?p=160798) ou  [Centro de Estudos da Metrópole (CEM)](http://www.fflch.usp.br/centrodametropole/) -- importe os dados e produza um mapa. Dependendo do tema que você escolher, você produzirá mapas com polígonos (por exemplo, mapas de divisões políticas ou administrativas), linhas (ruas, ciclovias, etc), pontos (unidades de saúde, escolas, etc) ou rasters.
