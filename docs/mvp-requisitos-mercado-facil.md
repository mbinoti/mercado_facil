# MVP de Requisitos de Software - Mercado Fácil

## 1. Objetivo do documento
Este documento consolida o MVP do aplicativo **Mercado Fácil** com base em boas práticas de Engenharia de Requisitos alinhadas ao CPRE/IREB. O objetivo é transformar a ideia bruta de um app de delivery de supermercado em um escopo inicial claro, validável e implementável.

Este MVP foi estruturado para responder a quatro perguntas centrais:
- qual problema o produto resolve;
- para quem o produto será construído;
- o que entra e o que não entra na primeira versão;
- como validar se o MVP realmente gera valor.

## 2. Declaração do MVP
O MVP do **Mercado Fácil** deve permitir que uma pessoa:
- descubra produtos de supermercado;
- monte um carrinho;
- escolha entre entrega ou retirada;
- finalize o pedido com uma forma de pagamento disponível;
- acompanhe o pedido no histórico.

O MVP **não** pretende resolver logística avançada, fidelização, promoções complexas ou operação multiloja.

## 3. Visão do produto

### 3.1 Problema de negócio
Fazer compras de supermercado costuma ser uma atividade recorrente, urgente e de baixa tolerância a fricção. Em muitos cenários, o usuário quer repor itens do dia a dia rapidamente, sem precisar navegar por fluxos complexos.

### 3.2 Oportunidade
Um app simples de grocery delivery pode capturar valor ao reduzir:
- o tempo até encontrar um produto;
- o esforço para fechar um pedido;
- a incerteza sobre entrega, retirada e pagamento.

### 3.3 Proposta de valor
O **Mercado Fácil** oferece uma experiência simples para compras recorrentes de mercado, com foco em rapidez, clareza e fechamento de pedido em poucos passos.

## 4. Objetivos de negócio do MVP
- Validar interesse por compras de supermercado via app mobile.
- Validar a jornada ponta a ponta de catálogo até pedido confirmado.
- Reduzir o tempo até o primeiro item no carrinho.
- Medir a conversão entre exploração de catálogo e pedido concluído.
- Criar base para evolução futura em recompra, promoções e personalização.

## 5. Stakeholders
- **Usuário comprador**: pessoa que deseja comprar produtos de mercado para entrega ou retirada.
- **Operação da loja**: equipe responsável por separar e entregar/dispensar pedidos.
- **Atendimento**: equipe que lida com dúvidas, problemas de pedido e contato com cliente.
- **Produto/negócio**: responsável por priorização, métricas e evolução do MVP.
- **Tecnologia**: time responsável por implementar, manter e evoluir o app.

## 6. Perfis de usuário

### 6.1 Persona principal: compradora recorrente
- Faz compras semanais ou quinzenais.
- Busca rapidez e previsibilidade.
- Valoriza atalhos, histórico e clareza de entrega.

### 6.2 Persona secundária: comprador urgente
- Precisa repor poucos itens no mesmo dia.
- Quer busca rápida, checkout curto e entrega expressa.

## 7. Premissas e restrições assumidas
- O MVP atenderá inicialmente uma operação simples, com uma loja ou centro de distribuição principal.
- O catálogo poderá começar controlado internamente, sem integração com ERP.
- Preços, imagens e descrições poderão ser mantidos por carga manual ou seed.
- Estoque em tempo real não será obrigatório no MVP.
- O usuário poderá concluir a compra sem um cadastro complexo.
- Endereço e dados de entrega poderão ser informados no checkout.
- Taxa e prazo de entrega serão configuráveis por modalidade de recebimento.
- O foco inicial será mobile, com compatibilidade Android e iOS.

## 8. Escopo do MVP

### 8.1 Funcionalidades que entram no MVP
- Onboarding inicial simples.
- Navegação por home, catálogo e categorias.
- Busca simples por produtos.
- Visualização de detalhes de produto.
- Adição e remoção de itens no carrinho.
- Visualização de subtotal no carrinho.
- Checkout com escolha de modalidade de recebimento.
- Captura de dados mínimos para entrega ou retirada.
- Seleção de forma de pagamento.
- Confirmação do pedido.
- Histórico de pedidos confirmados.

