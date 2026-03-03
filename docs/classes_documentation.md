# Documentação das Classes do Projeto

## Escopo

Esta documentação cobre todas as classes e enums encontradas no repositório em `lib/`, `android/` e `ios/` na data desta análise.

Inventário atual:

- 18 classes
- 1 enum
- 4 funções auxiliares relevantes fora de classes (`main`, `_formatPrice`, `_emojiForVisualKey`, `_visualsForSource`)

## Visão Geral da Arquitetura

O projeto está concentrado em uma vitrine de produtos da home e segue uma separação simples entre apresentação, estado e dados:

1. `main()` inicializa o Hive e sobe a aplicação.
2. `MercadoFacilApp` configura o `MaterialApp`.
3. `HomeScreen` cria e injeta `HomeProductsViewModel` com `Provider`.
4. `HomeProductsViewModel` decide se os produtos vêm de `LocalFakeProductsRepository` ou `HiveFakeProductsRepository`.
5. Ambos os repositórios entregam `HomeProduct`, que é o modelo consumido pela UI.
6. A tela renderiza a grade de cards e muda o visual conforme a fonte escolhida.

## Mapa Rápido

| Elemento | Arquivo | Papel |
| --- | --- | --- |
| `MercadoFacilApp` | `lib/main.dart` | Raiz da aplicação Flutter |
| `AppRoutes` | `lib/app_routes.dart` | Catálogo de rotas nomeadas |
| `HomeProduct` | `lib/model/home_product.dart` | Modelo de domínio da home |
| `LocalFakeProductsRepository` | `lib/repository/local_fake_products_repository.dart` | Fonte estática em memória |
| `HiveFakeProductsRepository` | `lib/repository/hive_fake_products_repository.dart` | Fonte persistida em Hive |
| `HomeProductsSource` | `lib/viewmodel/home_products_viewmodel.dart` | Enum de seleção da fonte |
| `HomeProductsViewModel` | `lib/viewmodel/home_products_viewmodel.dart` | Estado e orquestração da home |
| `AppTheme` | `lib/ui/theme/app_theme.dart` | Tema visual global |
| `HomeScreen` | `lib/ui/screens/home_screen.dart` | Tela pública da home |
| `_HomeScreenView` | `lib/ui/screens/home_screen.dart` | Corpo privado da tela |
| `_HomeSourceSwitcher` | `lib/ui/screens/home_screen.dart` | Seletor de fonte local/Hive |
| `_ProductsGrid` | `lib/ui/screens/home_screen.dart` | Grid responsivo de produtos |
| `_EmptyProductsState` | `lib/ui/screens/home_screen.dart` | Estado vazio |
| `_ProductCard` | `lib/ui/screens/home_screen.dart` | Card individual de produto |
| `_ProductImage` | `lib/ui/screens/home_screen.dart` | Bloco visual do produto |
| `_SourceVisuals` | `lib/ui/screens/home_screen.dart` | Value object privado para tema por fonte |
| `MainActivity` | `android/app/src/main/kotlin/.../MainActivity.kt` | Entry point Android |
| `AppDelegate` | `ios/Runner/AppDelegate.swift` | Entry point iOS |
| `RunnerTests` | `ios/RunnerTests/RunnerTests.swift` | Classe base de testes iOS |

## Convenções Importantes

- Classes com prefixo `_` são privadas ao arquivo em Dart.
- Os repositórios do projeto são utilitários estáticos com construtor privado, não instâncias injetáveis.
- A home atual depende de `Provider` e `ChangeNotifier`, sem camada de casos de uso intermediária.
- O `README.md` principal descreve um app maior, mas o código presente neste repositório hoje está focado na home de produtos e na troca entre fonte local e Hive.

## Documentação por Classe

## `MercadoFacilApp`

Arquivo: `lib/main.dart`

### Responsabilidade

Classe raiz da aplicação Flutter. É ela que entrega o `MaterialApp` configurado com título, tema e tela inicial.

### Como participa do fluxo

- É instanciada em `main()` após `HiveFakeProductsRepository.initialize()`.
- Define `HomeScreen` como `home`.
- Centraliza a ligação entre infraestrutura inicializada e UI.

### Dependências diretas

- `AppTheme.lightTheme()`
- `HomeScreen`
- `MaterialApp`

### API pública

- `const MercadoFacilApp({super.key})`

