# Bootstrap the environment

This exercise reuses components from another workshop. Run the following command to set up your environment:

```bash
eval "$(curl -sSL https://raw.githubusercontent.com/YOUR_REPO/main/bootstrap/bootstrap.sh)"
```

This will configure your environment with the necessary tools and aliases for the workshop.

## What gets configured:

- **Helm**: Creates an alias to run Helm via Docker container (since direct package installation is not allowed)
