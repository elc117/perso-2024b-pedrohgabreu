# Gerenciador de Tarefas - Serviço Web com Haskell e Scotty

## Identificação

- **Nome**: Pedro Henrique Abreu - 202320534
- **Curso**: Sistemas de Informação

## Tema / Objetivo

Este projeto tem como objetivo a implementação de um serviço web simples de **gerenciamento de listas de tarefas** utilizando a linguagem **Haskell** e o microframework **Scotty**. O serviço permitirá que os usuários possam **criar**, **listar**, **atualizar** e **remover** tarefas, com persistência dos dados em um arquivo local, garantindo que as informações sejam salvas mesmo após o fechamento do servidor.

### Funcionalidades:

1. **Adicionar tarefas**: O usuário pode enviar uma requisição POST para criar novas tarefas.
2. **Listar tarefas**: As tarefas existentes podem ser visualizadas através de uma requisição GET.
3. **Persistência em arquivo**: Todas as tarefas são salvas em um arquivo txt local no pc do usuário, garantindo que as informações sejam persistentes.

### Escopo do Projeto:

Este projeto segue uma abordagem **incremental**. A primeira etapa foca na representação e manipulação de uma única tarefa e o armazenamento de dados em arquivo. Posteriormente, o serviço foi expandido para gerenciar uma lista de tarefas com endpoints RESTful através do **Scotty**.

### Requisitos:

- **Haskell** (versão mínima recomendada: 8.10.7)
- **GHC** e **Cabal**
- Biblioteca **Scotty**
- Biblioteca **Aeson** para manipulação de JSON

### Estrutura do Código:

O projeto é estruturado em um único arquivo Haskell, contendo as seguintes partes:

1. **Definição de dados**: A estrutura `Task` é definida com campos para o ID da tarefa, sua descrição e seu status de conclusão.
2. **Funções de persistência**: Funções para leitura e gravação de dados em um arquivo txt.
3. **Endpoints do serviço web**:
   - `GET /tasks`: Retorna a lista de tarefas.
   - `POST /tasks`: Adiciona uma nova tarefa.

### Como executar o projeto:

1. **Faça o download dos arquivos Main.hs e todolist.cabal**
2. **Execute em qualquer interpretador (cmd ou PowerShell no Windows) utilizando o comando `cabal build` e depois `cabal run`**
3. **Assim que o servidor local estiver aberto, utilize os comandos `GET` ou `POST` para manipular a lista de tarefas.**

   **Obs.: Garanta que o Cabal está devidamente atualizado e funcionando.**
   
