# Estrutura de Pastas

Este documento define uma organizacao recomendada para projetos Flutter com:

- MVVM
- Provider
- Repository Pattern
- Clean Code

O objetivo da estrutura e separar responsabilidades com clareza, reduzir acoplamento e facilitar evolucao, testes e manutencao.

## Visao Geral

```text
lib/
  core/
    constants/
    errors/
    services/
    utils/
  dto/
  model/
  mapper/
  datasource/
    local/
    remote/
  repository/
  viewmodel/
  ui/
    screens/
    widgets/
    theme/
    platform/
  app_routes.dart
  main.dart

assets/
  images/
  icons/
  fonts/

test/
  dto/
  mapper/
  repository/
  viewmodel/
  ui/
    screens/
    widgets/

docs/
  project-context.md
  folder_structure.md
```

## Principios da Estrutura

### 1. Dependencias apontam para dentro

O fluxo esperado e:

`View -> ViewModel -> Repository -> DataSource`

Quando houver `Mapper`, ele entra como apoio de conversao entre `DTO` e `Model`.

### 2. Cada camada tem uma unica responsabilidade principal

- `ui/` renderiza a interface e captura interacoes
- `viewmodel/` controla estado e orquestra a tela
- `repository/` centraliza o acesso a dados
- `datasource/` fala com API, banco ou armazenamento local
- `dto/` representa dados crus
- `model/` representa o dominio da aplicacao

### 3. Nem toda pasta precisa nascer no dia zero

Projetos pequenos podem comecar com:

```text
lib/
  dto/
  model/
  repository/
  viewmodel/
  ui/
  main.dart
```

Conforme a complexidade cresce, extraia `mapper/`, `datasource/` e `core/`.

## Explicacao Pasta por Pasta

### `lib/`

Raiz do codigo fonte da aplicacao.

Tudo que faz parte do app em tempo de execucao deve partir daqui: bootstrap, UI, modelos, estado e acesso a dados.

### `lib/main.dart`

Ponto de entrada da aplicacao.

Responsabilidades:

- inicializar bindings do Flutter
- preparar dependencias globais
- executar bootstrap de servicos locais/remotos
- registrar `Provider`s globais
- subir o widget raiz com `runApp`

Nao deve concentrar regra de negocio. Se o bootstrap crescer, mova detalhes de inicializacao para `core/services/` ou arquivos dedicados.

### `lib/app_routes.dart`

Catalogo central de rotas nomeadas.

Responsabilidades:

- evitar strings soltas espalhadas pelo projeto
- padronizar nomes de rotas
- facilitar manutencao de navegacao

Se o app usar roteamento declarativo mais avancado, o arquivo pode evoluir para uma configuracao maior, mas a ideia continua sendo centralizar rotas.

### `lib/core/`

Infraestrutura compartilhada e utilitarios globais.

Subpastas sugeridas:

- `constants/`: chaves, tamanhos, defaults, nomes de colecoes, endpoints
- `errors/`: excecoes, falhas, classes de erro do app
- `services/`: servicos transversais, como logging, analytics, storage wrapper, http client
- `utils/`: helpers pequenos e reutilizaveis

Use `core/` apenas para elementos compartilhados entre multiplas features. Nao coloque regra especifica de uma tela aqui.

### `lib/dto/`

Modelos de transferencia de dados.

Exemplos:

- resposta de API
- documento do Firestore
- payload salvo em Hive
- objetos de serializacao JSON

Responsabilidades:

- representar a estrutura crua da fonte de dados
- serializar e desserializar
- lidar com nomes de campos externos

Nao deve:

- conhecer `BuildContext`
- conter regra de negocio de UI
- ser usado diretamente pela camada de apresentacao

Exemplo de nomes:

- `product_dto.dart`
- `order_response_dto.dart`
- `cart_item_hive_dto.dart`

### `lib/model/`

Modelos de dominio da aplicacao.

Aqui ficam as entidades que o app realmente usa para trabalhar.

Exemplos:

- `HomeProduct`
- `Order`
- `CartItem`

Responsabilidades:

- representar informacoes do negocio
- servir de contrato entre `repository`, `viewmodel` e `ui`
- manter semantica clara para o app

