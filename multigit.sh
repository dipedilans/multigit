#!/usr/bin/env bash
# multigit.sh – menu interactivo para múltiplas contas GitHub  (Bash 3.2)

set -euo pipefail
IFS=$'\n\t'

CFG="$HOME/.config/multigit/accounts"
mkdir -p "$(dirname "$CFG")"

# --- helpers ------------------------------------------------------------
die(){ echo -e "\e[31mErro:\e[0m $*" >&2; exit 1; }
say(){ printf '\033[36m%s\033[0m\n' "$*"; }
warn(){ printf '\033[33m%s\033[0m\n' "$*"; }
have(){ command -v "$1" >/dev/null || die "Falta '$1'!"; }
have git; have gh; have jq
lookup(){ grep "^$1|" "$CFG" 2>/dev/null || true; }

pause(){ read -p "↩︎ Enter … " _; }

# detecta se estamos dentro de um repositório Git
detect_context(){
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    IN_REPO="yes"
  else
    IN_REPO="no"
  fi
}

# --- RAIZES OPCIONAIS POR CONTA -------------------------------------
# Define ROOT_<ALIAS> se quiseres guardar projectos numa pasta‑raiz específica.
# Exemplo:
#   ROOT_dcs="$HOME/Developer/dcs"
#   ROOT_dipedilans="$HOME/Developer/dd"
# Se a variável não estiver definida, o script usa o directório actual.
# --------------------------------------------------------------------

get_aliases(){ aliases=(); while IFS='|' read -r a _; do aliases+=("$a"); done < "$CFG"; }

# devolve alias escolhido ou código de erro 1 se o utilizador cancelar
choose_alias(){
  get_aliases
  [[ ${#aliases[@]} -eq 0 ]] && { warn "Sem contas."; return 1; }
  echo "Escolhe a conta:"
  select choice in "${aliases[@]}" "Voltar"; do
    case $choice in
      Voltar) return 1 ;;
      "")     ;;              # select mostrou prompt de erro
      *)      alias_sel="$choice"; echo "$alias_sel"; return 0 ;;
    esac
  done
}

# --- comandos base (add | list | new | switch) --------------------------
cmd_list(){
  if [[ ! -s "$CFG" ]]; then echo "(sem contas)"; return; fi
  say "Alias        | Username             | Email"
  printf '%0.s-' {1..72}; echo
  awk -F'|' '{printf "%-12s | %-20s | %s\n",$1,$2,$3}' "$CFG"
}

