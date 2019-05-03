# Family Business US Merge and Acquisition Project
            
This project has the following tasks:
- Extract, Read and Merge raw data
- Treat the raw data to tidy data
- Load the final data to analysis


## Define Variables

(TO TRANSLATE)

Vari?vel Dependente:
       Ocorr?ncia de aquisi??o (vari?vel bin?ria)
Valida??o de todos os eventos de aquisi??es usando v?rias fontes, 
incluindo documentos de an?ncio de negocia??o e artigos de jornal


Vari?veis Independentes:
       (1)   Classifica??o discreta do tipo de propriedade (quem controla a maioria das a??es) 
 a fim de avaliar a correspond?ncia entre as empresas adquirente e alvo. Tipos de propriet?rios: 
       (1) fam?lia, 
 (2) multinacional estrangeira, 
 (3) coaliz?o de investidores privados, 
 (4) cooperativa, 
 (5) private equity, fundos de investimento, 
 (6) bancos e 
 (7) municipalidades estaduais ou municipais.
 
 (O controle ? medido se um determinado propriet?rio possui pelo menos 50% das a??es da empresa ou 
       25% se a empresa estiver listada).
 Cria??o de uma dummy que assume valor 1 quando as duas empresas compartilham o mesmo tipo de propriedade 
 antes da aquisi??o e 0 caso contr?rio.
 
 (2)	Similaridade no comprometimento da propriedade. Uma medida mais sutil da dist?ncia entre os tipos de 
 propriedade.
 Classificam os tipos de propriedade identificados em (1) de acordo com o prov?vel envolvimento dos 
 acionistas com as principais prioridades de sua empresa.
 
 N?vel de Comprometimento: 
       - Muito Alto (pontua??o 4): alcan?ado em empresas familiares;
 - M?dio-Alto (pontua??o 3): empresas controladas por coaliz?es de investidores privados ou cooperativas vis-?-vis as empresas familiares;
 - M?dio-baixo (pontua??o 2): subsidi?rias de multinacionais estrangeiras e empresas estatais;
 - Muito baixo (pontua??o 1): empresas controladas por investidores financeiros (bancos, private equity ou fundos de investimento).
 
 C?lculo da similaridade no compromisso de propriedade: 
       inverso do valor absoluto da diferen?a entre o escore do adquirente e o do alvo: 
       a vari?vel assume o valor de 
 3 quando as duas empresas t?m o mesmo compromisso de propriedade, 
 0 quando eles diferem completamente e 1 ou 2 quando diferem apenas moderadamente.
 
 (3)	Grau de envolvimento da fam?lia em atividades da empresa para avaliar a similaridade entre o 
 adquirente e o alvo.
 Classifica??o das empresas: 
       (1) propriedade familiar e controle familiar: a maioria das a??es est? nas m?os de uma 
 fam?lia e todos os conselheiros s?o membros da fam?lia controladora; 
 (2) propriedade familiar: a maioria das a??es est? nas m?os de uma fam?lia, 
 mas nem todos os membros do conselho s?o da fam?lia controladora; e 
 (3) n?o familiar: a maioria das a??es n?o ? controlada por uma fam?lia
 
 Medida de similaridade no envolvimento familiar: 
       - Similaridade Alta (pontua??o 2): as duas empresas fazem parte do mesmo cluster;
 - Similaridade Moderada (pontua??o 1): tanto o adquirente como as firmas-alvo s?o de propriedade familiar, mas apenas um dos dois ? controlado pela fam?lia;
 - Dissimilaridade Moderada (pontua??o ???1): uma das duas empresas ? de propriedade familiar (mas n?o controlada) e a contraparte n?o ?;
 - Dissimilaridade Alta (pontua??o ???2): uma das duas empresas ? de propriedade n?o familiar e a contraparte ? de propriedade e controle familiar.
