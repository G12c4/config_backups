# Helix Language Server Features

## Installed Language Servers

### Python (pylsp + Ruff)
- **Formatter**: Ruff (ultra-fast, replaces Black + isort + Flake8)
- **Linter**: Ruff via pylsp plugin
- **Type Checker**: MyPy
- **Intelligence**: Jedi (completion, hover, references)
- **Config**: Line length 100, auto-fix enabled
- **Speed**: 10-100x faster than Black!

### JavaScript/TypeScript (typescript-language-server)
- **Features**: Completion, hover, references, formatting, type checking
- **Formatter**: Prettier
- **Supports**: .js, .ts, .jsx, .tsx files

### Go (gopls)
- **Features**: Completion, hover, references, formatting, inlay hints
- **Formatter**: gofmt
- **Enhanced**: Static analysis, nil checks, unused param detection

## Ruff Features

Ruff combines multiple tools into one:
- **Formatter** (replaces Black)
- **Linter** (replaces Flake8, isort, pyupgrade, etc.)
- **Auto-fixer** (fixes most issues automatically)

Check `ruff.toml` in your project root for configuration.

## LSP Commands in Helix

### Code Actions
- `Space a` - Show code actions (quick fixes, refactorings)
  - For Python: auto-fixes import sorting, unused imports, etc.

### Navigation
- `g d` - Go to definition
- `g y` - Go to type definition
- `g r` - Go to references
- `g i` - Go to implementation
- `Space s` - Symbol picker (current file)
- `Space S` - Workspace symbol picker

### Information
- `K` - Show hover information/documentation
- `Space k` - Show signature help

### Formatting
- `Space f` - Format current file (uses Ruff for Python)
- Auto-formats on save (enabled by default)

### Diagnostics (Errors/Warnings)
- `] d` - Next diagnostic
- `[ d` - Previous diagnostic
- `Space d` - Show diagnostic line info
- `Space D` - Show all diagnostics in picker

### Rename
- `Space r` - Rename symbol under cursor

### Code Lens
- Inlay hints enabled for Go (type hints, parameter names)

## Testing Your Setup

### Test Python with Ruff
```bash
hx /tmp/test.py
```
Type some Python code with bad formatting:
```python
import sys
def foo(x,y):
    return x+y
```
Save (`:w`) and watch Ruff auto-format it!

Try `Space a` for code actions like removing unused imports.

### Test TypeScript LSP
```bash
hx test.ts
```
Type TypeScript code and use LSP features

### Test Go LSP
```bash
hx cmd/brains/main.go
```
Open a Go file from your project and see:
- Inlay hints for types
- Hover documentation
- Jump to definition

## Configuration Files

- Main config: `~/.config/helix/config.toml`
- Languages: `~/.config/helix/languages.toml`
- Ruff config: `ruff.toml` (in project root)

## Check Language Server Health

```bash
hx --health python
hx --health typescript
hx --health go
```

## Manual Ruff Commands

```bash
ruff format file.py          # Format file
ruff check file.py           # Lint file
ruff check --fix file.py     # Lint and auto-fix
ruff check --watch .         # Watch mode
```

## Tips

1. **Auto-format on save**: Already enabled for Python (Ruff), TypeScript (Prettier), Go (gofmt)
2. **Ruff is FAST**: Formats entire codebases in milliseconds
3. **Multiple cursors**: Use `C` to duplicate cursor down, `Alt-C` to duplicate up
4. **LSP restart**: Close and reopen file, or restart Helix
5. **Logs**: Check `~/.cache/helix/helix.log` for debugging
6. **Ruff rules**: Edit `ruff.toml` to enable/disable specific lint rules
