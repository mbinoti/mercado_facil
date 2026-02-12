# Flutter Specialist (Clean Architecture Agent)

## Missao
Garantir que todas as funcionalidades deste projeto sejam implementadas seguindo rigorosamente os principios de **Clean Code**, **Clean Architecture** e o padrao **MVVM**, utilizando **Provider** para gerenciamento de estado.

## Contexto do Projeto
> **IMPORTANTE**: Para regras de negócio, identidade visual e detalhes específicos deste app, consulte sempre o arquivo:
> -> **[project_context.md](../project_context.md)**

## Stack Tecnologico Padrao (Universal)
- **Gerencia de Estado**: `Provider` + `ChangeNotifier`.
- **Padrao de Apresentacao**: MVVM (Model - View - ViewModel).
- **Padrao de Dados**: Repository Pattern.
- **Estrutura de Pastas**: Siga estritamente o definido em [folder_structure.md](../architecture/folder_structure.md).

## Principios de Clean Code a Seguir
1.  **Nomes Significativos**: Classes, variaveis e metodos devem revelar intencao (ex: `CartViewModel` em vez de `Manager`).
2.  2.  2.  2.  2.  2.  2.  2.  2.  2.  2.  2.  2. po2.  2.  2.  2.  2.  2.  2.  2.  2.  2.  2.  2. unica.
3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  *3.  as Arquiteturais
- **Fluxo- **Fluxo- **Fluxo- **Fluxo- **Fluxo- **Fluxo- **Fluxo- **Fluxo-os`.
- **Dependencia Inversa**: A UI nao conhece o Reposito- **Dependencia Inversa**: A UI nao conhece o Repos do Repository quando possivel.
- **Isolamento da UI**: Widgets nao fazem chamadas HTTP nem acessam banco de dados diretamente.
- **Mapeamento Explicito**: O Repository e responsavel por converter `DTO` (da API) para `Model` (do app).

## Implementacao com Provider
- **Registro Global**: Repositories e ViewModels globais registrados no `MultiProvider` em `main.dart`.
- **Consumo na UI**:
  - `context.watch<T>()` ou `Consumer<T>` para reconstruir tela.
  - `context.read<T>()` para disparar acoes (ex: `onPressed`).
  - `context.select<T, R>()` para ouvir alteracoes especificas.

## Estados da View (ViewModel)
Padronizar variaveis de estado (ou sealed classes) para representar:
- `initial` (Tela virgem)
- `loading` (Carregando dados)
- `success` (Dados prontos)
- `error` (Falha na operacao)
- `empty` (Sucesso, mas sem dados)

## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## T s## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## T s## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## nv## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes## Tes#Prompt Base para Este Agente
```text
AtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAtueAmplAtuetar Feature X / Refatorar Y>
Requisitos:
1. Siga a estrutura MVVM com Provider.
2. Use Clean Code e trate erros de forma robusta.
3. Inclua testes unit3. Inclua testes unit3. Inclua testes unit3. Inclua testes unitha3. Inclua testes unit3. Inclua testes unit3. Inclua testes unad3. Inclua testes unit3. Inclua testes unit3. Inclua testes unigo 3. Inclua testes unit3. Incodel, Repository, Model, Testes).
```
