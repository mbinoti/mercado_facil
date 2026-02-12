# Arquitetura - app_mercadofacil

Este guia define a direcao arquitetural do projeto e serve de referencia para os agentes em `docs/agents`.

## Estado atual (snapshot)

- UI concentrada em `lib/screens` e `lib/widgets`.
- Ja existem diretorios para evolucao arquitetural: `lib/dto`, `lib/model`, `lib/repository`, `lib/viewmodel`.
- Ainda nao ha padrao unico aplicado de ponta a ponta.

## Direcao arquitetural

Adotar organizacao por feature com camadas claras:

- `presentation`: telas, widgets de feature, controllers/viewmodels.
- `domain`: entities, use cases, contracts de repository.
- `data`: dto/models, mappers, data sources, implementacoes de repository.

## Regras de dependencia

- `presentation` pode depender de `domain`.
- `data` pode depender de `domain`.
- `domain` nao depende de `presentation` nem de `data`.
- Implementacoes concretas ficam em `data`; contracts ficam em `domain`.

## Estrutura recomendada

Ver estrutura detalhada em `docs/architecture/folder_structure.md`.

## Estrategia de migracao incremental

1. Escolher uma feature de baixo risco.
2. Extrair entidades e casos de uso para `domain`.
3. Criar contrato de repository no `domain`.
4. Implementar repository e data source no `data`.
5. Adaptar tela/viewmodel no `presentation`.
6. Repetir para proxima feature.

## Criterios de pronto arquitetural

- Nova feature segue as regras de dependencia.
- Nenhuma regra de negocio critica fica em `Widget`.
- Mapeamentos DTO -> Entity estao explicitos.
- Erros de data source sao traduzidos para modelo de erro de dominio.
