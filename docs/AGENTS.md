# AGENTS - app_mercadofacil

Este documento centraliza os agentes de trabalho para o projeto Flutter.
Use este arquivo como ponto de entrada e abra o arquivo do agente escolhido antes de executar uma tarefa.

## Objetivo

Padronizar como cada tarefa e feita para reduzir retrabalho, manter consistencia tecnica e acelerar entregas.

## Catalogo de agentes

| Agent | Arquivo | Quando usar | Saida esperada |
| --- | --- | --- | --- |
| Flutter Specialist | `docs/agents/flutter-specialist.md` | Implementacao diaria de UI, widgets, navegacao, refactor e correcoes | Codigo funcional, testes minimos, checklist tecnico |
| Flutter Clean Architecture Agent | `docs/agents/flutter-clean-architecture-agent.md` | Definicao de arquitetura, organizacao de pastas, separacao de camadas e migracao estrutural | Estrutura proposta, regras claras de dependencia, plano de migracao |

## Fluxo recomendado

1. Escolher o agente pelo tipo de tarefa.
2. Validar contexto tecnico em `docs/architecture/README.md`.
3. Para mudancas estruturais, seguir `docs/architecture/folder_structure.md`.
4. Executar implementacao e fechar com checklist do agente.

## Regras comuns para qualquer agente

- Preservar simplicidade e legibilidade.
- Evitar acoplamento entre UI e logica de negocio.
- Preferir mudancas pequenas e incrementais.
- Sempre listar riscos tecnicos antes de grandes refactors.
- Garantir que o codigo compile e que `flutter analyze` nao introduza novos erros.

## Proximos agentes sugeridos

- Agent de Testes Flutter (widget, golden e integracao).
- Agent de Estado (Riverpod/Bloc) com padroes de uso.
- Agent de API/Data para contratos DTO, mapeamento e tratamento de erros.
