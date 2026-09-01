# Relatório - Atividade 2

## 1. As duas fases
**Fase 1 (Game):**
* Tema: Floresta outonal com árvores de folhas laranjas e terreno de terra.
* O que o jogador faz: Pula entre plataformas horizontais, supera um fosso de água e sobe uma escadaria de terra para alcançar a casa no final do mapa.
* Decisão de desenho: A casa de chegada foi posicionada no ponto mais alto da extrema direita para servir como um marco visual claro de objetivo, exigindo uma subida final.

**Fase 2 (Winter):**
* Tema: Cenário de inverno com terreno nevado, blocos de gelo e cordilheiras ao fundo.
* O que o jogador faz: Atravessa o ambiente gelado e abismos para chegar à casa, ou explora a parte inferior para encontrar uma rota alternativa.
* Decisão de desenho: A inclusão de um caminho inferior (`secretway`) logo no início da fase cria uma bifurcação, recompensando a exploração fora da rota principal óbvia.

## 2. O parallax
**Fase "Game":**
* Camada 6 (Mais profunda): `motion_scale` de 0.2.
* Camada 2 (Árvores): `motion_scale` de 0.6, criando a sensação de movimento e profundidade.
* Camada 1 (Topo): `motion_scale` de 1.2, movendo-se mais rápido para aumentar a imersão.

**Fase "Winter":**
* Camada 3 (Montanha gigante): `motion_scale` de 0.2.
* Camada 2 (Fundo intermediário): `motion_scale` de 0.5.
* Camada 1 (Chão da fase): `motion_scale` de 0.8.

**Fase Secreta:**
* Camadas 1, 2 e 3 (Chão, nuvens baixas e céu simples): `motion_scale` de 1.0.
* Camada 4 (Nuvens pequenas): `motion_scale` de 0.7.

A evolução entre a primeira tentativa e a versão final envolveu o ajuste de alinhamento vertical e a configuração das camadas para manterem a proporção sem quebrar o cenário.

## 3. A área secreta
* Pista: Um pequeno rebaixamento no terreno com uma estrutura alaranjada destoante do cenário de gelo logo após o início da fase de inverno.
* Entrada: O nó de colisão (`TransitionSecret`) localizado na porta inferior do primeiro trecho da fase Winter.
* Motivo da separação: A área secreta possui um level design 100% vertical (escalada de pequenas plataformas até o céu). Integrar isso no mesmo mapa horizontal exigiria comprometer o fluxo de jogo e geraria conflitos irreversíveis com as configurações de limite de câmera das fases normais.

## 4. A câmera
* Forma escolhida: Configuração dos limites numéricos (`limit_top`, `limit_bottom`, etc.) baseando-se nas coordenadas exatas da peça mais alta e mais baixa construídas no mapa (ex: clicando no topo do telhado da casa).
* O que perderia com a outra: Se os limites da câmera fossem definidos com base nas dimensões da imagem de fundo verde, a lente seria impedida de subir, cortando a parte superior da casa da visão do jogador e arruinando o level design.

## 5. A transição
A troca de fase não pode ser chamada diretamente na detecção da colisão (no evento `body_entered`) porque a Godot está no meio dos cálculos matemáticos de física daquele frame. Deletar e carregar uma cena nova enquanto o motor resolve batidas e sobreposições causa corrupção de memória e travamentos. O correto é delegar o carregamento para ser feito de forma segura logo após o processamento físico terminar.

## 6. O que travou
O fundo do cenário ficava totalmente desconfigurado ao iniciar o jogo. Ele esticava, cintilava e deixava um buraco cinza vazio na parte inferior, mesmo parecendo perfeitamente alinhado na tela do editor. 

Achei que era um problema de arrastar a imagem incorretamente e tentei resolver movendo a textura com o mouse. Na verdade, eram peculiaridades de renderização da engine. A distorção dos pixels ocorria pelo modo de escala, e o buraco inferior acontecia porque o `motion_scale` no eixo Y alterava o comportamento da imagem em relação à lente móvel. O editor mostrava as coordenadas absolutas paradas, mas no jogo a câmera descia até o jogador e largava o fundo para trás. Descobri a solução alterando o Scale Mode para *integer*, configurando a propriedade Region com o dobro da largura para repetição perfeita e zerando o movimento vertical para a imagem grudar na visão da câmera.
