Eis uma guia completo — passo a passo — para manter **duas contas GitHub** (ex.: diogo-costa-silva e dipedilans) no mesmo macOS, sem tropeçar em chaves SSH nem na GitHub CLI. O objectivo é que qualquer pessoa o possa seguir e reproduzir.

---
# **Índice**

- [**Índice**](#índice)
  - [**1. Pré-requisitos**](#1-pré-requisitos)
  - [**2. Instalar Git e GitHub CLI**](#2-instalar-git-e-github-cli)
  - [**3. Gerar duas chaves SSH** (uma por conta)](#3-gerar-duas-chaves-ssh-uma-por-conta)
  - [**4. Configurar** **ssh-agent**  **e o macOS Keychain**](#4-configurarssh-agent-e-o-macos-keychain)
  - [**5. Adicionar as chaves às contas GitHub**](#5-adicionar-as-chaves-às-contas-github)
    - [**Método A — Via interface Web (universal)**](#método-a--via-interface-web-universal)
    - [**Método B — GitHub CLI**](#método-b--github-cli)
  - [**6. Criar/editar**  `~/.ssh/config`](#6-criareditar-sshconfig)
    - [Teste rápido](#teste-rápido)
  - [**7. Autenticar cada conta na GitHub CLI**](#7-autenticar-cada-conta-na-github-cli)
  - [**8. Criar atalhos rápidos na CLI**](#8-criar-atalhos-rápidos-na-cli)
  - [**9. Configurar identidade de commits**](#9-configurar-identidade-de-commits)
  - [**10. Workflow diário — do zero ao push**](#10-workflow-diário--do-zero-ao-push)
      - [Checklist rápido](#checklist-rápido)
- [Workflow completo](#workflow-completo)
  - [I. Projeto‐exemplo na conta dd (tutorial Streamlit)](#i-projetoexemplo-na-conta-dd-tutorial-streamlit)
  - [II. Projeto‐exemplo na conta dcs (analytics MotoGP)](#ii-projetoexemplo-na-conta-dcs-analytics-motogp)
  - [III. Alternar rapidamente entre projectos](#iii-alternar-rapidamente-entre-projectos)
  - [IV. Dicas de segurança \& depuração](#iv-dicas-de-segurança--depuração)
  - [**11. Verificações rápidas \& resolução de problemas**](#11-verificações-rápidas--resolução-de-problemas)
  - [**Resultado**](#resultado)

---
## **1. Pré-requisitos**

|**Ferramenta**|**Versão sugerida**|**Verificar com**|
|---|---|---|
|macOS|Sonoma 14 ou superior|sw_vers -productVersion|
|Homebrew|4.0 ou superior|brew --version|
|Git|≥ 2.45|git --version|
|GitHub CLI|≥ 2.50|gh --version|
|OpenSSH|já incluído no macOS|ssh -V|

> **Nota** Se não tens o Homebrew, instala-o primeiro:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---
## **2. Instalar Git e GitHub CLI**

```bash
brew install git gh

# confirma
git --version
gh  --version
```

---
## **3. Gerar duas chaves SSH** (uma por conta)

Cria **um par de chaves por conta** (substitui nomes/e-mails conforme):

```bash
# chave da Conta oficial - diogo-costa-silva
ssh-keygen -t ed25519 -C "92042225+diogo-costa-silva@users.noreply.github.com" -f ~/.ssh/id_ed25519_dcs

# chave da Conta de testes - dipedilans
ssh-keygen -t ed25519 -C "157709256+dipedilans@users.noreply.github.com" -f ~/.ssh/id_ed25519_dd
```

Pressiona **Enter** quando pedirem “passphrase” se preferires chave sem palavra-passe (menos seguro).

---
## **4. Configurar** **ssh-agent**  **e o macOS Keychain**

```bash
# Arrancar o agente
eval "$(ssh-agent -s)"

# Usar o Keychain do macOS
echo 'Host *'         >> ~/.ssh/config
echo '  UseKeychain yes' >> ~/.ssh/config

# Adicionar as chaves ao agente (uma vez)
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_dd
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_dcs
```

---

## **5. Adicionar as chaves às contas GitHub**

### **Método A — Via interface Web (universal)**

1. Copia o conteúdo de `id_ed25519_dcs.pub` 
	```pbcopy < ~/.ssh/id_ed25519_dd.pub```
    
2. GitHub ▸ **Settings → SSH and GPG keys** ▸ **New SSH key** ▸ cola a chave.
    
3. (Opcional) Apaga a chave pública do disco depois de as colar.
    
4. Repete para id_ed25519_dcs.pub.

### **Método B — GitHub CLI**

```bash
gh auth login --git-protocol ssh --web -u diogo-costa-silva    # troca de conta pelo browser
gh ssh-key add ~/.ssh/id_ed25519_dcs.pub --title "DCS_MB14_key"

gh auth login --git-protocol ssh --web -u dipedilans          # só para dar acesso a API
gh ssh-key add ~/.ssh/id_ed25519_dd.pub   --title "DD_MB14_key"
```

---

## **6. Criar/editar**  `~/.ssh/config`

Adiciona estas entradas **abaixo** da linha UseKeychain yes (secção 4):

```
# Conta pessoal
Host github-dd
  HostName   github.com
  User       git
  IdentityFile ~/.ssh/id_ed25519_dd
  IdentitiesOnly yes

# Conta profissional
Host github-dcs
  HostName   github.com
  User       git
  IdentityFile ~/.ssh/id_ed25519_dcs
  IdentitiesOnly yes

# Opcional: host genérico aponta à tua conta "por omissão"
Host github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_dd     # ou _dcs_ se preferires
  IdentitiesOnly yes
```

**Como funciona?**

- Quando um repositório remoto começa por git@github-dcs:, o SSH usa a chave id_ed25519_dcs.
    
- Se começa por git@github-dd:, usa id_ed25519_dd.
    
- Se usares git@github.com:, será a tua chave “por omissão”.


⚠️ Alerta **NBSP** — Depois de copiar/colar, certifica‑te de que **todos** os espaços são normais (ASCII 0x20). Para isso, elimina espaços não‑ASCII:

```bash
perl -pi -e 's/\xC2\xA0/ /g' ~/.ssh/config
```

### Teste rápido

```bash
ssh -T git@github.com   # «Hi diogo‑costa‑silva!»
ssh -T git@github-dcs   # «Hi diogo‑costa‑silva!»
ssh -T git@github-dd    # «Hi dipedilans!»
```

---

## **7. Autenticar cada conta na GitHub CLI**

Autentica as duas contas sob github.com:

```bash
# Conta 1 — dipedilans (ficará "activa" depois do login)
gh auth login --git-protocol ssh --web --scopes 'admin:public_key,gist,read:org,repo' \
              -u dipedilans

# Muda no browser para a conta 2 e autentica
gh auth login --git-protocol ssh --web --scopes 'admin:public_key,gist,read:org,repo' \
              -u diogo-costa-silva
```

Verifica:

```bash
gh auth status          # deve listar ambas
```

---

## **8. Criar atalhos rápidos na CLI**

```bash
# Alias "gh dcs" para trocar para a conta profissional
gh alias set dcs 'auth switch -u diogo-costa-silva'

# Alias "gh dd" para trocar para a conta pessoal
gh alias set dd  'auth switch -u dipedilans'
```

_Testa_:

```bash
gh dcs     # activa diogo-costa-silva
gh auth status -a   # só mostra a conta actualmente activa
gh dd      # volta para dipedilans
```


```bash
# Aliases novos, versão curta
gh alias set dcs 'auth switch -u diogo-costa-silva'
gh alias set dd  'auth switch -u dipedilans'

# troca para a conta diogo-costa-silva
gh dcs
# volta para a conta dipedilans
gh dd  

# mostra todos os atalhos
gh alias list
# verifica qual está activa
gh auth status
# mostra só a conta activa
gh auth status -a
# confirma que o URL usa o host certo
git remote -v

# apagar os aliases
gh alias delete dcs
gh alias delete dd
```

---

## **9. Configurar identidade de commits**

Cria estes **aliases de shell** (ex.: no ~/.zshrc) para definir user.name e user.email localmente em cada repositório:

```bash
alias gset-dcs='git config user.name "Diogo Silva" \
                && git config user.email "92042225+diogo-costa-silva@users.noreply.github.com"'

alias gset-dd='git config user.name "Dipe Dilans" \
               && git config user.email "157709256+dipedilans@users.noreply.github.com"'
```

> Qualquer repositório onde correres **uma única vez** gset-dcs ou gset-dd guarda a identidade para sempre no respectivo `.git/config`.

Aplica-os **uma vez por projecto** antes do primeiro commit:

```bash
gset-dcs     
# ou
gset-dd
```

---

## **10. Workflow diário — do zero ao push**

| **Passo**            | **Comando (exemplo)**                                                      | **Explicação**                              |
| -------------------- | -------------------------------------------------------------------------- | ------------------------------------------- |
| 1. Criar pasta       | mkdir -p ~/Code/dcs/novo-projecto && cd $_                                 | Mantém projetos separados por conta.        |
| 2. git init          | git init                                                                   | Inicializa o repositório.                   |
| 3. Identidade        | gset-dcs                                                                   | Grava nome/e-mail correctos no .git/config. |
| 4. Trocar CLI        | gh dcs                                                                     | Garante que gh opera na conta certa.        |
| 5. Criar repo remoto | gh repo create diogo-costa-silva/novo-projecto --private --source=. --push | CLI abre o repo e faz o primeiro push.      |
| 6. Desenvolver       | _editar ficheiros…_                                                        |                                             |
| 7. _Stage + commit_  | git add . → git commit -m "feat: primeiro commit"                          |                                             |
| 8. Push futuro       | git push                                                                   | Já existe branch main ligada ao remoto.     |

> **Nota** Se preferires manter URLs _claros_, podes mudar o remote:

```
git remote set-url origin git@github-dcs:diogo-costa-silva/novo-projecto.git
```

> Não afecta a CLI - apenas as operações git push/pull.
> **Nota:** `gh auth switch` só é preciso se fores chamar _comandos gh_ (ex.: abrir PR, criar issue). `git push/pull` usa **apenas a chave SSH** correspondente ao host.

#### Checklist rápido

```bash
git remote -v                                   # host → chave
git config --local --get-regexp user\\.         # nome e email activos
gh auth status                                  # conta activa na CLI
```



# Workflow completo

Duas contas, dois projectos: dd e dcs

Pré-requisitos já configurados

> • Chaves SSH: id_ed25519_dd e id_ed25519_dcs
> • Hosts SSH no ~/.ssh/config: github-dd e github-dcs
> • Aliases de CLI GitHub: gh dd e gh dcs
> • Aliases de identidade Git: gset-dd e gset-dcs
> • Pasta-raiz onde guardas código: ~/Code/


---

## I. Projeto‐exemplo na conta dd (tutorial Streamlit)

1. Activar a sessão CLI correcta

```bash
# torna “dipedilans” a conta activa na CLI
gh dd
# confirma que está activa
gh auth status -a
```


2. Criar e entrar na directoria do projecto

```bash
mkdir -p ~/Code/dd/streamlit-tutorial
cd ~/Code/dd/streamlit-tutorial
```


3. Inicializar Git

```bash
git init
```


4. Definir identidade de commits para esta pasta

```bash
# escreve user.name e user.email locais
gset-dd
```

  

5. Ficheiros de arranque (exemplo mínimo)

```bash
echo "# Streamlit Tutorial" > README.md
touch .gitignore requirements.txt
```


6. Stage + primeiro commit

```bash
git add .
git commit -m "init: estrutura base do projecto"
```


7. Criar repositório remoto e fazer push

```bash
gh repo create dipedilans/streamlit-tutorial \
--private --source=. --push
```

  

8. (Opcional) Forçar o URL remoto a usar o host-alias

```bash
git remote set-url origin \
git@github-dd:dipedilans/streamlit-tutorial.git
```

9. Fazer push novamente

```bash
git push -u origin main
#ou
git push -u origin master
```

10. Verificações rápidas antes de continuar

```bash
# deve mostrar github-dd
git remote -v
# conta dd continua activa
gh auth status -a
```


11. Ciclo diário

  > • Editar código, testes…
  > • git add "ficheiros"
  > • git commit -m "feat: …"
  > • git push


---

## II. Projeto‐exemplo na conta dcs (analytics MotoGP)

1. Mudar a sessão da CLI

```bash
gh dcs
# confirma “diogo-costa-silva” activo
gh auth status -a
```

  
2. Criar pasta e entrar

```bash
mkdir -p ~/Code/dcs/motogp-analytics
cd ~/Code/dcs/motogp-analytics
```


3. Inicializar Git

```bash
git init
```


4. Identidade de commits local

```bash
gset-dcs
```

  

5. Ficheiros de arranque

```bash
echo "# MotoGP Analytics" > README.md
touch .gitignore environment.yml
```


6. Primeiro commit

```bash
git add .
git commit -m "init: projecto analytics MotoGP"
```


7. Criar repositório remoto e push

```bash
gh repo create diogo-costa-silva/motogp-analytics \
--private --source=. --push
```


8. (Opcional) Ajustar URL para host-alias

```bash
git remote set-url origin \
git@github-dcs:diogo-costa-silva/motogp-analytics.git
```


9. Verificações

```bash
git remote -v
gh auth status -a
```

  

10. Ciclo diário

> • Editar código, análises…
> • git add / git commit / git push


---

## III. Alternar rapidamente entre projectos

```bash
# 1. guardar trabalho corrente
git push

# 2. mudar de directório + conta CLI
cd ~/Code/dd/streamlit-tutorial
# se precisares de voltar ao tutorial
gh dd

# ou vice-versa:
cd ~/Code/dcs/motogp-analytics
gh dcs
```

Sugestão: mantém dois separadores de terminal abertos — um para cada conta.


---

## IV. Dicas de segurança & depuração

• Confirmar conta activa a qualquer momento

```bash
gh auth status -a
```

• Confirmar que o host do remote invoca a chave certa

```bash
git remote -v
ssh -T git@github-dcs # ou git@github-dd
```
  

• Erro “Permission denied (publickey)”
→ o URL remoto aponta ao host errado; corrige com git remote set-url ….

---

Resumo ultrarrápido

```bash
# 
gh dd
mkdir ~/Code/dd/proj
git init
gset-dd
gh repo create … --push.
```

```bash
# 
gh dcs
mkdir ~/Code/dcs/proj
git init
gset-dcs
gh repo create … --push.
```


Em cada ciclo de trabalho: editar → `git add` → `git commit` → `git push`

---

## **11. Verificações rápidas & resolução de problemas**

|**Verificação**|**Comando**|**Boa saída**|
|---|---|---|
|Conta CLI activa|gh auth status -a|Mostra só **1** conta com Active account: true.|
|Host → chave|ssh -T git@github-dcs|«Hi **diogo-costa-silva**! You’ve successfully authenticated…»|
|Remote correcto|git remote -v|origin git@github-dcs:diogo-costa-silva/…|
|Identidade commit|git config --local --get-regexp user\\.|nome/e-mail desejados|

|**Erro**|**Causa típica**|**Solução**|
|---|---|---|
|Permission denied (publickey)|Remote usa host errado|git remote set-url origin git@github-dcs:…|
|Commit com e-mail errado|Esqueceste gset-…|git commit --amend --author="Nome <email>" + git push --force-with-lease|
|no account matched that criteria|Alias gh dcs/dd mal definido|gh alias list → recria com --clobber|

---

## **Resultado**

Seguindo este guia tens:

- **2 pares de chaves SSH** independentes.
    
- **Troca instantânea** de conta na GitHub CLI (gh dcs / gh dd).
    
- **Commits** sempre assinados com o avatar certo.
    
- Remote URLs claros (github-dcs ou github-dd) mas compatíveis com qualquer máquina.



---
---
---