### Observações

- Ainda não usa `routes`, `onGenerateRoute` ou `AppRoutes`.
- O bootstrap do armazenamento fica fora da classe, em `main()`, o que mantém `MercadoFacilApp` puramente visual.

## `AppRoutes`

Arquivo: `lib/app_routes.dart`

### Responsabilidade

Classe utilitária que centraliza nomes de rotas como constantes estáticas.

### Conteúdo atual

- `index`
- `onboarding`
- `login`
- `address`
- `home`
- `search`
- `categories`
- `product`
- `cart`
- `checkout`
- `confirmed`

### Observações

- No estado atual do código, essas rotas não estão conectadas ao `MaterialApp`.
- A classe funciona como catálogo de navegação planejada ou legado de uma estrutura maior do app.

## `HomeProduct`

Arquivo: `lib/model/home_product.dart`

### Responsabilidade

Modelo de domínio da tela de produtos. Representa exatamente o que a UI precisa para renderizar um item da grade.

### Propriedades

- `name`: nome exibido ao usuário
- `details`: complemento curto como peso ou volume
- `price`: preço já formatado para exibição
- `emoji`: ícone visual simplificado do produto
- `imageLabel`: selo textual dentro da arte do card
- `imageColors`: cores usadas no gradiente da imagem

### Como é construído

- Pelo construtor `const`, quando os dados já estão prontos
- Pela factory `HomeProduct.fromRepositoryMap`, quando os dados vêm do Hive em formato de mapa

### Regras internas relevantes

- `fromRepositoryMap` converte `imageColorHexes` em `List<Color>`.
- `priceCents` é transformado em string com `_formatPrice`.
- `visualKey` é convertido para emoji com `_emojiForVisualKey`.
- Quando um campo está ausente, a classe aplica fallbacks seguros como `"Produto"` e `"Sem detalhes"`.

### Dependências diretas

- `Color` de Flutter

### Usado por

- `LocalFakeProductsRepository`
- `HiveFakeProductsRepository`
- `HomeProductsViewModel`
- Widgets de `home_screen.dart`

### Observações

- O preço fica armazenado como string pronta para UI. Isso simplifica a renderização, mas reduz flexibilidade para cálculos monetários futuros.
- A classe é imutável na prática, porque todos os campos são `final`.

## `LocalFakeProductsRepository`

Arquivo: `lib/repository/local_fake_products_repository.dart`

### Responsabilidade

Fornece uma lista estática de `HomeProduct` inteiramente em memória, sem persistência e sem transformação adicional.

### Estrutura

- Construtor privado: impede instanciação
- `_products`: lista constante com seed visual da home
- `getProducts()`: retorna os produtos locais

### Papel na arquitetura

- É a fonte mais simples do projeto.
- Serve como baseline visual imediata para a tela.
- Também funciona como fallback conceitual caso o Hive esteja vazio ou não seja a fonte selecionada.

### Dependências diretas

- `HomeProduct`
- `Color`

### Observações

- `getProducts()` retorna a própria lista estática, não uma cópia defensiva.
- Como os itens já são `const`, esse repositório é muito barato em custo de execução.
- Não há filtros, paginação, busca nem mutações.

## `HiveFakeProductsRepository`

Arquivo: `lib/repository/hive_fake_products_repository.dart`

### Responsabilidade

Encapsula a persistência local em Hive para um catálogo fake de produtos, além de expor operações de leitura, seed, escrita e remoção.

### Responsabilidades específicas

- Inicializar o Hive com `initialize()`
- Abrir a box `fake_products_box`
- Popular a base quando necessário com `seedIfNeeded()`
- Recriar todo o seed com `reseed()`
- Entregar lista ordenada com `getProducts()`
- Buscar item específico com `getProductById()`
- Salvar produto arbitrário com `saveProduct()`
- Excluir produto por id com `deleteProduct()`
- Expor um `ValueListenable` da box para a camada de estado

### Estrutura de dados

Cada produto salvo no Hive é um `Map<String, Object>` com campos como:

- `id`
- `sortOrder`
- `name`
- `details`
- `priceCents`
- `visualKey`
- `imageLabel`
- `imageColorHexes`
- `type`

Além dos produtos, existe um registro de metadados em `_metaKey` para armazenar `seedVersion` e `updatedAt`.

### Regras de lifecycle

