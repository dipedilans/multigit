
### Comandos-check rápidos


```bash

# 📍 Verificar localização do script
which multigit.sh  # Deve mostrar /Users/<teu_user>/bin/multigit.sh

# 🔐 Testar autenticação via SSH (conta específica)
ssh -T git@github-dcs  # Esperado: "Hi diogo-costa-silva!"

# 👤 Verificar conta activa no GitHub CLI
gh auth status -a  # Mostra todas as contas e indica qual está activa

# 🧠 Atualizar cache de comandos (se moveste o script)
hash -r  # Apenas necessário se o executável mudou de localização

# 🌐 Verificar origem do repositório Git
git remote -v  # Mostra o host associado (ex: github-dcs)

# 🆔 Confirmar identidade Git configurada para o repositório
git config user.name  # Deve bater certo com a conta SSH activa

# ✅ Se o remote e o user.name estiverem certos, podes usar Git normalmente!

```




## 🚀 5. Comandos


| Comando                                      | Descrição                              |
| -------------------------------------------- | -------------------------------------- |
| `multigit add <alias> <user> <email> <host>` | Regista ou actualiza uma conta         |
| `multigit list`                              | Lista contas guardadas                 |
| `multigit new <alias> <repo> [--private]`    | Cria repo local + remoto               |
| `multigit switch <alias>`                    | Troca a conta associada ao repo actual |
| `multigit repos <alias>`                     | Lista repositórios da conta            |
| `multigit`                                   | Abre o **menu interactivo**            |



### Exemplos de uso

  

```bash

# Criar novo repositório privado

multigit new work meu-projeto --private

  

# Migrar repositório existente

cd ~/meu-repo

multigit switch main

git push -u origin main

  

# Listar repositórios de uma conta

multigit repos work

```




### Comandos Disponíveis

### Modo CLI

- `add <alias> <user> <email> <host>`: Adicionar nova conta
- `list`: Listar todas as contas configuradas
- `new <alias> <repo> [--private|--public]`: Criar novo repositório
- `switch <alias>`: Trocar identidade no repositório atual
- `repos <alias>`: Listar repositórios de uma conta

  
### Menu Interativo

#### Fora de um Repositório

1. Iniciar projeto
2. Migrar projeto existente
3. Adicionar conta
4. Listar contas
5. Listar repositórios de uma conta

#### Dentro de um Repositório

1. Alterar conta no repositório atual
2. Listar contas
3. Listar repositórios de uma conta



---

  
  

## 💡 6. Workflows do dia‑a‑dia






### 4.11. Registar contas no Multigit

Existem **duas maneiras** de criar ou actualizar uma conta no multigit:

```bash

# 1) Menu interactivo

multigit.sh # opção 3) Adicionar conta (repete p/ cada conta)

  

# 2) Linha de comandos directa

multigit add <alias> <user> <email> <host-alias>

  

# exemplo:

multigit.sh add dcs "Diogo Costa" "92042225+diogo-costa-silva@users.noreply.github.com" github-dcs

multigit.sh add dd "Dipe Dilans" "157709256+dipedilans@users.noreply.github.com" github-dipedilans

multigit.sh list


```



### 4.13. Adicionar nova conta no futuro (POR VERIFICAR)

  

```bash

# gerar nova chave + alias 'github-work'

gh auth login # login via browser na conta work com a chave respectiva

gh-multi.sh add work "Diogo • Work" "NOREPLY_EMAIL" github-work

```

  
  

```bash

# Gerar nova chave SSH + alias (ex: github-work)

ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_work -C "NOREPLY_EMAIL"

  

# Editar ~/.ssh/config com novo Host github-work

  

# Login via GitHub CLI

gh auth login --hostname github.com --git-protocol ssh

  

# Adicionar ao script

gh-multi.sh add work "Diogo • Work" "NOREPLY_EMAIL" github-work

```


```bash

# gerar nova chave + alias 'github-work'

gh auth login # login via browser na conta work com a chave respectiva

gh-multi.sh add work "Diogo • Work" "NOREPLY_EMAIL" github-work

```

  

```bash

# Gerar nova chave SSH + alias (ex: github-work)

ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_work -C "NOREPLY_EMAIL"

  

# Editar ~/.ssh/config com novo Host github-work

  

# Login via GitHub CLI

gh auth login --hostname github.com --git-protocol ssh

  

# Adicionar ao script

gh-multi.sh add work "Diogo • Work" "NOREPLY_EMAIL" github-work

```

  

### 6.1. Criar projecto de raiz

  

```bash

multigit new dcs blog --public

cd blog

echo "# blog" > README.md

git add README.md

git commit -m "Init"

# git add README.md && git commit -m "Init"

git push -u origin main

```

  

