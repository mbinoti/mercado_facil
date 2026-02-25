# Analise Inicial de Requisitos (4 telas)

## Escopo desta entrega
Esta analise cobre as 4 primeiras telas do fluxo:

1. Onboarding Inicial
2. Login e Cadastro
3. Selecao de Endereco
4. Pagina Inicial (Home)

Referencia de implementacao atual:
- `lib/ui/screens/onboarding_screen.dart`
- `lib/ui/screens/login_screen.dart`
- `lib/ui/screens/address_selection_screen.dart`
- `lib/ui/screens/home_screen.dart`
- `lib/ui/widgets/app_bottom_nav.dart`
- `lib/model/hive/mercado_seed_data.dart`
- `lib/app_routes.dart`
- `lib/main.dart`

## Fluxo macro esperado
1. Usuario abre o app e visualiza onboarding.
2. Usuario avanca para autenticacao (login/cadastro).
3. Usuario define endereco de entrega.
4. Usuario acessa Home para descobrir ofertas, categorias e produtos.
5. Usuario segue para etapas de busca/produto/carrinho (fora do escopo desta entrega).

---

## 1) Tela de Onboarding Inicial

### Objetivo
Apresentar proposta de valor (frescor + praticidade) e conduzir o usuario para autenticacao.

### Requisitos funcionais
- `RF-ONB-01`: Exibir hero visual principal com mensagem de boas-vindas.
- `RF-ONB-02`: Exibir indicador visual de paginas/passos do onboarding.
- `RF-ONB-03`: Exibir CTA primario `Proximo`.
- `RF-ONB-04`: Exibir CTA secundario `Pular`.
- `RF-ONB-05`: Ao tocar `Proximo` ou `Pular`, navegar para tela de Login/Cadastro.
- `RF-ONB-06`: Layout deve se adaptar a diferentes alturas de tela (responsividade basica).

### Regras de negocio
- `RN-ONB-01`: O onboarding deve ser apresentado apenas no primeiro acesso (ou ate ser concluido).
- `RN-ONB-02`: Ao concluir/pular onboarding, estado `onboardingConcluido` deve ser persistido.

### Criterios de aceite (alto nivel)
- `CA-ONB-01`: Dado que o app foi aberto, quando a tela carrega, entao o usuario ve imagem, titulo, subtitulo e botoes.
- `CA-ONB-02`: Dado que o usuario toca em `Proximo`, quando a acao e executada, entao ele vai para Login/Cadastro.
- `CA-ONB-03`: Dado que o usuario toca em `Pular`, quando a acao e executada, entao ele vai para Login/Cadastro.

### Observacoes de aderencia ao codigo atual
- Navegacao para login ja existe via `Navigator.pushReplacementNamed`.
- Indicador visual existe, mas hoje esta estatico (sem multipaginas reais).
- Persistencia de conclusao do onboarding ainda nao esta conectada ao fluxo de abertura.

---

## 2) Tela de Login e Cadastro

### Objetivo
Permitir entrada rapida no app por email/telefone ou login social, com caminho para criacao de conta.

### Requisitos funcionais
- `RF-AUTH-01`: Exibir campo `E-mail ou Telefone`.
- `RF-AUTH-02`: Exibir botao primario `Continuar`.
- `RF-AUTH-03`: Exibir opcoes de login social: Google e Apple.
- `RF-AUTH-04`: Exibir CTA de cadastro (`Criar conta`) para usuarios sem conta.
- `RF-AUTH-05`: Concluir autenticacao e seguir para Selecao de Endereco.
- `RF-AUTH-06`: Exibir mensagens de erro em caso de entrada invalida (email/telefone).
- `RF-AUTH-07`: Diferenciar fluxo de login e fluxo de cadastro (mesmo que em etapas futuras).

### Regras de negocio
- `RN-AUTH-01`: Usuario deve estar autenticado para continuar o funil de compra.
- `RN-AUTH-02`: Login social deve retornar um usuario valido na sessao local.
- `RN-AUTH-03`: Campo de identificacao (email/telefone) e obrigatorio para login por credencial.

### Criterios de aceite (alto nivel)
- `CA-AUTH-01`: Dado que o usuario informa dado valido e toca `Continuar`, entao segue para Selecao de Endereco.
- `CA-AUTH-02`: Dado que o usuario escolhe Google/Apple e autenticacao e bem-sucedida, entao segue para Selecao de Endereco.
- `CA-AUTH-03`: Dado que o usuario informa dado invalido, quando tenta continuar, entao recebe feedback claro de validacao.
- `CA-AUTH-04`: Dado que o usuario toca `Criar conta`, entao inicia fluxo de cadastro.

