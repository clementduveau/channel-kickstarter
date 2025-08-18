# Bootstrap the environment

This exercise reuses components from another workshop. Run the following command to set up your environment

```bash
eval "$(docker run --rm curlimages/curl:8.15.0 -sSL https://raw.githubusercontent.com/clementduveau/channel-kickstarter/main/bootstrap/bootstrap.sh)"
```

It will set:
- `git`
- `helm`

---

```bash
alias git='docker run -it --rm -v $(pwd):/git -v $HOME/.ssh:/root/.ssh alpine/git'
```

```bash
eval "$(docker run --rm curlimages/curl:8.15.0 -sSL https://raw.githubusercontent.com/clementduveau/channel-kickstarter/main/bootstrap/bootstrap.sh)"
```

Creates an alias to run Git via Docker container. This allows you to clone repositories and perform Git operations without installing Git directly. 

Example usage:
```bash
git clone https://github.com/your-repo/your-project.git
git status
git pull
```

## Helm:

```bash
KUBECONFIG_B64=$(cat ~/config | base64 -w 0)
alias helm='docker run -i --rm -v $(pwd):/apps -w /apps \
    -e KUBECONFIG_B64="'$KUBECONFIG_B64'" \
    -v ~/.helm:/root/.helm -v ~/.config/helm:/root/.config/helm \
    -v ~/.cache/helm:/root/.cache/helm \
    --entrypoint sh \
    alpine/helm -c "mkdir -p /root/.kube && echo \$KUBECONFIG_B64 | base64 -d > /root/.kube/config && helm \$*" --'
```

Creates an alias to run Helm via Docker container (since direct package installation is not allowed). Test with `helm version`

## Making Aliases Persistent

To make the above aliases persistent across shell sessions on Debian 11, run the setup script:

```bash
cd bootstrap
chmod +x setup-aliases.sh
./setup-aliases.sh
```

This script will:
- Add both Git and Helm aliases to your `~/.bashrc` and `~/.bash_aliases` files
- Ensure the aliases are available in all new terminal sessions
- Avoid duplicate entries if run multiple times

After running the script, either:
- Open a new terminal session, or
- Run `source ~/.bashrc` to apply changes in the current session

You can then verify the aliases are working with:
```bash
git --version
helm version
```
