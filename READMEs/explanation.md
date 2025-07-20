## Funcionamento da CENA MANO

O Multigit guarda as contas em `~/.config/multigit/accounts`, com o formato:

```
alias|user|email|host|root
```


Isto grava/actualiza a linha correspondente em `~/.config/multigit/accounts`.

| Campo | Significado                                               |     |
| ----- | --------------------------------------------------------- | --- |
| alias | Nome curto usado nos comandos (ex.: `dipe1`).             |     |
| user  | Username no GitHub (ou GitHub Enterprise).                |     |
| email | Valor a escrever em `git config user.email`.              |     |
| host  | Alias SSH definido no `~/.ssh/config` (campo `Host`).     |     |
| root  | _(opcional)_ Pasta‑raiz para novos projectos dessa conta. |     |

Para **editar ou remover contas**:

* **Editar** – abre o ficheiro num editor (`nano ~/.config/multigit/accounts`) e altera os campos.

* **Apagar** – remove a linha correspondente ou comenta‑a com `#`.

* **Substituir rapidamente** – escolhe novamente *“Adicionar conta”* no menu com o mesmo alias: os dados serão sobre‑escritos.

As mudanças entram em vigor na próxima execução do multigit, não sendo necessário reiniciar a shell.

