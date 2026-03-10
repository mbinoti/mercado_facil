# Backlog de Melhorias de Delivery

Backlog tecnico de curto prazo para evoluir o `Mercado Facil` sem aumentar demais a complexidade do produto.

Contexto assumido:
- app de supermercado com foco em compra recorrente
- prioridade em conversao, recompra e reducao de friccao
- operacao ainda simples, sem regras logisticas sofisticadas

## Prioridade 1: busca simples e atalhos de categoria na home

### Problema
Hoje a descoberta depende principalmente da vitrine e dos banners. Para compra recorrente de supermercado, muita gente entra procurando um item objetivo.

### Objetivo
Reduzir tempo ate o primeiro produto no carrinho.

### Escopo minimo
- adicionar campo de busca na home
- filtrar produtos por nome e detalhes
- adicionar chips simples de categorias ou grupos de vitrine
- permitir limpar busca rapidamente

### Arquivos mais provaveis
- `lib/ui/screens/home_screen.dart`
- `lib/viewmodel/home_products_viewmodel.dart`
- `lib/model/home_product.dart`
- `lib/repository/hive_fake_products_repository.dart`

### Observacoes tecnicas
- se o repositorio ainda nao tiver categoria, adicionar um campo simples e estavel no seed, como `category`
- nao criar aba completa de categorias antes de validar uso da busca e dos chips
- manter a home utilizavel mesmo sem texto digitado

### Criterios de aceite
- usuario consegue buscar por nome parcial
- usuario consegue tocar em um chip e ver a lista filtrada
- busca e chip podem ser removidos sem sair da tela
- home continua mostrando promocoes e catalogo sem quebrar o fluxo atual

### Metrica principal
- conversao home -> carrinho

---

## Prioridade 2: recompra rapida a partir de pedidos

### Problema
O app ja guarda historico de pedidos, mas ainda nao transforma isso em recorrencia.

### Objetivo
Aumentar recompra com a menor mudanca possivel.

### Escopo minimo
- adicionar CTA `Comprar novamente` no card de pedido
- reenviar os itens do pedido para o carrinho
- levar o usuario para a aba de carrinho apos a acao

### Arquivos mais provaveis
- `lib/ui/screens/orders_screen.dart`
- `lib/viewmodel/orders_viewmodel.dart`
- `lib/viewmodel/cart_viewmodel.dart`
- `lib/viewmodel/app_shell_viewmodel.dart`
- `lib/model/order.dart`

### Observacoes tecnicas
- preferir reaproveitar `CartViewModel.addProduct` para evitar regra duplicada
- se existir item repetido no pedido, somar quantidade corretamente
- por enquanto, aceitar recompra integral do pedido; nao criar seletor de itens nessa fase

### Criterios de aceite
- usuario consegue refazer um pedido em um toque
- itens reaparecem no carrinho com as quantidades corretas
- usuario cai no carrinho ao final da acao
- feedback visual confirma que a recompra foi aplicada

### Metrica principal
- taxa de recompra

---

## Prioridade 3: endereco e entrega mais cedo no fluxo

### Problema
O endereco aparece tarde, apenas no checkout. Isso aumenta surpresa de frete e prazo perto do fim do funil.

### Objetivo
Dar visibilidade de entrega antes da confirmacao do pedido.

### Escopo minimo
- mostrar resumo de entrega no carrinho
- exibir endereco atual ou estado vazio orientando o preenchimento
- mostrar tipo de entrega, taxa e prazo estimado antes do checkout
- preparar local simples para persistir endereco padrao depois

### Arquivos mais provaveis
- `lib/ui/screens/cart_screen.dart`
- `lib/ui/screens/checkout_screen.dart`
- `lib/ui/screens/app_shell_screen.dart`
- `lib/model/order.dart`

### Observacoes tecnicas
- nao criar perfil completo agora
- nao introduzir CEP, mapa e validacao geografica real nesta etapa
- se ainda nao houver storage para endereco, usar estado simples local ou global como passo inicial

### Criterios de aceite
- carrinho mostra informacao de entrega antes de finalizar compra
- usuario entende taxa e prazo antes de entrar no checkout
- fluxo de checkout continua funcionando com os modos atuais
- mensagem de estado vazio deixa claro o que falta informar

### Metrica principal
- conversao carrinho -> pedido

---

## Ordem de implementacao recomendada

1. Busca simples e chips na home
2. Recompra rapida em pedidos
3. Resumo de entrega no carrinho

## O que nao entra agora

- cashback
- clube de fidelidade
- cupons complexos
- perfil completo
- gamificacao
- categorias profundas com muitos filtros

## Riscos de produto e operacao

- busca ruim demais piora descoberta em vez de ajudar; manter simples e objetiva
- recompra pode frustrar se futuramente houver item indisponivel; prever fallback quando esse problema aparecer
- entrega antecipada no fluxo so ajuda se prazo e taxa refletirem a operacao real