### 6.2. Migrar projecto existente para outra conta

  

```bash

cd ~/project

multigit switch dd

git push -u origin main # remote e identidade já correctos

```

  

### 6.3. Listar repositórios de uma conta

  

```bash

multigit repos dcs # ou dd

```


### 6.4. Alternar entre contas no GitHub CLI

```bash

gh auth switch # lista contas disponíveis

gh auth switch username # muda directamente

```

  

| Tarefa                              | Comando                                                                    |
| ----------------------------------- | -------------------------------------------------------------------------- |
| Criar repositório novo              | `multigit.sh new <alias> <repo> [--private \| --public]`                   |
| Migrar repositório para outra conta | `multigit.sh switch <alias>` + `git push -u origin main`                   |
| Alternar conta activa no GitHub CLI | `gh auth switch` (oscila) <br>`gh auth switch -h github.com -u dipedilans` |

  
  

### Exemplo completo

  

```bash

# Criar projecto na conta dipedilans

mkdir demo && cd demo

gh-multi.sh new dipedilans demo --private

  

# Abrir Pull Request (CLI já está em dipedilans)

gh pr create --fill

  

# Migrar para conta oficial e torná‑lo público

gh auth switch diogo-costa-silva

gh-multi.sh switch dcs

git push -u origin main

gh repo edit diogo-costa-silva/demo --visibility public

```

  
  

```bash

# novo projecto privado em dipedilans

mkdir exper && cd exper

multigit.sh new dipedilans exper --private

  

# primeiro commit (manual) e push

echo "# exper" > README.md

git add README.md

git commit -m "Init"

git push -u origin main

  

# migrar para conta oficial

multigit.sh switch dcs

git push -u origin main

gh auth switch -h github.com -u diogo-costa-silva

gh repo edit diogo-costa-silva/exper --visibility public

```

  
  

```bash

# Novo repo privado na conta de testes

mkdir exper && cd exper

gh-multi.sh new dipedilans exper --private

  

echo "# exper" > README.md

git add .

git commit -m "Init"

git push -u origin main

  

# Migrar para conta oficial

gh auth switch diogo-costa-silva

gh-multi.sh switch dcs

git push -u origin main

gh repo edit diogo-costa-silva/exper --visibility public

```

  
  

---

  

## 📱 7. Menu Interactivo

Executa `multigit` para aceder a um menu que se adapta automaticamente ao contexto: 
- dentro de um repositório, permite alterar a conta ativa; 
- fora de um repositório, permite migrar um repositório existente.

### 7.1. Fora de um repositório Git


```

== Multigit – Menu ==

1) Iniciar projecto

2) Migrar repo existente

3) Adicionar conta

4) Listar contas

5) Listar repos da conta

6) Sair

```


| Nº    | O que faz                                                  |
| ----- | ---------------------------------------------------------- |
| **1** | Iniciar projecto (cria pasta, escolhe conta, repo remoto). |
| **2** | Migrar projecto existente para outra conta.                |
| **3** | Adicionar conta (alias, user, e‑mail, host SSH).           |
| **4** | Listar contas registadas.                                  |
| **5** | Listar repositórios de uma conta.                          |
| **6** | Sair.                                                      |
  

### 7.2. Dentro de um repositório Git

```

== Multigit – Menu ==

1) Alterar conta neste repo

2) Listar contas

3) Listar repos da conta

4) Sair

```
 

| Nº    | O que faz                                                 |
| ----- | --------------------------------------------------------- |
| **1** | Alterar conta neste repo (troca remote e identidade Git). |
| **2** | Listar contas registadas.                                 |
| **3** | Listar repositórios de uma conta.                         |
| **4** | Sair.                                                     |
  
*(Todas as operações continuam disponíveis também via linha de comandos, para quem preferir.)*

  

---



## Referência de comandos

| Comando                                      | Descrição                                                |
| -------------------------------------------- | -------------------------------------------------------- |
| `multigit`                                   | Abre o menu interactivo adaptado ao contexto do terminal |
| `multigit add <alias> <user> <email> <host>` | Regista ou actualiza uma conta                           |
| `multigit list`                              | Lista contas guardadas                                   |
| `multigit new <alias> <repo> [--private]`    | Cria um novo projecto local e remoto                     |
| `multigit switch <alias>`                    | Troca a identidade usada no repositório actual           |
| `multigit repos <alias>`                     | Lista os repositórios associados a uma conta             |
| `multigit doctor (beta)`                     | Verifica dependências e configuração do ambiente         |
| `multigit --debug`                           | Activa verbosidade adicional para diagnóstico            |


