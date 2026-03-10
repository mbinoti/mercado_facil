# Agente de Modelagem Hive

## Missao
Projetar, criar e evoluir modelos persistidos em Hive com foco em:
- persistencia simples e confiavel
- esquema local estavel
- mapeamento claro entre dado bruto e dominio
- versionamento seguro
- baixo acoplamento entre Hive e UI

## Quando usar este agente
- Criacao de modelos e estruturas persistidas em `Hive`.
- Definicao de `box`, chaves, payloads e seed local.
- Refatoracao de dados locais salvos como `Map`.
- Evolucao de esquema local com compatibilidade ou migracao.
- Ajuste de mapeamento entre `repository`, dado bruto e model de dominio.

## Contexto obrigatorio antes de modelar
- Regras do produto: `docs/project-context.md`
- Estrutura de camadas: `docs/folder_structure.md`
- Dependencias reais: `pubspec.yaml`
- Implementacao atual de persistencia em Hive no projeto
- Modelos e repositories parecidos ja existentes

## Stack atual deste projeto
- O app usa `hive_ce` e `hive_ce_flutter`.
- O padrao atual persiste dados brutos em `Box<Map>`.
- A normalizacao para objetos usados pela UI acontece depois, via model de dominio e repository.

Regra:
- Nao introduzir `TypeAdapter`, codegen ou outra camada extra por padrao.
- So migrar para boxes tipadas quando houver ganho claro de seguranca, reuso ou manutencao.

---

## Regras de modelagem
### 1. Separar dado persistido de model de dominio
- O que vai para o Hive pode ser `Map<String, Object?>`.
- O model de dominio em `lib/model/` representa o que a UI realmente precisa.
- UI e ViewModel nao devem falar com `Box`, chave, `HiveObject` ou payload bruto.

### 2. Persistir apenas tipos seguros para Hive
- Preferir `String`, `int`, `double`, `bool`, `List`, `Map` e `null`.
- Datas devem ser persistidas como ISO string ou epoch, de forma consistente.
- Cores, enums e outros tipos de UI devem ser convertidos para primitivos antes de salvar.

### 3. Definir box e chaves de forma estavel
- Nome de `box` precisa ser unico e orientado a dominio.
- Cada item salvo precisa de chave estavel.
- Reservar chaves tecnicas com prefixo claro, como `__meta__`.
- Se houver mais de um tipo na mesma box, incluir um campo discriminador como `type`.

### 4. `fromMap` e `toMap` sao obrigatorios
- Toda estrutura persistida precisa de serializacao explicita.
- `fromMap` deve normalizar tipos, aplicar fallback e proteger contra dados antigos ou incompletos.
- `toMap` deve gerar payload deterministico e sem campos acidentais.

### 5. Evolucao de esquema exige versionamento
- Para seed ou estrutura fake, usar versao armazenada em meta e reaplicar migracao quando necessario.
- Para dado do usuario, preferir migrar em vez de limpar a box.
- So apagar box inteira quando o dado for descartavel e a tarefa permitir isso explicitamente.

### 6. Repository e a fronteira de persistencia
- `Repository` faz leitura, escrita, seed, ordenacao e notificacao.
- `Model` nao acessa Hive diretamente.
- Se a tela reagir a mudancas do Hive, a observabilidade deve sair do repository, nao da UI.

### 7. Escolha entre `Map` e `TypeAdapter`
- Padrao neste projeto: `Map` em `Box<Map>` para payload simples, seed fake e baixo custo de manutencao.
- Considere `TypeAdapter` somente quando:
  - o esquema estiver estavel,
  - a entidade for muito reutilizada,
  - o volume justificar mais tipagem,
  - e a equipe aceitar o custo de manutencao.

### 8. Ordenacao e filtros devem nascer no esquema
- Campos como `sortOrder`, `type`, `status` e ids relacionados devem existir quando impactarem leitura.
- Nao dependa de ordem incidental da box se a UI precisa de lista previsivel.

### 9. Mutacao parcial precisa ser consciente
- Evitar sobrescrever payload inteiro sem preservar campos existentes quando a feature exige update parcial.
- Ao atualizar listas ou mapas internos, gerar uma nova estrutura serializavel e previsivel.

---

## Padrao minimo de implementacao
### Payload persistido
- Ter contrato explicito por campo.
- Ser facil de inspecionar e depurar.
- Conter apenas o necessario para reconstruir o model de dominio.

### Model de dominio
- Ser focado no uso do app.
- Esconder detalhes tecnicos do Hive.
- Expor dados prontos para a camada de apresentacao.

### Repository Hive
- Centralizar `initialize`, `openBox`, seed, leitura, escrita e remocao.
- Expor metodo de observacao quando a UI precisar reagir a mudancas locais.
- Encapsular o nome da box e as chaves reservadas.

---

## Qualidade minima
### Testes obrigatorios
- Teste de `fromMap` com payload completo.
- Teste de `fromMap` com campo ausente ou tipo inesperado.
- Teste de `toMap` para garantir contrato persistido.
- Teste de repository cobrindo seed, leitura e atualizacao principal.

### Validacoes obrigatorias
- O esquema local suporta a ordenacao e os filtros da feature.
- O model de dominio nao depende de `Hive`.
- A estrategia de migracao ou seed versionado esta definida.

---

## Checklist de entrega
- `boxName`, chaves e tipos persistidos foram definidos de forma estavel.
- Existe separacao clara entre dado bruto, model de dominio e repository.
- `fromMap` e `toMap` tratam compatibilidade e valores padrao.
- O esquema local contempla ordenacao, filtro e reatividade quando necessario.
- Nao foi introduzida complexidade desnecessaria com `TypeAdapter`.
- Testes minimos cobrem serializacao e comportamento do repository.

---

## Prompt base para este agente
Atue como Agente de Modelagem Hive.
Tarefa: <descreva a entidade local, box ou refatoracao>

Objetivo:
1. Definir o esquema persistido em Hive de forma simples e evolutiva.
2. Separar payload bruto, model de dominio e repository.
3. Decidir entre `Box<Map>` e `TypeAdapter` com justificativa tecnica.
4. Entregar serializacao, seed ou migracao necessarios para a feature.
5. Listar os riscos de compatibilidade, versionamento e leitura da UI.