cmd_add(){
  [[ $# -eq 4 ]] || die "Uso: add <alias> <user> <email> <host>"
  [[ -n $(lookup "$1") ]] && die "Alias existe."
  [[ "$2" =~ ^[A-Za-z0-9-]+$ ]] || die "Username GitHub inválido. Usa apenas letras, dígitos ou hífen (ex.: dipe001)."
  echo "$1|$2|$3|$4" >>"$CFG"
  say "Conta '$1' registada."
}

cmd_new(){                      # cria repo remoto (sem push)
  [[ $# -ge 2 ]] || die "Uso: new <alias> <repo> [--private|--public]"
  row=$(lookup "$1"); [[ -z $row ]] && die "Alias desconhecido."
  IFS='|' read -r _ user email host <<<"$row"; shift
  repo="$1"; shift; vis="${1:---public}"

  # verifica se repositório já existe na conta
  if gh repo view "$user/$repo" --json name >/dev/null 2>&1; then
    die "Repositório '$user/$repo' já existe no GitHub. Escolhe outro nome ou apaga o existente."
  fi

  git init -b main
  git config user.name  "$user"
  git config user.email "$email"

  gh repo create "$user/$repo" "$vis" --source . --remote origin
  git remote set-url origin "git@${host}:${user}/${repo}.git"
  # garantir que a URL usa o host-alias correcto
  say "Repo remoto criado: https://github.com/$user/$repo"
}

cmd_switch(){                   # troca/add remote & identidade
  [[ $# -eq 1 ]] || die "Uso: switch <alias>"
  row=$(lookup "$1"); [[ -z $row ]] && die "Alias desconhecido."
  IFS='|' read -r _ user email host <<<"$row"

  url=$(git remote get-url origin 2>/dev/null || true)
  if [[ -z $url ]]; then
    repo_name=$(basename "$(pwd)")
    git remote add origin "git@${host}:${user}/${repo_name}.git"
    say "Remote origin adicionado."
  else
    old_host=$(echo "$url" | cut -d':' -f1 | sed 's/git@//')
    if [[ $old_host != $host ]]; then
      owner=$(echo "$url" | sed -E 's#.*/([^/]+)/[^/]+\.git#\1#')
      repo=$(basename -s .git "$url")
      git remote set-url origin "git@${host}:${owner}/${repo}.git"
      say "URL origin trocado."
    fi
  fi
  git config user.name  "$user"
  git config user.email "$email"
  say "Identidade Git actualizada para '$user'."
}

# lista repositórios disponíveis numa conta/alias
cmd_repos(){                     # Uso: repos <alias>
  [[ $# -eq 1 ]] || die "Uso: repos <alias>"
  row=$(lookup "$1"); [[ -z $row ]] && die "Alias desconhecido."
  [[ "$row" =~ \|[^[:space:]]+\| ]] || { warn "Username contém espaços; corrige ~/.config/multigit/accounts."; return; }
  IFS='|' read -r _ user _ host <<<"$row"

  say "Repositórios de $user (host $host):"
  # Obtém até 100 repositórios e mostra nome, visibilidade e data da última actualização
  gh repo list "$user" --limit 100 --json name,visibility,updatedAt \
    | jq -r '.[] | (.visibility + ": " + .name + " - actualizado em " + ((.updatedAt | split("T"))[0]))'
}

# --- menu: criar, migrar, etc. -----------------------------------------
menu_init(){
  say "== Iniciar projecto novo =="
  alias=$(choose_alias) || { pause; return; }
  read -p "Nome da pasta / repo: " dir
  read -p "Visibilidade (public/private) [public]: " vis; vis=${vis:-public}

  base_var="ROOT_${alias}"
  default_root=$(eval echo \${$base_var:-$PWD})

  echo "Onde queres criar o projecto?"
  echo "1) Pasta padrão da conta ($default_root)"
  echo "2) Directório actual ($PWD)"
  echo "3) Outra pasta …"
  read -p "Opção [1/2/3]: " choice
  case $choice in
    1) target_root="$default_root" ;;
    2) target_root="$PWD" ;;
    3) read -p "Introduz caminho absoluto: " custom_root; target_root="$custom_root" ;;
    *) target_root="$default_root" ;;
  esac

  mkdir -p "$target_root/$dir" && cd "$target_root/$dir"

  cmd_new "$alias" "$dir" "--$vis"

  read -p "Commit inicial automático? (y/N) " auto
  if [[ $auto =~ ^[Yy]$ ]]; then
    echo "# $dir" > README.md
    git add README.md
    git commit -m "Primeiro commit"
    git push -u origin main
    say "Commit & push efectuados."
  else
    warn "Agora corre:\n  cd $dir && echo \"# $dir\" > README.md && git add README.md && git commit -m \"Init\" && git push -u origin main"
  fi
  pause
}

menu_migrate(){
  say "== Migrar projecto existente =="
  read -p "Pasta do projecto (. para actual): " dir
  [[ $dir == "." ]] && dir="$PWD"
  [[ -d $dir/.git ]] || { warn "Não é repo Git."; pause; return; }
  alias=$(choose_alias) || { pause; return; }
  ( cd "$dir"
    cmd_switch "$alias"
    if git rev-parse --quiet --verify main >/dev/null; then
      git push -u origin main; say "Push main efectuado."
    else
      warn "Ainda sem branch main. Faz commit e push manual."
    fi
  )
  pause
}

menu_add(){
  say "== Adicionar conta =="
  read -p "Alias curto: " a
  read -p "User.name Git: " u
  read -p "Email noreply: " e
  read -p "Host alias SSH: " h
  cmd_add "$a" "$u" "$e" "$h"; pause
}

# --- loop principal -----------------------------------------------------

# ---------- modo CLI (argumentos) ------------------------
if [[ $# -gt 0 ]]; then
  case $1 in
    add)    shift; cmd_add    "$@"; exit ;;
    list)             cmd_list; exit ;;
    new)    shift; cmd_new    "$@"; exit ;;
    switch) shift; cmd_switch "$@"; exit ;;
    repos)  shift; cmd_repos  "$@"; exit ;;
    *)  die "Sub-comandos: add | list | new | switch | repos";;
  esac
fi

# ---------- menu interactivo -----------------------------


while true; do
  clear
  detect_context

  if [[ $IN_REPO == "yes" ]]; then
    repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    say "Multi-Git – Repo '$repo_name'"
    echo "1) Alterar conta neste repo"
    echo "2) Listar contas"
    echo "3) Listar repos de uma conta"
    echo "4) Sair"
    read -p "Opção: " o
    case $o in
      1)
         alias=$(choose_alias) || { pause; continue; }
         cmd_switch "$alias"; pause ;;
      2) cmd_list; pause ;;
      3)
         alias=$(choose_alias) || { pause; continue; }
         cmd_repos "$alias"; pause ;;
      4) exit 0 ;;
      *) pause ;;
    esac
  else
    say "Multi-Git – Menu"
    echo "1) Iniciar projecto"
    echo "2) Migrar"
    echo "3) Adicionar conta"
    echo "4) Listar contas"
    echo "5) Listar repos da conta"
    echo "6) Sair"
    read -p "Opção: " o
    case $o in
      1) menu_init ;;
      2) menu_migrate ;;
      3) menu_add ;;
      4) cmd_list; pause ;;
      5)
         alias=$(choose_alias) || { pause; continue; }
         cmd_repos "$alias"; pause ;;
      6) exit 0 ;;
      *) pause ;;
    esac
  fi
done