### 8.2 Funcionalidades que não entram no MVP
- Rastreamento em tempo real do entregador.
- Geolocalização avançada e cálculo de rota.
- Estoque em tempo real por loja.
- Cupons complexos e motor promocional avançado.
- Cashback, clube de fidelidade e gamificação.
- Multiloja.
- Chat com entregador.
- Cancelamento automatizado e reembolso online.
- Programa de assinatura.
- Recomendações inteligentes baseadas em IA.

## 9. Contexto de uso
O aplicativo será usado principalmente em momentos de compra recorrente ou reposição urgente. O contexto típico é um usuário em casa, no trabalho ou em deslocamento, usando o celular para:
- procurar produtos;
- comparar rapidamente opções;
- montar um carrinho com poucos ou vários itens;
- escolher entrega ou retirada;
- fechar o pedido com o menor atrito possível.

## 10. Jornadas principais do usuário

### 10.1 Jornada 1: compra rápida por busca
1. Usuário abre o app.
2. Acessa home ou catálogo.
3. Busca um produto pelo nome.
4. Visualiza detalhes e adiciona ao carrinho.
5. Abre o carrinho.
6. Avança para o checkout.
7. Escolhe entrega ou retirada.
8. Informa os dados mínimos necessários.
9. Escolhe a forma de pagamento.
10. Confirma o pedido.

### 10.2 Jornada 2: compra por navegação
1. Usuário entra na home.
2. Explora categorias, vitrines ou promoções.
3. Adiciona produtos ao carrinho.
4. Ajusta quantidades.
5. Finaliza no checkout.

### 10.3 Jornada 3: acompanhamento do pedido
1. Usuário conclui a compra.
2. O sistema registra o pedido como confirmado.
3. Usuário acessa a área de pedidos.
4. Visualiza resumo, modalidade de entrega e forma de pagamento.

## 11. Requisitos funcionais

### 11.1 Acesso inicial e navegação

**RF-01.** O sistema deve exibir onboarding na primeira abertura do aplicativo.
Fonte: necessidade de apresentar proposta de valor e fluxo inicial.

**RF-02.** O sistema deve permitir pular ou concluir o onboarding.
Fonte: redução de fricção na entrada.

**RF-03.** O sistema deve disponibilizar navegação principal para, no mínimo, início, categorias, carrinho e pedidos.
Fonte: fluxo essencial de exploração e compra.

### 11.2 Descoberta de produtos

**RF-04.** O sistema deve apresentar catálogo de produtos com nome, imagem, preço e informações resumidas.
Fonte: necessidade básica de descoberta e decisão.

**RF-05.** O sistema deve permitir busca simples por nome e/ou palavras-chave do produto.
Fonte: compras recorrentes e objetivas exigem descoberta rápida.

**RF-06.** O sistema deve permitir navegação por categorias ou agrupamentos de produtos.
Fonte: exploração assistida do catálogo.

**RF-07.** O sistema deve destacar promoções, coleções ou vitrines na home quando não houver filtro ativo.
Fonte: conversão e merchandising básico.

**RF-08.** O sistema deve permitir abrir a página de detalhe de um produto.
Fonte: apoio à decisão de compra.

### 11.3 Produto e carrinho

**RF-09.** O sistema deve permitir adicionar um produto ao carrinho a partir da listagem e da página de detalhe.
Fonte: fluxo principal de compra.

**RF-10.** O sistema deve permitir alterar a quantidade de itens no carrinho.
Fonte: ajuste de pedido antes do fechamento.

**RF-11.** O sistema deve permitir remover itens do carrinho.
Fonte: controle do pedido.

**RF-12.** O sistema deve calcular e exibir o subtotal do carrinho.
Fonte: transparência no valor antes do checkout.