Boas praticas:

- preferir modelos imutaveis quando possivel
- evitar dependencias de infraestrutura
- manter nomes orientados ao negocio

`model/` nao deve carregar preocupacoes de JSON, banco ou plataforma.

### `lib/mapper/`

Camada responsavel por conversoes entre formatos.

Responsabilidades:

- converter `DTO -> Model`
- converter `Model -> DTO`, quando necessario
- isolar regras de transformacao simples

Exemplos:

- `product_mapper.dart`
- `order_mapper.dart`

Quando usar:

- quando o mapeamento comecar a crescer
- quando houver mais de uma fonte de dados para a mesma entidade
- quando voce quiser testes dedicados de conversao

Em projetos bem pequenos, o mapeamento pode ficar dentro do `Repository` no inicio. Quando isso comecar a ficar repetitivo ou confuso, extraia para `mapper/`.

### `lib/datasource/`

Camada que fala diretamente com a fonte de dados.

Subpastas sugeridas:

- `local/`: Hive, SharedPreferences, arquivos, cache, banco local
- `remote/`: REST, GraphQL, Firebase, SDKs externos

Responsabilidades:

- executar leitura e escrita na fonte
- retornar dados crus ou DTOs
- encapsular detalhes tecnicos de acesso

Nao deve:

- decidir regra de negocio
- expor estado de tela
- retornar widgets

Exemplos:

- `remote/products_remote_datasource.dart`
- `local/cart_local_datasource.dart`

### `lib/repository/`

Camada central de acesso a dados do app.

Responsabilidades:

- ser o ponto unico entre dominio e fontes de dados
- decidir estrategia de obtencao dos dados
- combinar fonte local e remota quando necessario
- tratar erros tecnicos e converte-los para algo compreensivel pelo app
- entregar `Model` para as camadas de cima

O `Repository` e a fronteira que impede `ViewModel` e `UI` de conhecerem detalhes de API, banco, Hive ou Firebase.

Exemplos de responsabilidades praticas:

- buscar do cache antes da API
- atualizar cache depois de resposta remota
- converter `DTO` em `Model`
- padronizar falhas

Nao deve:

- receber `BuildContext`
- depender de widget
- conter layout ou regras visuais

### `lib/viewmodel/`

Camada de estado e orquestracao da tela.

No padrao adotado pelo projeto, o default e `ChangeNotifier` com `Provider`.

Responsabilidades:

- expor estado da tela
- reagir a eventos do usuario
- chamar `Repository`
- decidir quando a UI deve atualizar
- padronizar estados como `initial`, `loading`, `success`, `empty` e `error`

Exemplo de conteudo de um `ViewModel`:

- `ViewState state`
- `String? errorMessage`
- `List<Product> items`
- `Future<void> load()`
- `Future<void> refresh()`
- `void addToCart()`

Nao deve:

- instanciar dependencias por conta propria
- acessar `DataSource` diretamente
- importar widgets
- carregar regra de renderizacao

### `lib/ui/`

Camada de apresentacao.

Aqui fica tudo que desenha interface e traduz estado em widgets.

Subpastas sugeridas:

- `screens/`: telas completas
- `widgets/`: componentes reutilizaveis
- `theme/`: tema, cores, tipografia, estilos
- `platform/`: adaptacoes entre Material e Cupertino, quando fizer sentido

#### `lib/ui/screens/`

Contem telas completas, normalmente uma por fluxo principal.

Exemplos:

- `home_screen.dart`
- `cart_screen.dart`
- `checkout_screen.dart`

Uma `screen` deve:

- compor widgets
- observar o `ViewModel`
- disparar acoes do usuario

Uma `screen` nao deve:

- chamar API
- ler Hive diretamente
- conhecer DTO
- centralizar regra de negocio

#### `lib/ui/widgets/`

Componentes reutilizaveis da interface.

Exemplos:

- botoes customizados
- cards de produto
- steppers de quantidade
- cabecalhos
- banners

Devem ser pequenos, legiveis e reutilizaveis.

#### `lib/ui/theme/`

Tudo que for configuracao visual global.

Exemplos:

- `ThemeData`
- `CupertinoThemeData`
- cores
- espacamentos
- tipografia

