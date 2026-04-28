# My Neovim configuration
This is the result of a complete rebuild of my Neovim configuration from the ground up, back in August 2025. This configuration is built around the Lazy.nvim plugin manager.

## Prerequisites
- `nvim` 0.12.2+
- A compiler + dev headers/libraries for compiling Treesitter parser binaries, for example:
    - `apt install build-essential` on Ubuntu
    - [MSVC](https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line) on Windows
- `tree-sitter-cli`, which can be installed via one of the following:
    - `brew install tree-sitter-cli`
    - `cargo binstall tree-sitter-cli` (per [the official docs](https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli#installation))

## Installation
**Linux/macOS**
```bash
mkdir -p ~/.config
git clone https://www.github.com/wilkystyle/nvim ~/.config/nvim
```

**Windows (PowerShell):**
```powershell
git clone https://www.github.com/wilkystyle/nvim $env:LOCALAPPDATA\nvim
```

**Windows (Command Prompt/cmd.exe):**
```
git clone https://www.github.com/wilkystyle/nvim %LOCALAPPDATA%\nvim
```


## Usage
On first launch, the [Lazy.nvim](https://github.com/folke/lazy.nvim) package manager will install plugins and compile Treesitter parsers.

**Optional: Install LSP servers with Mason**
1. Run `:Mason`
2. Choose LSP servers to install

That's all you need to do. This configuration uses [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim), which will automatically enable any installed LSP servers.


## Misc

### Test-drive this configuration (Linux, macOS)
If you just want to try this configuration temporarily without any permanent changes to your existing config:

```bash
mkdir ~/.config
git clone https://www.github.com/wilkystyle/nvim ~/.config/nvim-testdrive

# NVIM_APPNAME assumes the supplied directory exists in ~/.config/
NVIM_APPNAME=nvim-testdrive nvim
```
