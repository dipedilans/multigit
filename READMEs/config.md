
## ⚙️ Pré‑requisitos

| Pacote     | Versão mínima | Instalação (Homebrew)  |
| ---------- | ------------- | ---------------------- |
| Git        | 2.35          | `brew install git`     |
| GitHub CLI | 2.40          | `brew install gh`      |
| jq         | 1.6           | `brew install jq`      |
| Bash       | 3.2 (macOS)   | *já vem com o sistema* |

### Instalar as dependências necessárias

#####  HomeBrew

```bash

# Homebrew (se ainda não tiveres)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```

##### git & github-cli

```bash

# Git + GitHub CLI
brew install git gh 

# garantir versão ≥ 2.40.0
brew upgrade gh

```


---

  

## 📥 Instalação


### Instalação via Curl

```bash

# Download do script
curl -o ~/bin/multigit.sh https://raw.githubusercontent.com/diogocostasilva/multigit/main/multigit.sh

curl -fsSL https://raw.githubusercontent.com/diogocostasilva/multigit/main/multigit.sh \
-o /usr/local/bin/multigit

# Tornar o ficheiro executável
chmod +x /usr/local/bin/multigit

# Adicionar ao PATH
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# (Opcional) Criar alias sem extensão
ln -s ~/bin/multigit.sh ~/bin/multigit 

# OU - Alias na shell:
echo "alias multigit='multigit.sh'" >> ~/.zshrc

# limpa o cache de localizações
hash -r


# No final verifica:
multigit --version # deve mostrar vX.Y.Z

```


### 🧹 Desinstalação

```bash

rm -f /usr/local/bin/multigit # ou ~/bin/multigit{,.sh}

hash -r # limpa cache de executáveis

```

  

---
---

  

## 🔑 4. Configuração do Sistema

### 4.1. Gerar/criar chaves SSH (uma por conta)

Antes de começar, certifique-se de que tem chaves SSH distintas para cada conta GitHub.

```bash

# Conta oficial - diogo-costa-silva
ssh-keygen -t ed25519 -C "92042225+diogo-costa-silva@users.noreply.github.com" -f ~/.ssh/id_ed25519_dcs

# Conta de testes - dipedilans
ssh-keygen -t ed25519 -C "157709256+dipedilans@users.noreply.github.com" -f ~/.ssh/id_ed25519_dd 

```



### 4.2. Adicionar Chaves SSH às Contas no GitHub CLI

#### 4.2.1 Adicionar Chave à Conta Principal (dcs)

```bash

# Autenticar e fazer upload da chave se ainda não existir

gh auth login --hostname github.com # segue instruções no browser

gh ssh-key add ~/.ssh/id_ed25519_dcs.pub --title "DCS_MB14"

```


#### 4.2.2 Adicionar Chave à Conta Secundária (dd)

```bash

# Login na segunda conta

gh auth login --hostname github.com # segue instruções no browser com a segunda conta

gh ssh-key add ~/.ssh/id_ed25519_dd.pub --title "DD_MB14"

```

  
No final verificar:

```bash
gh auth status
```


### 4.5. Configurar Hosts SSH Específicos

Edite o ficheiro `~/.ssh/config` para adicionar configurações específicas para cada conta GitHub:

```bash

# Criar/Abrir o ficheiro de configuração SSH - ~/.ssh/config

cd ~/.ssh
touch ~/.ssh/config
nano ~/.ssh/config

```

Adicione as seguintes configurações:

```

# Conta principal (dcs) - Conta oficial
Host github-dcs
HostName github.com
User git
IdentityFile ~/.ssh/id_ed25519_dcs
IdentitiesOnly yes


# Conta secundária (dd) - Conta de testes
Host github-dipedilans
HostName github.com
User git
IdentityFile ~/.ssh/id_ed25519_dd
IdentitiesOnly yes

```

Guarde o ficheiro e saia do editor `control + X`.

### 4.6. Autenticar Usando os Hosts Específicos

