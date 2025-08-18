#!/bin/sh

# Script to slightly modify the Tracing workshop environment to fit the needs of the Channel Kickstarter workshop

# HELM installation
KUBECONFIG_B64=$(cat ~/config | base64 -w 0)
alias helm='docker run -i --rm -v $(pwd):/apps -w /apps \
    -e KUBECONFIG_B64="'$KUBECONFIG_B64'" \
    -v ~/.helm:/root/.helm -v ~/.config/helm:/root/.config/helm \
    -v ~/.cache/helm:/root/.cache/helm \
    --entrypoint sh \
    alpine/helm -c "mkdir -p /root/.kube && echo \$KUBECONFIG_B64 | base64 -d > /root/.kube/config && helm \$*" --'

echo "✓ Helm alias configured successfully. You can test it with: helm list"
