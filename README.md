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

Next you can optionally run `:Mason` and install LSP servers for any languages you plan to work in. I mostly work in Python, so I install `pylsp` and `ruff` (Note: not `ruff-lsp`, which is deprecated). Because my configuration uses `mason-lspconfig`, you don't need to do anything else. Mason will automatically enable any LSP servers you install.
