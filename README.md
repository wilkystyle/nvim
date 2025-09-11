# August 2025 Neovim config rebuild

## Prerequisites
- `nvim` 0.11.4-ish (definitely doesn't work on <0.10.0)
- `gcc` for compiling Treesitter parser binaries

## Installation
```bash
mkdir -p ~/.config
git clone https://www.github.com/wilkystyle/nvim ~/.config/nvim
```

## Usage
On first launch, the Lazy.nvim package manager will install plugins and compile Treesitter parsers.

### Optional: Install LSP servers with Mason
1. Run `:Mason`
2. Choose LSP servers to install

That's all you need to do. This configuration uses [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim), which will automatically enable any installed LSP servers.