### Observacoes de aderencia ao codigo atual
- UI principal e botoes sociais ja existem.
- Atualmente nao ha validacao de campo nem integracao real com provedores sociais.
- Todas as acoes levam diretamente para endereco (comportamento de prototipo).

---

## 3) Tela de Selecao de Endereco

### Objetivo
Permitir ao usuario definir endereco de entrega com rapidez e confianca antes de navegar no catalogo.

### Requisitos funcionais
- `RF-ADDR-01`: Exibir busca rapida de endereco (logradouro + numero).
- `RF-ADDR-02`: Exibir preview de mapa com localizacao atual/selecionada.
- `RF-ADDR-03`: Exibir acao `Usar minha localizacao atual`.
- `RF-ADDR-04`: Exibir lista de enderecos salvos do usuario.
- `RF-ADDR-05`: Permitir selecionar um endereco salvo.
- `RF-ADDR-06`: Exibir opcao `Adicionar novo endereco`.
- `RF-ADDR-07`: Confirmada a selecao, navegar para Home.

### Regras de negocio
- `RN-ADDR-01`: Um endereco deve estar selecionado para habilitar continuidade do fluxo.
- `RN-ADDR-02`: Endereco selecionado deve ser salvo na sessao do usuario.
- `RN-ADDR-03`: Caso geolocalizacao falhe, o usuario deve conseguir continuar por endereco manual.

### Criterios de aceite (alto nivel)
- `CA-ADDR-01`: Dado que a tela abre, quando carrega dados, entao exibe enderecos salvos e um endereco marcado como selecionado.
- `CA-ADDR-02`: Dado que o usuario escolhe um endereco salvo, quando confirma a acao, entao o app segue para Home.
- `CA-ADDR-03`: Dado que o usuario toca `Usar minha localizacao atual`, quando permissao/localizacao e obtida, entao endereco e atualizado.
- `CA-ADDR-04`: Dado que o usuario toca `Adicionar novo endereco`, entao inicia fluxo de cadastro de endereco.

### Observacoes de aderencia ao codigo atual
- Lista de enderecos e endereco selecionado ja sao carregados de seed (`MercadoSeedData`).
- Busca e mapa ainda sao visuais (sem geocodificacao e sem interacao real de mapa).
- Selecao/confirmacao ainda nao atualiza sessao em tempo de execucao (navega direto para Home).

---

## 4) Tela de Pagina Inicial (Home)

### Objetivo
Ser a central de descoberta de produtos e ofertas do app, com acesso rapido a busca, categorias, vitrine de ofertas e navegacao persistente.

### Requisitos funcionais
- `RF-HOME-01`: Exibir endereco de entrega selecionado no cabecalho.
- `RF-HOME-02`: Permitir trocar endereco tocando no cabecalho e navegar para Selecao de Endereco.
- `RF-HOME-03`: Exibir atalho de busca com navegacao para tela de busca.
- `RF-HOME-04`: Exibir secao `Ofertas da Semana` em lista horizontal com CTA `Ver tudo`.
- `RF-HOME-05`: Permitir abrir listagem/categorias ao tocar em `Ver tudo` ou em um card de oferta.
- `RF-HOME-06`: Exibir atalhos de categorias para descoberta rapida.
- `RF-HOME-07`: Exibir secao `Ofertas do dia` com indicador de expiracao da promocao.
- `RF-HOME-08`: Exibir produtos em grid de 2 colunas com nome, preco, preco antigo e badge promocional (quando houver).
- `RF-HOME-09`: Permitir abrir detalhes do produto ao tocar no card de produto.
- `RF-HOME-10`: Exibir acao de adicionar item no card de produto (icone `+`).
- `RF-HOME-11`: Exibir barra inferior com 5 abas (`Inicio`, `Buscar`, `Cesta`, `Pedidos`, `Perfil`).
- `RF-HOME-12`: Manter destaque visual da aba ativa e navegar para rotas das demais abas.

