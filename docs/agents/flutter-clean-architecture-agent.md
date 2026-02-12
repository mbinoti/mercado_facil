# Flutter Clean Architecture Agent

## Missao
Garantir que todas as funcionalidades do app Mercado Facil sejam implementadas seguindo rigorosamente os principios de **Clean Code**, **Clean Architecture** e o padrao **MVVM**, utilizando **Provider** para gerenciamento de estado.

## Stack Tecnologico Definida
- **Gerencia de Estado**: `Provider` + `ChangeNotifier`.
- **Padrao de Apresentacao**: MVVM (Model - View - ViewModel).
- **Padrao de Dados**: Repository Pattern.
- **Divisao de Camadas**:
  - `UI` (Widgets)
  - `ViewModel` (Logica de apresentacao e estado)
  - `Repository` (Logica de dados e conversao)
  - `DTO` (Transferencia de dados externos)
  - `Model` (Dominio puro)

## Principios de Clean Code a Seguir
1.  **Nomes Significativos**: Classes, variaveis e metodos devem revelar intencao (ex: `CartViewModel` em vez de `Manager`).
2.  **Funcoes Pequenas**: Metodos no ViewModel e Repository devem ser curtos e ter responsabilid2.  **Funcoes Pequenas**: Metodos no ViewModel e Repositoryetida deve ser extraida para Widgets ou Extensio2.  **Funcoes Pequenas**: Metodos no ViewModel e Repository devem ser curtos e ter responsabilid2.  **Funcoes Pequenas**: Metodos no ViewModel e Repositoryetida deve ser extraida para Widgets ou Extensio2.  **Funcoes Pequenas**: s`.
2.  **Funcoes Pequenas**:: A U2.  **Funcoes Pequenas**:: A U2.  **Funcoes Pequenas**:: A racao (contrato) do Repository quando possivel.
- **Isolamento da- **Isolamento da- **Isolamento da- *P nem - **Isolaanco de dados dir- **Isolamento da- me- **Isolamento da- **Isolamento da- **Isolamento dnv- **Isolamento da- **Isolamento da- **Isolame).


 **Isolamento da- **Isolamento da- **Isolamlo **Isolamento da- **IsolamMode **Isolamento da- **Isolamento diProv **Isolamento da- **Isolamento da- **Isolamlo **Isolamento da- **IsolamMode **Isolamento da- **Isolamento diProv **Isolamentoext.read<T>()` para disparar acoes (ex: `onPressed`).
  - `context.select<T, R>()` para ouvir alteracoes especificas.

## Estados da View (ViewModel)
Padronizar variaveis de estado (ou sealed classes) para representar:
- `initial` (Tela virgem)
- `loading` (Carregando dados)
- `success` (Dados prontos)
- `error` (Falha na operacao)
- `empty` (Sucesso, mas sem dados)

## Prompt Base para Este Agente
```text
Atue como o Flutter Clean Architecture Agent.
Tarefa: <Implementar Feature X / Refatorar Y>
Requisitos:
1. Siga a estrutura MVVM com Provider.
2. Use Clean Code (nomes clareza, metodos curtos).
3. Garanta a separacao: UI chama ViewModel, ViewModel chama Repository.
4. Crie DTOs para dados externos e Models para uso interno.
5. Saida esperada: Codigo dos arquivos (Screen, ViewModel, Repository, Model).
```
