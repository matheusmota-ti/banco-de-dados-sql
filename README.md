# Solve It With SQL — Aplicativo Oracle APEX

Projeto baseado no material **“Solve It With SQL — Lição 5: Resolvendo-o com um Aplicativo APEX”**. O objetivo é montar no Oracle APEX uma aplicação para consultar e administrar suspeitos, crimes e gangues, pesquisar suspeitos, visualizar estatísticas e armazenar imagens.

> **Importante:** este repositório contém os scripts SQL, os arquivos de imagem fornecidos e um roteiro de configuração. O aplicativo APEX em si precisa ser criado/importado dentro de um workspace Oracle APEX conectado ao banco que contém as tabelas da atividade. Não é possível gerar uma exportação `.sql` completa do aplicativo sem acesso a esse workspace.

## Funcionalidades previstas

- Relatórios interativos de suspeitos, crimes e gangues, com formulários para inserir/editar registros.
- Armazenamento de imagens de suspeitos na coluna `IMAGE` (BLOB).
- Pesquisa facetada de suspeitos com os dados da gangue, inclusive quando o suspeito não tem gangue associada.
- Painel de estatísticas de crimes.
- Botão para navegar do relatório de crimes para as estatísticas.

## Estrutura do repositório

```text
solve-it-with-apex/
├── README.md
├── sql/
│   ├── 01_adicionar_coluna_image.sql
│   ├── 02_consulta_search_suspects.sql
│   ├── 03_estatistica_crimes_por_suspeito.sql
│   ├── 04_estatistica_populacao_prisional.sql
│   └── 05_estatistica_crimes_por_tipo.sql
└── assets/
    └── SWSW_Images/
        └── (imagens de suspeitos fornecidas no material)
```

## Pré-requisitos

1. Um workspace Oracle APEX e acesso ao SQL Workshop / App Builder.
2. O banco usado nas lições anteriores, com as tabelas `SUSPECTS`, `CRIMES` e `GANGS` já criadas e preenchidas.
3. Permissão para alterar a tabela `SUSPECTS`.

Este material **não recria** as tabelas-base, pois o roteiro pressupõe que elas já existem no banco das lições anteriores.

## 1. Preparar a tabela de suspeitos

No APEX, abra **SQL Workshop → SQL Commands** e execute o script `sql/01_adicionar_coluna_image.sql`. Ele adiciona a coluna BLOB usada para armazenar as fotos.

Se a coluna `IMAGE` já existir, não execute o `ALTER TABLE` novamente. Para conferir a estrutura, use:

```sql
SELECT column_name, data_type
FROM user_tab_columns
WHERE table_name = 'SUSPECTS'
ORDER BY column_id;
```

## 2. Criar o aplicativo

No **App Builder → Create → Use Create App Wizard**, crie as páginas abaixo. Para os relatórios, selecione **Interactive Report** e marque **Include Form**.

| Página | Nome | Tabela/origem | Configuração |
|---|---|---|---|
| Home | `Suspect Report` | `SUSPECTS` | Interactive Report + Form; definir como Home Page |
| 2 | `Crime Report` | `CRIMES` | Interactive Report + Form |
| 3 | `Gang Report` | `GANGS` | Interactive Report + Form |

Remova a página inicial em branco padrão, se o assistente a criar. Os nomes das tabelas e colunas devem corresponder aos objetos já existentes no seu workspace.

## 3. Criar a pesquisa facetada

Crie uma página do tipo **Faceted Search**, com nome `Search Suspects` (página 7, conforme o material). Configure a origem como **SQL Query** e use o conteúdo de `sql/02_consulta_search_suspects.sql`.

- Breadcrumb: ligado; página pai `Suspect Report`.
- Navegação: desligada.
- A consulta usa junção externa para preservar suspeitos sem gangue.

## 4. Criar o painel de estatísticas

Crie a página **Dashboard** chamada `Crime Statistics` (página 8, conforme o material), com layout **Primary and 2 secondary charts**.

- Breadcrumb: ligado; página pai `Crime Report`.
- Navegação: desligada.
- No gráfico principal, use a consulta de `sql/03_estatistica_crimes_por_suspeito.sql`, título `Crimes by Criminal`, barras empilhadas.
- No segundo gráfico, use `sql/04_estatistica_populacao_prisional.sql`, título `Prison Population over Time`.
- No terceiro gráfico, use `sql/05_estatistica_crimes_por_tipo.sql`, título `Crimes over Time`.

Configure os mapeamentos de colunas conforme o roteiro:
- Gráfico principal: série `CRIME_TYPE`, rótulo `Suspect`, valor `COUNT(CRIME_TYPE)`.
- Segundo gráfico: rótulo `PRISON`, valor `COUNT(PRISON)`.
- Terceiro gráfico: rótulo `CRIME_TYPE`, valor `COUNT(CRIME_TYPE)`.

Na página `Crime Report`, adicione um botão com nome `CrimeStatisticsBtn`, rótulo `Crime Statistics`, que navegue para a página `Crime Statistics`.

## 5. Carregar as imagens

Os arquivos estão em `assets/SWSW_Images/`. Os nomes incluem o ID e o nome do suspeito (por exemplo, `56 Addison Palmer.png`).

1. Abra `Suspect Report` e pesquise o sobrenome do suspeito.
2. Edite a linha correspondente e faça upload do arquivo de imagem no campo `IMAGE`.
3. Em Page Designer, selecione a coluna `IMAGE` e configure **Identification → Type → Display Image**.
4. Salve e execute a página. Repita para os arquivos que correspondem a registros presentes na tabela.

O arquivo da imagem precisa corresponder ao ID/nome do registro. Não carregue uma imagem em um registro diferente.

## 6. Validar a aplicação

- [ ] Os relatórios de suspeitos, crimes e gangues abrem.
- [ ] Os formulários permitem inserir/editar registros conforme as permissões do banco.
- [ ] A pesquisa retorna suspeitos com e sem gangue associada.
- [ ] O botão `Crime Statistics` abre o painel.
- [ ] Os três gráficos exibem dados.
- [ ] As imagens carregadas aparecem no relatório de suspeitos.

## Observações

- Os nomes de colunas e as consultas foram transcritos do material fornecido. Caso o esquema do seu banco use nomes diferentes, confira a estrutura das tabelas antes de executar.
- O script de criação da coluna não é idempotente: execute-o apenas uma vez.
- Os arquivos de imagem são fornecidos para uso no exercício. Carregue somente imagens que correspondam aos registros do seu banco.