**RF-13.** O sistema deve informar claramente quando o carrinho estiver vazio e oferecer retorno à navegação de compra.
Fonte: usabilidade.

### 11.4 Checkout

**RF-14.** O sistema deve permitir ao usuário iniciar o checkout a partir do carrinho.
Fonte: continuidade do funil.

**RF-15.** O sistema deve oferecer pelo menos as modalidades de recebimento:
- entrega expressa;
- entrega agendada;
- retirada na loja.

**RF-16.** O sistema deve exibir taxa e prazo estimado para cada modalidade de recebimento.
Fonte: clareza operacional e decisão do usuário.

**RF-17.** O sistema deve solicitar nome do recebedor.
Fonte: identificação mínima para entrega ou retirada.

**RF-18.** O sistema deve solicitar endereço e bairro quando a modalidade escolhida exigir entrega.
Fonte: viabilização da operação.

**RF-19.** O sistema não deve exigir endereço quando a modalidade escolhida for retirada na loja.
Fonte: adequação ao contexto de retirada.

**RF-20.** O sistema deve permitir informar complemento ou referência de entrega.
Fonte: redução de falhas operacionais.

**RF-21.** O sistema deve permitir selecionar forma de pagamento.
Fonte: fechamento do pedido.

**RF-22.** O sistema deve oferecer, no mínimo, pagamento via Pix, cartão de crédito e cartão na entrega.
Fonte: cobertura inicial das opções mais comuns.

**RF-23.** O sistema deve permitir parcelamento quando a forma de pagamento for cartão de crédito.
Fonte: flexibilidade comercial.

**RF-24.** O sistema deve validar os campos obrigatórios antes da confirmação do pedido.
Fonte: integridade do processo.

### 11.5 Confirmação e histórico

**RF-25.** O sistema deve permitir confirmar o pedido após validação dos dados do checkout.
Fonte: encerramento da jornada principal.

**RF-26.** O sistema deve gerar um identificador ou código de pedido.
Fonte: rastreabilidade mínima.

**RF-27.** O sistema deve registrar o pedido com data, itens, subtotal, taxa de entrega, total, modalidade e forma de pagamento.
Fonte: histórico e suporte operacional.

**RF-28.** O sistema deve limpar o carrinho após a confirmação bem-sucedida do pedido.
Fonte: consistência do estado da aplicação.

**RF-29.** O sistema deve exibir o pedido na área de histórico.
Fonte: transparência e confiança.

**RF-30.** O sistema deve apresentar o status do pedido ao menos como "confirmado" no MVP.
Fonte: visibilidade mínima do processo.

## 12. Regras de negócio

**RN-01.** O valor total do pedido deve ser calculado como `subtotal dos itens + taxa da modalidade de recebimento`.

**RN-02.** A taxa de entrega deve variar conforme a modalidade de recebimento escolhida.

**RN-03.** A retirada na loja deve ter taxa zero, salvo decisão futura em contrário.

**RN-04.** Para modalidades de entrega, nome do recebedor, endereço e bairro são obrigatórios.

**RN-05.** Para retirada na loja, o endereço do cliente não é obrigatório.

**RN-06.** Parcelamento só pode ser oferecido para cartão de crédito.

**RN-07.** O pedido só pode ser confirmado se o carrinho contiver pelo menos um item.

**RN-08.** O pedido confirmado deve ficar disponível no histórico do usuário imediatamente após o fechamento.

**RN-09.** Taxas, prazos e janelas de entrega devem ser configuráveis, mesmo que inicialmente estejam definidos localmente.

## 13. Requisitos de qualidade

**RNF-01. Usabilidade.** O usuário deve conseguir adicionar o primeiro item ao carrinho em poucos passos, idealmente sem precisar passar por cadastro obrigatório.

**RNF-02. Clareza.** Informações de preço, modalidade de recebimento, taxa e forma de pagamento devem ser apresentadas de maneira objetiva.

**RNF-03. Desempenho.** As principais telas do MVP devem abrir de forma fluida em dispositivos móveis intermediários.