### Regras de negocio
- `RN-HOME-01`: A Home deve usar o endereco selecionado na sessao para contextualizar entrega.
- `RN-HOME-02`: Conteudos de ofertas e produtos da Home devem respeitar ordenacao/recorte definido para vitrine.
- `RN-HOME-03`: Produtos indisponiveis (quando existirem) devem impedir acao de adicionar ao carrinho.
- `RN-HOME-04`: Navegacao inferior deve manter consistencia de rotas e nao duplicar tela ativa.
- `RN-HOME-05`: Acoes de descoberta (busca/categoria/oferta/produto) devem ser rastreaveis para analise de funil.

### Criterios de aceite (alto nivel)
- `CA-HOME-01`: Dado que existe endereco selecionado, quando a Home carrega, entao o cabecalho mostra o endereco atual.
- `CA-HOME-02`: Dado que o usuario toca no endereco, quando a acao e executada, entao o app abre Selecao de Endereco.
- `CA-HOME-03`: Dado que o usuario toca no atalho de busca, quando a acao e executada, entao o app abre Busca.
- `CA-HOME-04`: Dado que existem ofertas da semana, quando a Home carrega, entao cards de oferta aparecem em lista horizontal.
- `CA-HOME-05`: Dado que o usuario toca em `Ver tudo` ou em um card de oferta, entao o app abre tela de categorias/listagem.
- `CA-HOME-06`: Dado que existem categorias habilitadas, quando a Home carrega, entao atalhos de categoria sao exibidos.
- `CA-HOME-07`: Dado que existem produtos da vitrine da Home, quando a tela carrega, entao o grid mostra cards com preco e informacoes principais.
- `CA-HOME-08`: Dado que o usuario toca no card de produto, quando a acao e executada, entao o app abre Detalhes do Produto.
- `CA-HOME-09`: Dado que o usuario toca em uma aba da barra inferior diferente da ativa, quando a acao e executada, entao ocorre navegacao para a rota correspondente.
- `CA-HOME-10`: Dado que o usuario toca na aba ativa (`Inicio`), quando a acao e executada, entao nenhuma navegacao adicional e disparada.

### Observacoes de aderencia ao codigo atual
- A estrutura principal da Home ja esta implementada (cabecalho, busca, ofertas, categorias, grid e bottom nav).
- Os dados estao vindo de `MercadoSeedData` (mock local), sem backend real.
- O selo `EXPIRA EM 12H` esta fixo em UI (sem contagem dinamica).
- O botao `+` no card de produto ainda nao dispara inclusao real no carrinho.
- O badge da `Cesta` na barra inferior esta fixo em `1` (nao dinamico).
- As categorias na Home estao em scroll horizontal; validar com Produto se o comportamento final sera esse ou grid.

---

## Requisitos nao funcionais transversais (MVP)
- `RNF-01`: Tempo de abertura inicial do app aceitavel em dispositivos medianos.
- `RNF-02`: Interface responsiva para larguras comuns de smartphone.
- `RNF-03`: Acessibilidade basica (alvos de toque adequados e contraste minimo).
- `RNF-04`: Navegacao sem quebra de fluxo (rotas existentes e consistentes).
- `RNF-05`: Persistencia local de estado de sessao (Hive) para onboarding, usuario e endereco.
- `RNF-06`: Scroll da Home deve permanecer fluido com secoes horizontais e grid na mesma tela.
- `RNF-07`: Conteudo inicial da Home deve carregar sem bloqueio perceptivel.

## Dependencias tecnicas ja identificadas
- Navegacao por rotas nomeadas (`AppRoutes`).
- Persistencia local com Hive (estrutura ja presente em `lib/model/hive`).
- Integracoes futuras:
  - autenticacao real (email/telefone e social),
  - geolocalizacao e geocodificacao,
  - servico de enderecos do usuario.

## Lacunas para proxima iteracao
1. Conectar estado real de onboarding (`onboardingConcluido`) na escolha da tela inicial.
2. Implementar validacao e estado de erro no login.
3. Definir fluxo real de cadastro (dados minimos, politicas e consentimentos).
4. Implementar selecao persistente de endereco com atualizacao da sessao.
5. Integrar permissao de localizacao e fallback manual.
6. Conectar Home a estado real (provider/viewmodel) para dados dinamicos.
7. Implementar acao real de adicionar item ao carrinho pela Home.
8. Tornar contador de tempo da oferta e badge da cesta dinamicos.
9. Definir comportamento final de categorias na Home (scroll horizontal vs grid).
10. Incluir estados de carregamento, vazio e erro para ofertas/produtos.
