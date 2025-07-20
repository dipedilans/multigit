##### `~/.ssh/config` — aliases GitHub

```sshconfig
# GitHub – conta oficial
Host github-dcs
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_dcs
    IdentitiesOnly yes

# GitHub – conta de testes
Host github-dipedilans
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_dd
    IdentitiesOnly yes

# (exemplo) GitHub – conta de trabalho
# Host github-work
#     HostName github.com
#     User git
#     IdentityFile ~/.ssh/id_ed25519_work
#     IdentitiesOnly yes
```

> Ajusta o caminho das chaves e o alias quando adicionares novas contas.

