# Estrutura de Pastas

Estrutura recomendada seguindo o guia MVVM + Provider (Clean Code).

```text
lib/
  dto/         # Modelos de transferencia (JSON/DB -> App)
  model/       # Modelos de dominio (usados na UI/ViewModel/Repository)
  repository/  # Acesso a dados e conversao DTO <-> Model
  viewmodel/   # Gerenciamento de estado (ChangeNotifier)
  ui/          # Camada de apresentacao
    screens/   # Telas compeltas
    widgets/   # Componentes reutilizaveis
    theme/     # Estilos e temas
  main.dart    # Setup do MultiProvider
```

## Regras de Responsabilidade

### 1. `ui/` (Presentation)
- Contem `screens/`, `widgets/` e `theme/`.
- Focada apenas em desenhar a interface e capturar eventos.
- **Nao** contem regras de negocio.
- **Nao** chama APIs diretamente.
- Ouve o `ViewModel` para se atualizar.

### 2. `viewmodel/` (Presentation Logic)
- Classes que estendem `ChangeNotifier`.
- Guarda o estado da tela (loading, success, error).
- Expoe metodos - Expoe metodos - Expoe metodos - Expoe metodos - Ea - Expoe metodos - Exbus- Expoe metodos - Expoe metodos - Expoe metodos - Expoe metodos - vel- Expo# 3. `r- Expoe metodos - Expoe metodos - Expoe metodos - Expoe dos- Expoe metodos - Expoe metodos - Expoe metodos - Expoe metodos -  e converte para `Model`.
- Garante que o restante do app so con- Garante que o restante do app so con- Garante que o rela- Garante que o restante do app so cona da API ou banco.
- Responsavel po- Responsavel po- Responsavel po- Respon**U- Responsavel po- Respons`repository`. A UI nao deve ver DTOs.

### 5. `model/` (Domain Models)
- Classes pur- Classes pur- Classes pucio- Classes pur- Classes pur- Classes pucio-`, `Repository`).
- Preferencialmente imutaveis.

## Fluxo de Dados
1. UI chama metodo no `ViewModel` (ex: `userViewModel.login()`).
2. `ViewModel` chama `Repository` (ex: `authRepository.login()`).
3. `Repository`3. `Repository`3. `Repositoonverte em `DTO`.
4. `Repository` converte `DTO` para `Model` e devolve.
5. `ViewModel` recebe `Model`, atualiza estado e notifica UI (`notifyListeners`).
6. UI se reconstroi com os novos dados.