Essa pasta ajuda a evitar estilos hardcoded espalhados pelas telas.

#### `lib/ui/platform/`

Abstracoes especificas para diferencas entre plataformas.

Use quando o app precisa adaptar widgets, comportamento ou tema entre iOS e Android, mantendo a tela principal limpa.

## Estrutura de `assets/`

### `assets/images/`

Imagens raster ou ilustracoes exportadas.

### `assets/icons/`

Icones personalizados, SVGs e variacoes graficas pequenas.

### `assets/fonts/`

Fontes customizadas declaradas no `pubspec.yaml`.

Organizar `assets/` evita caminhos soltos e facilita manutencao visual.

## Estrutura de `test/`

Os testes devem espelhar a organizacao de `lib/` para facilitar navegacao.

### `test/dto/`

Testes de serializacao e desserializacao.

### `test/mapper/`

Testes de conversao entre formatos.

### `test/repository/`

Testes de estrategia de dados, transformacao de falhas e integracao entre fontes.

### `test/viewmodel/`

Testes de estado e fluxo de acoes.

Coberturas minimas recomendadas:

- sucesso
- erro
- vazio, quando aplicavel

### `test/ui/`

Widget tests para telas e componentes.

Coberturas minimas recomendadas:

- loading
- error
- success

## Estrutura de `docs/`

### `docs/project-context.md`

Contexto funcional do produto: objetivo, usuarios, regras e fluxos do app.

### `docs/folder_structure.md`

Este documento. Serve como referencia arquitetural de organizacao.

## Regras de Dependencia

As regras abaixo devem ser preservadas:

1. `ui/` pode depender de `viewmodel/`, `model/`, `theme/` e widgets compartilhados.
2. `viewmodel/` pode depender de `repository/` e `model/`.
3. `repository/` pode depender de `datasource/`, `dto/`, `mapper/`, `model/` e `core/`.
4. `datasource/` pode depender de `dto/` e `core/`.
5. `dto/` nao deve depender de `ui/`.
6. `model/` nao deve depender de `Flutter UI`.

## O Que Nao Misturar

- Widget com regra de negocio
- `ViewModel` acessando API ou Hive diretamente
- `UI` importando `DTO`
- `Repository` retornando dado cru de infraestrutura para a tela
- Helpers globais em excesso dentro de `core/`
- Arquivos genericos demais como `utils.dart`, `helpers.dart` ou `common.dart` sem criterio

## Como Evoluir a Estrutura Sem Exagero

### Projeto pequeno

Comece simples:

```text
lib/
  dto/
  model/
  repository/
  viewmodel/
  ui/
  main.dart
```

### Projeto medio

Extraia:

- `mapper/`
- `datasource/local/`
- `datasource/remote/`
- `core/errors/`

### Projeto grande

Adicione divisao interna por feature dentro das camadas, por exemplo:

```text
lib/
  repository/
    cart/
    home/
    orders/
  viewmodel/
    cart/
    home/
    orders/
  ui/
    screens/
      cart/
      home/
      orders/
```

Isso mantem o padrao por camadas sem perder organizacao por contexto funcional.

## Exemplo de Fluxo

Exemplo: usuario abre a Home.

1. `HomeScreen` chama `HomeProductsViewModel.load()`.
2. O `ViewModel` muda o estado para `loading`.
3. O `ViewModel` chama o `Repository`.
4. O `Repository` busca dados no `DataSource` local ou remoto.
5. O `Repository` converte `DTO` em `Model` com `Mapper` ou internamente.
6. O `Repository` devolve `Model` para o `ViewModel`.
7. O `ViewModel` atualiza `state`, `items` e chama `notifyListeners()`.
8. A `UI` reconstrui apenas o que precisa.

## Resumo

Essa estrutura existe para responder tres perguntas com clareza:

- onde cada tipo de codigo deve morar
- quem pode conversar com quem
- como o projeto cresce sem virar uma pasta unica de arquivos

Se houver duvida sobre onde colocar um arquivo novo, use a responsabilidade principal dele como criterio. Se ele mistura duas responsabilidades, normalmente o problema nao e a pasta; e o desenho do arquivo.