- `initialize()` precisa rodar antes de qualquer acesso à box.
- O getter `_box` lança `StateError` se a inicialização não ocorreu.
- `_initialized` evita trabalho repetido dentro do mesmo processo.

### Regras de sincronização com UI

- `listenable()` devolve `_box.listenable()`.
- Isso permite que `HomeProductsViewModel` reaja a mudanças no Hive sem polling manual.

### Regras de seed

- `_seedVersion` controla invalidação do catálogo fake.
- Se a versão salva for diferente da versão atual, `seedIfNeeded()` chama `reseed()`.
- `reseed()` apaga todo o conteúdo da box e grava novamente o seed padrão.

### Conversão para domínio

- `getProducts()` filtra entradas com `type == 'product'`.
- Em seguida ordena por `sortOrder`.
- Por fim converte cada item para `HomeProduct` com `HomeProduct.fromRepositoryMap`.

### Observações

- É uma classe de infraestrutura com interface estática; não existe abstração formal de repositório no código atual.
- `saveProduct()` normaliza o campo `type` para `product`, mesmo que o mapa de entrada não contenha esse valor.
- O seed é suficientemente rico para testes de UI, mas continua sendo um mock local.

## `HomeProductsSource`

Arquivo: `lib/viewmodel/home_products_viewmodel.dart`

### Responsabilidade

Enum que representa a origem dos produtos exibidos na home.

### Valores

- `local`
- `hiveRepository`

### Papel prático

- Controla a decisão do `HomeProductsViewModel`
- Controla o estado do `SegmentedButton`
- Controla o esquema visual aplicado por `_visualsForSource`

## `HomeProductsViewModel`

Arquivo: `lib/viewmodel/home_products_viewmodel.dart`

### Responsabilidade

Classe de estado da home. Ela seleciona a fonte ativa, mantém a lista corrente de produtos e notifica a UI quando algo muda.

### Responsabilidades específicas

- Armazenar a fonte selecionada em `_selectedSource`
- Expor os produtos correntes por `products`
- Resolver a fonte correta em `_resolveProducts()`
- Reagir a alterações do Hive quando a fonte ativa é `hiveRepository`
- Gerenciar o listener do Hive durante o ciclo de vida da tela

### Lifecycle

1. O construtor recebe `initialSource`.
2. Registra `_handleRepositoryChanged` no `ValueListenable` do Hive.
3. Carrega a lista inicial com `_resolveProducts()`.
4. Quando a tela é destruída, `dispose()` remove o listener.

### Dependências diretas

- `ChangeNotifier`
- `ValueListenable<Box<Map>>`
- `HiveFakeProductsRepository`
- `LocalFakeProductsRepository`
- `HomeProduct`

### Regras de atualização

- `selectSource()` troca a fonte apenas se houver mudança real.
- Ao mudar a fonte, atualiza `_products` e chama `notifyListeners()`.
- `_handleRepositoryChanged()` ignora eventos quando a fonte atual é local.

### Observações

- A classe está bem focada e hoje não mistura regras de negócio extras.
- Ela pressupõe que o Hive já foi inicializado antes da criação do view model.
- Como a seleção de fonte está dentro do view model, a UI permanece declarativa e sem lógica de dados.

## `AppTheme`

Arquivo: `lib/ui/theme/app_theme.dart`

### Responsabilidade

Centraliza a configuração visual global da aplicação.

### O que define

- `ColorScheme` gerado a partir de `seedColor`
- tipografia com `GoogleFonts.nunitoSans`
- `scaffoldBackgroundColor`
- comportamento visual sem splash
- `AppBarTheme` transparente

### API pública

- `static ThemeData lightTheme()`

### Dependências diretas

- `ThemeData`
- `ColorScheme`
- `GoogleFonts`

### Observações

- O método atual expõe apenas tema claro.
- A classe está montada como utilitário estático, o que é adequado ao porte atual do projeto.
- A escolha tipográfica impacta diretamente o visual do catálogo e dos cards.

## `HomeScreen`

Arquivo: `lib/ui/screens/home_screen.dart`

### Responsabilidade

Tela pública da home. É a fronteira entre navegação e árvore interna da página.

### Responsabilidades específicas

- Receber parâmetros de configuração externos
- Criar `HomeProductsViewModel`
- Injetar o view model via `ChangeNotifierProvider`
- Delegar a composição visual para `_HomeScreenView`

