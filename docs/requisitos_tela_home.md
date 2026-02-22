# Requisitos da Tela Home (Pagina Inicial)

## Objetivo
Ser a central de descoberta de produtos e ofertas do app, com acesso rapido a busca, categorias, vitrine de ofertas e navegacao persistente.

## Referencias de implementacao atual
- `lib/ui/screens/home_screen.dart`
- `lib/ui/widgets/app_bottom_nav.dart`
- `lib/model/hive/mercado_seed_data.dart`
- `lib/app_routes.dart`

## Escopo funcional da Home
1. Cabecalho de entrega com endereco atual.
2. Atalho de busca de produtos/marcas.
3. Carrossel horizontal de ofertas da semana.
4. Atalhos de categorias.
5. Grade de produtos em oferta do dia.
6. Barra de navegacao inferior persistente.

---

## Requisitos funcionais
- `RF-HOME-01`: Exibir endereco de entrega selecionado no cabecalho.
- `RF-HOME-02`: Permitir trocar endereco tocando no cabecalho e navegar para Selecao de Endereco.
- `RF-HOME-03`: Exibir atalho de busca com navegacao para tela de busca.
- `RF-HOME-04`: Exibir secao `Ofertas da Semana` em lista horizontal com CTA `Ver tudo`.
- `RF-HOME-05`: Permitir abrir listagem/categorias ao tocar em `Ver tudo` ou em um card de oferta.
- `RF-HOME-06`: Exibir atalhos de categorias com scroll horizontal.
- `RF-HOME-07`: Exibir secao `Ofertas do dia` com indicador de tempo (`EXPIRA EM ...`).
- `RF-HOME-08`: Exibir produtos em grid de 2 colunas com nome, preco, preco antigo e badge promocional (quando houver).
- `RF-HOME-09`: Permitir abrir detalhes do produto ao tocar no card de produto.
- `RF-HOME-10`: Exibir acao de adicionar item no card de produto (icone `+`).
- `RF-HOME-11`: Exibir barra inferior com 5 abas (`Inicio`, `Buscar`, `Cesta`, `Pedidos`, `Perfil`).
- `RF-HOME-12`: Manter destaque visual da aba ativa (`Inicio`) e navegar para rotas das demais abas.

## Regras de negocio
- `RN-HOME-01`: A Home deve usar o endereco selecionado na sessao para contextualizar entrega.
- `RN-HOME-02`: Conteudos de ofertas e produtos da Home devem respeitar ordenacao/recorte definido para vitrine.
- `RN-HOME-03`: Produtos indisponiveis (quando existirem) devem impedir acao de adicionar ao carrinho.
- `RN-HOME-04`: Navegacao inferior deve manter consistencia de rotas e nao duplicar tela ativa.
- `RN-HOME-05`: Acoes de descoberta (busca/categoria/oferta/produto) devem ser rastreaveis para analise de funil (requisito analitico).

## Criterios de aceite (alto nivel)
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

---

## Requisitos nao funcionais (Home)
- `RNF-HOME-01`: Scroll deve permanecer fluido com secoes horizontais + grid na mesma tela.
- `RNF-HOME-02`: Layout deve funcionar em diferentes tamanhos de smartphone sem overflow.
- `RNF-HOME-03`: Componentes clicaveis devem ter area de toque adequada.
- `RNF-HOME-04`: Conteudo inicial da Home deve carregar sem bloqueio perceptivel para o usuario.

## Observacoes de aderencia ao codigo atual
- A estrutura principal da Home ja esta implementada (cabecalho, busca, ofertas, categorias, grid e bottom nav).
- Os dados estao vindo de `MercadoSeedData` (mock local), sem backend real.
- O selo `EXPIRA EM 12H` esta fixo em UI (sem contagem dinamica).
- O botao `+` no card de produto ainda nao dispara inclusao real no carrinho.
- O badge da `Cesta` na barra inferior esta fixo em `1` (nao dinamico).
- A secao de categorias na Home esta em scroll horizontal; o resumo original menciona grid de categorias.

## Lacunas para proxima iteracao
1. Conectar Home a estado real (provider/viewmodel) para dados dinamicos.
2. Implementar acao real de adicionar item ao carrinho pela Home.
3. Tornar contador de tempo da oferta e badge da cesta dinamicos.
4. Definir comportamento de categoria na Home (scroll horizontal vs grid) conforme requisito final de produto.
5. Incluir estados de carregamento, vazio e erro para ofertas/produtos.