**RNF-04. Confiabilidade.** O sistema não deve permitir confirmação de pedido com dados obrigatórios ausentes.

**RNF-05. Compatibilidade.** O aplicativo deve funcionar em Android e iOS.

**RNF-06. Acessibilidade básica.** O MVP deve adotar textos legíveis, contraste adequado e áreas de toque utilizáveis.

**RNF-07. Persistência mínima.** O estado essencial do MVP deve ser preservado de forma consistente durante o uso do aplicativo.

**RNF-08. Privacidade mínima.** O sistema deve coletar apenas os dados pessoais necessários para viabilizar o pedido no MVP.

## 14. Critérios de aceite do MVP
- Usuário consegue abrir o app e entender rapidamente a proposta de valor.
- Usuário consegue localizar produtos por navegação ou busca simples.
- Usuário consegue adicionar, remover e ajustar itens no carrinho.
- Usuário consegue visualizar subtotal antes de seguir para o checkout.
- Usuário consegue escolher entre entrega expressa, entrega agendada e retirada.
- Usuário consegue informar os dados mínimos exigidos para a modalidade escolhida.
- Usuário consegue selecionar uma forma de pagamento.
- Usuário não consegue concluir pedido com dados obrigatórios faltando.
- Usuário consegue confirmar o pedido e visualizar o histórico logo em seguida.
- O fluxo principal do produto funciona ponta a ponta sem depender de operação complexa.

## 15. Métricas de validação do MVP
- Taxa de usuários que adicionam pelo menos um item ao carrinho.
- Taxa de conversão carrinho -> pedido confirmado.
- Tempo médio até o primeiro item no carrinho.
- Tempo médio até fechamento do pedido.
- Percentual de abandono no checkout.
- Distribuição por modalidade de recebimento.
- Percentual de pedidos concluídos sem erro de preenchimento.

## 16. Riscos e pontos de atenção
- Busca ruim pode aumentar fricção em vez de reduzir.
- Catálogo desatualizado compromete confiança do usuário.
- Falta de estoque em tempo real pode gerar ruptura após o pedido.
- Promessa de prazo imprecisa pode prejudicar percepção do serviço.
- Checkout longo demais pode reduzir conversão.
- Sem política clara para indisponibilidade, a operação pode gerar frustração.

## 17. Itens recomendados para pós-MVP
- Comprar novamente a partir do histórico.
- Favoritos.
- Endereço padrão salvo no perfil.
- Rastreamento de pedido.
- Cupom simples.
- Notificações de status.
- Tratamento de indisponibilidade de item.
- Estoque mais confiável.
- Integração com meios de pagamento reais.

## 18. Checklist de validação com stakeholders
Antes de congelar o escopo do MVP, recomenda-se validar os pontos abaixo com produto, operação e negócio:
- Qual é a cidade ou área de atendimento inicial?
- Haverá pedido mínimo para entrega?
- Quais modalidades de pagamento estarão realmente operacionais no lançamento?
- A entrega agendada será por janela fixa ou por horários escolhidos pelo usuário?
- Haverá taxa fixa por modalidade ou cálculo por distância/faixa?
- Quem manterá catálogo, preços e disponibilidade?
- Como tratar item indisponível após a confirmação?
- Será obrigatório login/cadastro no lançamento ou o checkout será suficiente?
- Haverá contato de suporte dentro do app?
- Quais métricas serão acompanhadas nas primeiras semanas?

## 19. Resumo executivo
O MVP recomendado para o **Mercado Fácil** é um aplicativo mobile de supermercado com foco em compra recorrente e fechamento rápido de pedido. O núcleo do produto é composto por descoberta de produtos, carrinho, checkout com entrega ou retirada e histórico de pedidos.

Do ponto de vista de Engenharia de Requisitos, este MVP está adequado para iniciar refinamento funcional, decomposição em backlog e definição de critérios de teste. O próximo passo recomendado é converter os requisitos prioritários em histórias de usuário com critérios de aceitação por fluxo.