### Parâmetros

- `initialSource`: fonte inicial dos produtos
- `showSourceSwitcher`: define se o seletor local/Hive deve aparecer

### Observações

- A tela é reutilizável porque aceita fonte inicial e permite esconder o seletor.
- O provider é criado localmente, então o escopo do estado fica restrito à própria tela.

## `_HomeScreenView`

Arquivo: `lib/ui/screens/home_screen.dart`

### Responsabilidade

Implementa a composição principal da home já assumindo que o provider existe acima na árvore.

### O que faz

- Observa `selectedSource` com `Selector`
- Calcula visuais da tela com `_visualsForSource`
- Monta o fundo com `AnimatedContainer`
- Exibe `_HomeSourceSwitcher` quando habilitado
- Observa `products` com outro `Selector`
- Entrega os dados para `_ProductsGrid`

### Motivações de implementação

- O uso de `Selector` reduz rebuilds desnecessários.
- A separação em relação a `HomeScreen` evita que a lógica de provider se misture à composição visual.

### Observações

- É uma classe privada por ser detalhe interno desta tela.
- Depende fortemente do contrato do `HomeProductsViewModel`.

## `_HomeSourceSwitcher`

Arquivo: `lib/ui/screens/home_screen.dart`

### Responsabilidade

Renderiza o cabeçalho da página com título, explicação da fonte de dados e o controle de troca entre `Local` e `Hive`.

### Entradas

- `selectedSource`
- `visuals`
- `onChanged`

### O que comunica para o usuário

- Qual fonte está ativa no momento
- Qual identidade visual representa essa fonte
- Como alternar entre as duas opções

### Observações

- O widget não conhece o view model diretamente; ele trabalha por parâmetros.
- Isso mantém o componente mais previsível e mais fácil de reaproveitar.

## `_ProductsGrid`

Arquivo: `lib/ui/screens/home_screen.dart`

### Responsabilidade

Exibir os produtos em grid responsivo.

### Regras de layout

- 4 colunas em telas com largura a partir de 900
- 3 colunas a partir de 580
- 2 colunas abaixo disso

### Comportamento

- Se a lista estiver vazia, mostra `_EmptyProductsState`
- Caso contrário, usa `GridView.builder`
- Calcula `itemExtent` dinamicamente a partir da largura disponível

### Observações

- É o widget que concentra a responsividade da tela.
- O cálculo de tamanho é simples e adequado ao caso atual, mas pode exigir revisão se o card ganhar mais conteúdo vertical.

## `_EmptyProductsState`

Arquivo: `lib/ui/screens/home_screen.dart`

### Responsabilidade

Mostrar o estado vazio da home quando não existe nenhum produto a renderizar.

### Mensagem funcional

- Informa que não há produtos
- Sugere verificar seed do Hive ou trocar para a fonte local

### Observações

- O texto do estado vazio está alinhado ao comportamento real do `HomeProductsViewModel`.
- É um componente pequeno, mas importante para experiência de falha amigável.

## `_ProductCard`

Arquivo: `lib/ui/screens/home_screen.dart`

### Responsabilidade

Renderizar um produto dentro da grade, com nome, detalhes, arte e preço.

### Estrutura visual

- Área superior quadrada com `_ProductImage`
- Nome do produto
- Detalhes do produto
- Preço destacado em verde

### Dependências diretas

- `HomeProduct`
- `_ProductImage`

### Observações

- O widget usa `LayoutBuilder` para ajustar a dimensão da arte ao espaço disponível.
- É um card puramente visual; não há clique, navegação ou ação de carrinho nesta versão.

## `_ProductImage`

Arquivo: `lib/ui/screens/home_screen.dart`

### Responsabilidade

Desenhar a parte “hero” do card com gradiente, selo e emoji.

### O que compõe

- Gradiente baseado em `product.imageColors`
- Círculos decorativos semânticos
- Selo textual com `imageLabel`
- Emoji central com destaque

### Observações

- A classe abstrai toda a parte artística do card e deixa `_ProductCard` mais simples.
- O design atual substitui imagens reais por composição visual leve e rápida.

## `_SourceVisuals`

Arquivo: `lib/ui/screens/home_screen.dart`

### Responsabilidade

Pequeno objeto imutável que agrupa configurações visuais associadas a uma fonte de produtos.

### Campos

