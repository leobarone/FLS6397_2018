#  FLS 6397 - Introdução à Programação e Ferramentas Computacionais para as Ciências Sociais

- Responsáveis: Leonardo S. Barone e Jonathan Phillips
- Data: 04/06/2018

## Aula 9 - Captura de dados na internet com R

### Objetivos Gerais

Nesta aula vamos ter uma breve introdução ao pacote _rvest_ e à algumas técnicas de raspagem de dados de página em HTML com R. Veremos que não é preciso saber quase nada de HTML para conseguir extrair conteúdo de uma página de internet e que as bibliotecas desenvolvidas para a linguagem facilitam bastante a organização do conteúdo raspado.

Trabalharemos apenas com exemplos simples: páginas com tabela e portais de notícias.

### Roteiro para a aula

Teremos 4 tutoriais neste tópico. Leia atentamente o roteiro abaixo e faça-os em ordem.

1 - Comece aprendendo a raspar uma sequência de páginas que contêm tabelas no Tutorial 15 [versão github](https://github.com/leobarone/FLS6397_2018/blob/master/tutorials/tutorial15.Rmd). Em HTML, tabelas são facilmente identificáveis e há funções específicas que facilitam a extração de tabelas de um documento HTML. Por esta razão, páginas com tabelas são o caso mais simples de raspagem de dados. A estratégia que aprenderemos neste primeiro tutorial, no entanto, servirá aos seguintes.

2 - A maior parte das informações que queremos extrair, no entanto, não estão em tabelas. Aprenderemos como extrair informações de uma página qualquer de internet no Tutorial 16 [versão github](https://github.com/leobarone/FLS6397_2018/blob/master/tutorials/tutorial16.Rmd)

3 - Seguindo com o exemplo do tutorial anterior, extrairemos informações de uma sequência páginas (busca de notícias) no Tutorial 17 [versão github](https://github.com/leobarone/FLS6397_2018/blob/master/tutorials/tutorial17.Rmd).

4 - Finalmente, trabalharemos com o exemplo do DataFolha para coletar um conjunto de notícias em um buscador qualquer. O Tutorial 18 [versão github](https://github.com/leobarone/FLS6397_2018/blob/master/tutorials/tutorial18.Rmd) condensa o que vimos nos tutoriais anteriores e exige uma compreensão um pouco mais clara de loops e condicionais. Note que algumas páginas que tenteramos capturar neste exemplo contêm erros. A solução definitiva do exemplo está no final do tutorial.
