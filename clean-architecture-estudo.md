# Clean Architecture — Estudo completo (guia prático)

> Objetivo: entender **Clean Architecture do zero**, aplicar em projetos **Flutter/Dart**, e conseguir evoluir (ex: Hive → Firebase) sem “quebrar” o app.

---

## 1) O que é Clean Architecture (a ideia central)

Clean Architecture é um jeito de organizar o projeto para:

- **Separar regras de negócio** de detalhes (UI, banco, API).
- **Trocar tecnologia sem refatorar tudo** (ex: sair de Hive e ir pra Firebase).
- **Testar fácil** (principalmente regras e casos de uso).
- **Reduzir acoplamento** e bagunça conforme o app cresce.

### Regra principal: regra da dependência

> **Dependências sempre apontam para dentro** (para o “núcleo” do sistema).  
> UI depende do domínio — **nunca** o contrário.  
> Firebase/HTTP/Hive dependem do seu domínio — **nunca** o domínio dessas libs.

---

## 2) As camadas (na prática)

Uma divisão que funciona muito bem em Flutter:

### 2.1) Presentation (UI)
- Widgets, páginas, controllers/viewmodels/blocs/cubits/notifiers.
- Orquestra a tela: recebe input do usuário, chama casos de uso, renderiza estados.
- **Não sabe** como os dados são obtidos (API? local? cache?).

Exemplos:
- `HomePage`, `ProductsPage`
- `ProductsController`, `ProductsNotifier`, `ProductsCubit`

---

### 2.2) Application (Use Cases)
- Onde moram os **casos de uso**: “Listar produtos”, “Adicionar ao carrinho”, “Fazer login”.
- Contém regras de fluxo e validações de aplicação.
- Depende do **Domínio** e de **interfaces** (contratos), como `ProductRepository`.

Exemplos:
- `GetProducts`
- `AddToCart`
- `LoginUser`

---

### 2.3) Domain (o núcleo)
A parte mais importante. Aqui ficam:

- **Entidades** (regras de negócio puras)
- **Value Objects** (ex: `Email` válido, `Money`)
- **Regras / políticas** do seu sistema
- **Interfaces** (contratos) que descrevem o que o app precisa (ex: `ProductRepository`)

O domínio **não pode** depender de Flutter, HTTP, Firebase, Hive, etc.

Exemplos:
- `Product`, `Cart`, `User`
- `Money`, `EmailAddress`
- `ProductRepository` (interface)

---

### 2.4) Data / Infrastructure (detalhes)
- Implementações reais: HTTP, Firebase, Hive, SQLite.
- Models DTO, mappers, datasources.
- Implementa interfaces definidas no domínio/application.

Exemplos:
- `ProductRepositoryImpl`
- `ProductRemoteDataSource`
- `HiveCartLocalDataSource`
- `ProductDto`

---

## 3) Fluxo completo de uma feature (exemplo mental)

**Usuário abre a Home → lista produtos**

1. UI chama `GetProductsUseCase()`
2. Use case chama `ProductRepository.getAll()`
3. `ProductRepositoryImpl` decide buscar no remote/local/cache
4. DataSource chama API / banco
5. Mapeia `ProductDto` → `Product` (entidade do domínio)
6. Volta pro use case → UI
7. UI renderiza o estado

✅ A UI nunca sabe se veio do Firebase, API, cache, etc.

---

## 4) 4 pilares para dominar de verdade

### 4.1) Entity vs Model (DTO)
- **Entity**: regra de negócio, usada pelo domínio.
- **Model/DTO**: formato de dados vindo de fora (API, Firebase, Hive).

Ex:
- `Product` (domain entity)
- `ProductDto` (data model, JSON)

> Se amanhã a API mudar, você mexe no **DTO/mappers**, não nas regras do app.

---

### 4.2) Repository como contrato (interface)
No domínio (ou application) você define:
- “O que eu preciso” (interface)
- E no data/infrastructure você implementa “como eu faço”

Isso te dá **troca de implementação** (Hive → Firebase) sem refatorar a UI inteira.

---

### 4.3) Use Cases = ações do seu app
Cada caso de uso responde: **qual ação o usuário quer fazer?**

- `AddProduct`
- `RemoveItemFromCart`
- `GetCartTotal`

Use case chama repositório e aplica regra.

---

### 4.4) Dependency Injection (injeção de dependência)
Clean Architecture usa DI para montar o grafo:

- UI recebe `GetProducts`
- `GetProducts` recebe `ProductRepository`
- `ProductRepositoryImpl` recebe `RemoteDataSource`, `LocalDataSource`

Em Flutter:
- `get_it`
- `riverpod`
- `provider` (com factories)

---

## 5) Estrutura de pastas recomendada (Flutter)

Um padrão por **feature**:

```text
lib/
  core/
    errors/
    utils/
    network/
  features/
    products/
      presentation/
        pages/
        controllers/   # ou cubit/bloc/notifier
        widgets/
      application/
        usecases/
      domain/
        entities/
        repositories/
        value_objects/
      data/
        datasources/
        models/
        repositories/
```

Dica: app pequeno pode simplificar, mas mantenha o conceito.

---

## 6) Tratamento de erros do jeito “clean”

Evite deixar exception “vazar” para a UI.

Padrão comum:
- Data layer lança exceptions específicas (ex: `ServerException`)
- Repository converte para **Failure** (ex: `ServerFailure`)
- Use case retorna `Either<Failure, T>` (ou um `Result<T>` próprio)

Em Flutter:
- `dartz` (Either)
- ou `Result<T>` simples (muitas vezes melhor no início)

---

## 7) Regras de ouro (para não virar “arquitetura de pasta”)

1. **Domínio não depende de nada externo.**
2. **Use case não importa Flutter.**
3. **DTO não “vaza” para UI.**
4. **Repository é o “portão” entre regras e dados.**
5. **Organize por feature** (evita “mega pasta” global).

---

## 8) Exemplo mini: mapa de uma feature (sem código)

Feature: `products`

- **Domain**
  - `Product`
  - `ProductRepository` (interface)
- **Application**
  - `GetProducts`
- **Data**
  - `ProductDto`
  - `ProductRemoteDataSource`
  - `ProductRepositoryImpl`
- **Presentation**
  - `ProductsPage`
  - `ProductsController` / `ProductsNotifier`

---

## 9) Roteiro para aprender “por completo” (na prática)

Siga esta sequência (você domina rápido):

1) Escolha 1 feature (ex: **listar produtos**) e desenhe o fluxo.  
2) Crie entidades + contrato do repositório.  
3) Crie 1 use case.  
4) Implemente repository + datasource (**fake/local primeiro**).  
5) Ligue na UI com Provider/ChangeNotifier.  
6) Faça 2 testes:
   - teste do **use case**
   - teste do **repository** (mockando datasource)

---

## 10) Próximo passo (se você quiser)
Se você pedir, eu monto um **esqueleto completo em Flutter** para o seu app Grocery, com:

- entities + DTO + mapper
- repository interface + impl
- use case
- provider/notifier
- DI com `get_it`
- testes básicos
