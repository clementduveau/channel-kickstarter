#!/bin/bash

# Script to set up persistent aliases for the environment

echo "Setting up persistent aliases for Debian 11..."

# Define the Git alias
GIT_ALIAS='alias git='\''docker run -it --rm -v $(pwd):/git -v $HOME/.ssh:/root/.ssh alpine/git'\'''

# Define the Helm alias
HELM_ALIAS='KUBECONFIG_B64=$(cat ~/config | base64 -w 0)
alias helm='\''docker run -i --rm -v $(pwd):/apps -w /apps \
    -e KUBECONFIG_B64="$KUBECONFIG_B64" \
    -v ~/.helm:/root/.helm -v ~/.config/helm:/root/.config/helm \
    -v ~/.cache/helm:/root/.cache/helm \
    --entrypoint sh \
    alpine/helm -c "mkdir -p /root/.kube && echo \$KUBECONFIG_B64 | base64 -d > /root/.kube/config && helm \$*" --'\'''

# Check if .bashrc exists, create if it doesn't
if [ ! -f ~/.bashrc ]; then
    touch ~/.bashrc
    echo "Created ~/.bashrc"
fi

# Check if Git alias already exists in .bashrc
if ! grep -q "alias git=" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Git alias for running via Docker container" >> ~/.bashrc
    echo "$GIT_ALIAS" >> ~/.bashrc
    echo "Git alias added to ~/.bashrc"
else
    echo "Git alias already exists in ~/.bashrc"
fi

# Check if Helm alias already exists in .bashrc
if ! grep -q "alias helm=" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Helm alias for running via Docker container" >> ~/.bashrc
    echo "$HELM_ALIAS" >> ~/.bashrc
    echo "Helm alias added to ~/.bashrc"
else
    echo "Helm alias already exists in ~/.bashrc"
fi

# Also add to .bash_aliases if it exists (Debian convention)
if [ -f ~/.bash_aliases ] || [ ! -f ~/.bash_aliases ]; then
    # Create .bash_aliases if it doesn't exist
    if [ ! -f ~/.bash_aliases ]; then
        touch ~/.bash_aliases
        echo "Created ~/.bash_aliases"
    fi
    
    # Check if Git alias already exists in .bash_aliases
    if ! grep -q "alias git=" ~/.bash_aliases; then
        echo "" >> ~/.bash_aliases
        echo "# Git alias for running via Docker container" >> ~/.bash_aliases
        echo "$GIT_ALIAS" >> ~/.bash_aliases
        echo "Git alias added to ~/.bash_aliases"
    else
        echo "Git alias already exists in ~/.bash_aliases"
    fi
    
    # Check if Helm alias already exists in .bash_aliases
    if ! grep -q "alias helm=" ~/.bash_aliases; then
        echo "" >> ~/.bash_aliases
        echo "# Helm alias for running via Docker container" >> ~/.bash_aliases
        echo "$HELM_ALIAS" >> ~/.bash_aliases
        echo "Helm alias added to ~/.bash_aliases"
    else
        echo "Helm alias already exists in ~/.bash_aliases"
    fi
fi

echo ""
echo "Setup complete! The aliases have been made persistent."
echo "To apply the changes in your current session, run:"
echo "  source ~/.bashrc"
echo ""
echo "Or simply open a new terminal session."