- `label`
- `icon`
- `backgroundColor`
- `accentColor`

### Papel no arquivo

- Serve de retorno para `_visualsForSource`
- Evita espalhar vários `switches` de cor e ícone pela UI

### Observações

- Apesar de privada, é uma boa abstração local porque elimina parâmetros soltos e melhora legibilidade.

## `MainActivity`

Arquivo: `android/app/src/main/kotlin/com/u2m/app_mercadofacil/MainActivity.kt`

### Responsabilidade

Classe de entrada nativa do Android.

### Papel real no projeto

- Estende `FlutterActivity`
- Usa a integração padrão do Flutter embedding no Android

### Observações

- Não possui customizações nativas no momento.
- Existe principalmente para que o app Android tenha um entry point compatível com o Flutter.

## `AppDelegate`

Arquivo: `ios/Runner/AppDelegate.swift`

### Responsabilidade

Classe de entrada nativa do app iOS.

### O que faz

- Estende `FlutterAppDelegate`
- Registra plugins com `GeneratedPluginRegistrant.register(with: self)`
- Delega o restante do fluxo para a implementação padrão

### Observações

- Não há comportamento iOS customizado além do bootstrap padrão.
- Se o projeto passar a usar integrações nativas, este é um ponto provável de extensão.

## `RunnerTests`

Arquivo: `ios/RunnerTests/RunnerTests.swift`

### Responsabilidade

Classe base de testes nativos iOS usando `XCTestCase`.

### Estado atual

- Contém apenas o método template `testExample()`
- Ainda não valida comportamento real do app

### Observações

- Funciona como placeholder padrão gerado pelo template do Flutter para iOS.
- Pode ser expandida caso o projeto precise testar integrações nativas.

## Elementos Auxiliares Fora de Classes

Embora o pedido esteja focado em classes, existem quatro pontos auxiliares que influenciam diretamente o comportamento do sistema:

### `main()`

Arquivo: `lib/main.dart`

- Garante binding do Flutter
- Inicializa `HiveFakeProductsRepository`
- Executa `runApp`

### `_formatPrice(int cents)`

Arquivo: `lib/model/home_product.dart`

- Converte centavos em string no formato `R$ 0,00`
- É usado por `HomeProduct.fromRepositoryMap`

### `_emojiForVisualKey(String? visualKey)`

Arquivo: `lib/model/home_product.dart`

- Traduz uma chave semântica do repositório para um emoji de apresentação
- Mantém a UI desacoplada do dado bruto vindo do Hive

### `_visualsForSource(HomeProductsSource source)`

Arquivo: `lib/ui/screens/home_screen.dart`

- Traduz a fonte ativa em um `_SourceVisuals`
- Controla cores, label e ícone da tela

## Relações Entre as Classes

### Fluxo principal

`main()` -> `HiveFakeProductsRepository.initialize()` -> `MercadoFacilApp` -> `HomeScreen` -> `HomeProductsViewModel` -> (`LocalFakeProductsRepository` ou `HiveFakeProductsRepository`) -> `HomeProduct` -> widgets privados da home

### Relações de dependência mais importantes

- `HomeProductsViewModel` é o centro de orquestração da tela.
- `HomeScreen` depende do view model, mas os widgets privados dependem apenas do estado exposto por ele.
- `HomeProduct` é o contrato comum entre as fontes de dados e a UI.
- `HiveFakeProductsRepository` é a única classe com responsabilidade de persistência real.

## Limites Atuais do Desenho

- As classes de repositório são estáticas, então substituição por mocks ou fontes remotas ainda exigirá refatoração.
- `AppRoutes` está definido, mas ainda não integrado ao fluxo real de navegação.
- O modelo `HomeProduct` é voltado para apresentação e não para regras de negócio complexas.
- A tela principal está bem modularizada visualmente, mas toda a UI da home ainda mora em um único arquivo.

## Resumo Executivo

O projeto tem uma base pequena e bem delimitada. O centro do comportamento está em quatro pontos:

- `HiveFakeProductsRepository`, como camada de persistência fake
- `HomeProductsViewModel`, como orquestrador de estado
- `HomeProduct`, como contrato de dados consumido pela UI
- `HomeScreen` e seus widgets privados, como camada de apresentação

Isso torna o código atual fácil de entender, bom para evolução incremental e adequado para experimentação visual de catálogo.
