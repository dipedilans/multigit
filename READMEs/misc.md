

---

  

## 🔧 Personalização

* Usa qualquer `Host` definido no `~/.ssh/config`.
* O script usa ANSI cores; ajusta‑as nas funções `say`, `warn` e `die`.
* Compatível com Bash 3.2 – evita recursos exclusivos de versões mais recentes.
* Suporta templates de projecto via `git init --template`
  

---

  

## ❓ FAQ & Solução de Problemas

  

| Mensagem / Erro | Explicação & solução |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `src refspec main does not match any` | Ainda não fizeste o primeiro commit. |
| `Permission denied (publickey)` | Chave SSH não está associada à conta; corre `ssh -T git@<host-alias>`. |
| Menu mostra literais `\e[36m`… | Usa a versão do script que já converte para `printf`. |
| “Continua a correr o script antigo” | Corre `which -a multigit` para detectar duplicados e `hash -r`. |
| Quero remover uma conta | Edita `~/.config/multigit/accounts` e apaga a linha ou volta a `multigit add` com os dados correctos. |

  

| Mensagem / Erro | Causa & Solução |
|-----------------|-----------------|
| Permission denied (publickey) | A chave SSH não está ligada à conta → `ssh -T git@github-<alias>`. |
| src refspec main does not match any | Ainda não há commits — corre `git commit -m "Init"`. |
| Sequências \e[36m no menu | Usa versão ≥ 2025-05 — troca para printf em vez de echo -e. |
| "Troquei o script e corre o antigo" | `which -a multigit.sh` → remove duplicados, depois `hash -r`. |




  

---

  

## 🗺️ Roadmap

  
* [ ] **Instalação via Homebrew Tap oficial** (brew tap multigit/tools)
    
* [ ] **Auto‑detecção de actualizações** (multigit self-update)
    
* [ ] **Comando multigit clone** com alias SSH correcto
    
* [ ] **Gestão de contas via CLI** (multigit rm, multigit edit)
    
* [ ] **Suporte a outras plataformas**: GitLab / Bitbucket (via --platform)
    
* [ ] **Autocomplete para Zsh/Bash**
    
* [ ] **Logs verbosos completos** (--debug + ficheiro em ~/.cache)
    
* [ ] **Testes automáticos com bats-core**
  

---

## 🤝 Contribuir

1. **Abre uma issue** e descreve a funcionalidade que queres propor.
    
2. **Faz fork** do repositório e cria uma **branch** a partir de main.
    
3. **Mantém compatibilidade com Bash 3.2** (evita mapfile, arrays associativas, etc.).
    
4. **Garante que shellcheck passa** sem erros.
    
5. **Envia um pull request** com exemplos de uso e screenshots quando relevante.

---

  

## 10 · Extras úteis e Dicas Avançadas

  

* Assinar commits por conta (`user.signingkey`).

* Templates de projecto (`git init --template`).

* Alias shell: `alias gs='gh auth switch "$1"'`.

* Assinatura GPG por conta (`git config user.signingkey`).

* Templates de projecto (`git init --template`).

* Autocomplete Zsh para o script.

  
  

- Assinatura de commits por conta:

```bash

git config user.signingkey <GPG_KEY_ID>

```

- Templates de projecto:

```bash

git init --template ~/templates/minimal-python

```

- Alias no `.zshrc` para mudar de conta:

```bash

alias gs='gh auth switch "$1"'

```

- Autocomplete Zsh para o script: usar `_gh-multi.sh` como base.






---

## 📄 Licença

MIT – consulta o ficheiro [`LICENSE`](LICENSE) para mais detalhes.

---

**Multigit** – Simplifica a gestão de múltiplas identidades GitHub no teu Mac. 🚀
  
  
  
