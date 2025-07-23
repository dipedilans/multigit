# multigit 🚀

> Gerir várias identidades GitHub num único Mac — com um só comando

O *Multigit* é um script que simplifica o uso de múltiplas contas GitHub num mesmo computador macOS, permitindo alternar instantaneamente entre contas, criar repositórios prontos-a-usar e manter a configuração Git/SSH sempre correta.

![macOS](https://img.shields.io/badge/macos-12%2B-lightgrey?logo=apple&logoColor=white) ![GitHub release](https://img.shields.io/github/v/release/diogocostasilva/multigit?label=version) ![License](https://img.shields.io/github/license/diogocostasilva/multigit)

## ✨ Funcionalidades Principais

- **Alternância instantânea** entre contas GitHub (`multigit switch <alias>`)
- **Criação de projetos** local + remoto num único passo (`multigit new`)
- **Menu interativo** adaptado ao contexto
- **100% SSH** – sem necessidade de senha
- **Gestão automática** de identidades Git e remotes

## 🚀 Comandos Essenciais

```bash
# Criar novo repositório privado
multigit new work meu-projeto --private

# Migrar repositório existente
cd ~/meu-repo
multigit switch main

# Listar repositórios de uma conta
multigit repos work
```

| Comando | Descrição |
|---------|------------|
| `multigit` | Abre o menu interativo |
| `multigit add <alias> <user> <email> <host>` | Registra ou atualiza uma conta |
| `multigit list` | Lista contas guardadas |
| `multigit new <alias> <repo> [--private]` | Cria repo local + remoto |
| `multigit switch <alias>` | Troca a conta no repo atual |
| `multigit repos <alias>` | Lista repositórios da conta |

## 📚 Documentação Detalhada

- [⚙️ Configuração inicial](./READMEs/config.md)
- [🧠 Como funciona o multigit](./READMEs/explanation.md)
- [🛠️ Comandos disponíveis](./READMEs/commands.md)
- [📦 Extras e exemplos](./READMEs/misc.md)
- [🧭 Propósito do projeto](./READMEs/scope.md)

## 🔧 Requisitos

- Git ≥ 2.35
- GitHub CLI ≥ 2.40
- jq ≥ 1.6
- Bash ≥ 3.2 (incluído no macOS)

## 📥 Instalação Rápida

```bash
# Download e instalação
curl -fsSL https://raw.githubusercontent.com/diogocostasilva/multigit/main/multigit.sh \
-o /usr/local/bin/multigit

# Tornar executável
chmod +x /usr/local/bin/multigit

# Verificar instalação
multigit --version
```

## 📄 Licença

MIT – consulta o ficheiro [`LICENSE`](LICENSE) para mais detalhes.

---

**Multigit** – Simplifica a gestão de múltiplas identidades GitHub no teu Mac. 🚀

