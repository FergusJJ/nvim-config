# Neovim Config

### Solidity Setup (Ubuntu)
```bash
# Install Solidity compiler
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
```

### Note for XCode references:
- sometimes neovim fails to resolve references, if a rebuild (<leader>xb) doesn't fix this then do:
    -  Open project in XCode
    -  Clean build (Cmd+shift+K)
    -  rm buildserver.json
    -  regenerate using
    ```bash
        xcode-build-server config -project <XXX>.xcodeproj -scheme <XXX>
    ```