Depois de configurar os hosts no ficheiro `~/.ssh/config`, autentique cada conta usando os hosts específicos:

```bash

# Autenticar usando o host específico para a conta principal
gh auth login --hostname github-dcs

# Autenticar usando o host específico para a conta secundária
gh auth login --hostname github-dipedilans

```

### 4.7. Verificar a Configuração

Para verificar se tudo está configurado corretamente:

```bash

# Verificar o estado do gh
gh auth status # deve listar as duas contas, uma marcada "Active"

gh auth status -a # mostra conta activa


# Verificar a autenticação da conta principal
gh auth status -h github-dcs

# Verificar a autenticação da conta secundária
gh auth status -h github-dipedilans

```


### 4.8. Alternar a sessão activa no GitHub CLI

```bash
gh auth switch # lista contas

# ou directo
gh auth switch diogo-costa-silva
gh auth switch dipedilans

```

> (Git/SSH não precisa de switch — decide pela URL alias.)*



### 4.9. Verificar ligação SSH

```bash

# Verificar ligação SSH
ssh -T git@github-<alias> # “Hi <user>!”
ssh -T git@github-dcs # “Hi diogo-costa-silva!”
ssh -T git@github-dd # “Hi dipedilans!”

```  



### 4.12. (Opcional) Definir pastas-raiz por conta

Se quiseres que cada conta tenha uma pasta‑base dedicada para novos projectos, define variáveis de ambiente (`export ROOT_<alias>`) no teu ficheiro de inicialização da shell ( `~/.zshrc`):


```bash
# edita o ficheiro da shell
nano ~/.zshrc

# Adiciona (exemplo):
export ROOT_main="$HOME/Developer/personal"
export ROOT_work="$HOME/Developer/work"


source ~/.zshrc
```


* **Se estiver definida** `ROOT_<alias>`: ao iniciares um novo projecto e escolheres *“Pasta padrão da conta”* o multigit cria o repositório dentro dessa pasta.

* **Se não estiver definida**: o script pergunta‑te sempre onde o queres criar, sugerindo a pasta actual como predefinição.



## ⚙️ 8. Configuração Avançada

  

| Opção                                        | Para quê?                                                                                               |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `ROOT_<alias>`                               | Pasta‑raiz predefinida para novos projectos dessa conta (ex.: `export ROOT_dcs="$HOME/Developer/dcs"`). |
| `~/.config/multigit/accounts`                | Base de dados plana; podes editar manualmente para remover contas.                                      |
| `MG_DEFAULT_BRANCH`                          | Nome do branch por omissão (por defeito `main`).                                                        |
| `MG_COLOR_OK / MG_COLOR_WARN / MG_COLOR_ERR` | Override às cores ANSI usadas nas mensagens.                                                            |
|                                              |                                                                                                         |
|                                              |                                                                                                         |

| Variável / Flag               | Efeito                                                      |
| ----------------------------- | ----------------------------------------------------------- |
| `ROOT_<alias>`                | Pasta-raiz padrão para novos projectos dessa conta.         |
| `MULTIGIT_DEFAULT_BRANCH`     | Branch inicial (predef. main).                              |
| `MULTIGIT_DEFAULT_VISIBILITY` | public ou private quando omites --public/--private.         |
| `MULTIGIT_AUTO_PUSH`          | Se 1, faz git push -u origin após new/switch.               |
| `MULTIGIT_SKIP_COMMIT`        | Se 1, não cria First commit automático em new.              |
| `MULTIGIT_EDITOR`             | Editor usado nas mensagens do menu ($EDITOR fallback).      |
| `MULTIGIT_DEBUG`              | Se 1 ou flag --debug, mostra todos os comandos em execução. |
| `MULTIGIT_COLOR=0`            | Desactiva cores ANSI.                                       |
| `MULTIGIT_NON_INTERACTIVE`    | Se 1, falha em prompts em vez de ficar à espera de input.   |

  
  

---
---

  
