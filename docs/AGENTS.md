# AGENTES - app_mercadofacil

Este documento centraliza os agentes de trabalho para o projeto Flutter.
Use este arquivo como ponto de entrada e abra o arquivo do agente escolhido antes de executar uma tarefa.

## Objetivo

Padronizar como cada tarefa e feita para reduzir retrabalho, manter consistencia tecnica e acelerar entregas.

## Catalogo de agentes

| Agente | Arquivo | Quando usar | Saida esperada |
| --- | --- | --- | --- |
| Especialista Flutter | `docs/agents/flutter-specialist.md` | Implementacao diaria de UI, widgets, navegacao, refatoracao e correcoes | Codigo funcional, testes minimos, checklist tecnico |
| Agente de UI e Animacao para Flutter | `docs/agents/flutter-ui-motion-agent.md` | Criacao ou refinamento de telas com maior qualidade visual, hierarquia forte e animacoes intencionais | Tela mais polida, direcao visual clara, animacao coerente e checklist visual |
| Agente de Testes Flutter | `docs/agents/flutter-test-agent.md` | Criacao de testes unitarios, testes de widget, regressao e validacao de fluxos criticos | Suite de testes alinhada ao risco, comandos executados e lacunas restantes |
| Agente de Modelagem NoSQL Firebase | `docs/agents/firebase-nosql-model-agent.md` | Modelagem de documentos, DTOs, serializacao e evolucao de esquema para Firebase/Firestore | Esquema definido, mapeamentos claros, riscos de consulta e compatibilidade listados |
| Agente de Modelagem Hive | `docs/agents/hive-model-agent.md` | Modelagem de persistencia local com Hive, boxes, chaves, payloads e migracao/seed | Contrato local estavel, serializacao definida, estrategia de versionamento e testes minimos |
| Agente de Estrategia de Produto para Delivery | `docs/agents/delivery-product-strategy-agent.md` | Decisoes de produto e negocio para app de delivery, priorizacao de features, corte de escopo e avaliacao do que deve ou nao deve existir | Recomendacao objetiva, prioridades, riscos operacionais e metricas |
| Agente de Arquitetura Limpa Flutter | `docs/agents/flutter-clean-architecture-agent.md` | Definicao de arquitetura, organizacao de pastas, separacao de camadas e migracao estrutural | Estrutura proposta, regras claras de dependencia, plano de migracao |

## Fluxo recomendado

1. Escolher o agente pelo tipo de tarefa.
2. Validar contexto de produto em `docs/project-context.md` antes de implementar features.
3. Validar contexto tecnico em `docs/README.md`.
4. Para mudancas estruturais, seguir `docs/folder_structure.md`.
5. Executar implementacao e fechar com checklist do agente.

## Regras comuns para qualquer agente

- Preservar simplicidade e legibilidade.
- Evitar acoplamento entre UI e logica de negocio.
- Preferir mudancas pequenas e incrementais.
- Sempre listar riscos tecnicos antes de grandes refatoracoes.
- Garantir que o codigo compile e que `flutter analyze` nao introduza novos erros.

## UI / Produto

- Para features de produto, consultar `docs/project-context.md` antes de codar.
- Para tarefas de telas, fluxos e componentes do app, consulte a documentacao funcional disponivel em `docs/` como contexto base.
- Se existir especificacao detalhada da feature (ex.: `docs/analise-requisitos.md` com requisitos, criterios de aceite e lacunas), consultar esse arquivo antes de codar e usar como referencia detalhada da entrega.
- Preservar a ordem e intencao dos fluxos descritos nesse arquivo.
- Se houver divergencia entre codigo e documento, sinalizar e propor atualizacao.

## Proximos agentes sugeridos

- Agente de Estado (Riverpod/Bloc) com padroes de uso.
- Agente de API/Data para contratos DTO, mapeamento e tratamento de erros alem de Firebase/Hive.
