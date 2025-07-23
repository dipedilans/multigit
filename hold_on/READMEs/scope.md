
### Gerir várias identidades GitHub num único Mac – com um só comando

> **Gerir várias identidades GitHub num único Mac — com um só comando**


*Multigit* é um **script wrapper em Bash 3.2** que simplifica o uso de várias contas GitHub num mesmo computador macOS, capaz de:

- alternar instantaneamente entre contas, criar repositórios prontos‑a‑usar e manter a configuração Git/SSH sempre correcta.

- **Adicionar** quantas contas quiseres (identidade Git + host SSH + token GH CLI);

- Gerar e configurar **chaves SSH** por cada conta;

- manter a identidade **Git** (`user.name`/`user.email`) sempre correcta;

- criar ou actualizar o **remote origin** adequado;

- orquestrar chamadas ao **GitHub CLI** para criar repositórios, alternar sessões;

* **Criar novos projectos** já com *remote* e identidades correctas.

* **Migrar projectos existentes** de uma conta para outra em segundos.

* **Trocar de identidade** dentro de qualquer repositório activo.

* Operar por **linha de comandos** ou através de um **menu interactivo** que se adapta ao contexto (dentro / fora de um repositório Git).

- e muito mais


## Características Técnicas

- Escrito em Bash 3.2 para compatibilidade com macOS
- Dependências: git, gh (GitHub CLI), jq
- Detecção automática de contexto (dentro/fora de repositório Git)
- Suporte a múltiplos hosts SSH para diferentes contas
- Verificações de segurança e validação de entrada


O projeto está focado em simplificar a gestão de múltiplas identidades GitHub no macOS, permitindo alternar facilmente entre contas diferentes sem comprometer a segurança ou a organização do trabalho.



> Testado em macOS 14 (Sonoma) com Git 2.45, GitHub CLI 2.44, Bash 3.2 e `jq` 1.6.


![macOS](https://img.shields.io/badge/macos-12%2B-lightgrey?logo=apple\&logoColor=white)

![GitHub release](https://img.shields.io/github/v/release/diogocostasilva/multigit?label=version)

![License](https://img.shields.io/github/license/diogocostasilva/multigit)

  

---

  

## --- 🗂️ Conteúdo do repositório / Estrutura do Projeto

| Ficheiro             | Para quê?                                                                                                                                                     |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `multigit.sh`        | Script CLI para `add`, `list`, `new`, `switch` (Git/SSH). Script Bash 3.2 com menu interativo e subcomandos para gerir múltiplas contas GitHub num único Mac. |
| `ssh-config.example` | Aliases/keys de exemplo para `~/.ssh/config`.                                                                                                                 |
| `README.md`          | Guia passo-a-passo da pré-configuração (SSH, GH CLI, variáveis de ambiente) e da instalação/uso do script.                                                    |
| `LICENSE`            | MIT License.                                                                                                                                                  |

---

## Índice

- [✨ Funcionalidades](#-funcionalidades)
9. [Estrutura do projecto](#estrutura-do-projecto)
- [⚙️ Pré-requisitos](#️-pré-requisitos)
1. [Requisitos](#requisitos)
- [📥 Instalação](#-instalação)
2. [Instalação rápida](#instalação-rápida)
- [🔑 Configuração](#-configuração)
3. [Pré‑configuração detalhada](#pré-configuração-detalhada)
- [🚀 Comandos](#-comandos)
1. [Registar contas](#registar-contas)
2. [Fluxos de Trabalho](#fluxos-de-trabalho)
- [1 · Criar projecto de raiz](#1--criar-projecto-de-raiz)
- [2 · Migrar projecto existente para outra conta](#2--migrar-projecto-existente-para-outra-conta)
- [3 · Listar repositórios de uma conta](#3--listar-repositórios-de-uma-conta)
10. [Referência de comandos](#referência-de-comandos)
- [💡 Workflows](#-workflows)
1. [Workflows do dia‑a‑dia](#workflows-do-dia-a-dia)
- [📱 Menu Interactivo](#-menu-interactivo)
1. [Menu interactivo](#menu-interactivo)
- [⚙️ Configuração Avançada](#️-configuração-avançada)
2. [Configuração avançada](#configuração-avançada)
- [🔧 Personalização](#-personalização)
- [❓ FAQ & Solução de Problemas](#-faq--solução-de-problemas)
11. [FAQ & solução de problemas](#faq--solução-de-problemas)
- [🗺️ Roadmap](#️-roadmap)
6. [Roadmap](#roadmap)
- [🤝 Contribuir](#-contribuir)
7. [Contribuir](#contribuir)
- [📄 Licença](#-licença)
8. [Licença](#licença)

---
---

  

## ✨ Funcionalidades

### 1. Gestão de Contas GitHub

- **Adicionar contas**: Registrar múltiplas contas GitHub com aliases personalizados

- **Listar contas**: Visualizar todas as contas configuradas com seus respectivos usernames e emails
  
- **Listar repositórios**: Mostrar todos os repositórios disponíveis para uma conta específica


### 2. Gestão de Identidade Git

- **Trocar identidade**: Alternar entre diferentes identidades Git (nome de usuário e email) num repositório

- **Configuração automática**: Configurar automaticamente user.name e user.email ao criar ou migrar projetos


### 3. Gestão de Repositórios

- **Criar novos projetos**: Inicializar um novo repositório Git com a identidade correta

- **Migrar projetos existentes**: Mudar a identidade e remote URL de projetos já existentes

- **Configurar remote URL**: Definir automaticamente a URL remota com o host SSH correto


### 4. Interface de Utilizador

- **Menu interativo**: Interface de terminal para acesso fácil às funcionalidades com diferentes opções dependendo se está dentro ou fora de um repositório Git

- **Modo CLI**: Acesso direto às funcionalidades via linha de comando com subcomandos


### 5. Configuração e Personalização

- **Armazenamento de configuração**: Salvar contas em `~/.config/multigit/accounts`

- **Diretorias raiz por conta**: Opção para definir diretórios específicos para cada conta (ROOT_alias)





- **Alternância instantânea** entre qualquer número de contas GitHub (`multigit switch <alias>`)

- **Criação de projectos** local + remoto num único passo (`multigit new`)

- **Menu interactivo** adaptado ao contexto (dentro/fora de repositório Git)

- **100% SSH** – nunca precisas de digitar palavra-passe

- **Compatível** com qualquer shell (zsh, fish, etc.)

- **Gestão automática** de identidades Git e remotes

* **Adicionar contas ilimitadas** (`multigit add`).

* Gerar & associar **chaves SSH** exclusivas.

* Manter `user.name` / `user.email` consistentes.

* Criar repositórios via **GitHub CLI** & ajustar remote.

* **Criar novos projectos** já com tudo configurado.

* **Migrar repositórios existentes** para outra conta em segundos.

* **Trocar identidade** dentro de qualquer repo activo.

* CLI directa **ou** menu interactivo contextual.

---