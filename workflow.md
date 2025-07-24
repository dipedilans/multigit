
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


### Se quiseres padronizar tudo em main

1.	Muda o ramo remoto (já existente):

```bash
# ainda dentro de streamlit-tutorial
git branch -m master main          # renomeia o branch local
git push -u origin main            # cria main no GitHub
git push origin --delete master    # (opcional) remove master remoto
```

2.	Define o nome por omissão para futuros repositórios:

```bash
git config --global init.defaultBranch main
```

Assim, sempre que fizeres git init o primeiro branch será main, tal como no guia original.


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

```bash
git add workflow.md
git commit -m "tornar branch standard em  main"
git push
```

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
