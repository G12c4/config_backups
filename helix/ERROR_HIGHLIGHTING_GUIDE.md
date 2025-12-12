# Error Highlighting in Helix

## Built-in Features (Already Active!)

Helix has **built-in error highlighting** through LSP - no plugins needed!

### Visual Indicators

1. **Underlines**
   - 🔴 Red wavy underline = Error
   - 🟡 Yellow wavy underline = Warning
   - 🔵 Blue underline = Info/Hint

2. **Inline Diagnostics** (NEW!)
   - Shows error messages directly in the editor
   - Appears on cursor line and error lines
   - No need to check status bar

3. **Status Bar**
   - Bottom right shows: `E:2 W:3` (2 errors, 3 warnings)
   - Click or navigate to see details

4. **Gutter Icons** (left side)
   - Colored indicators next to line numbers

### Navigation Commands

```
] d          Jump to next diagnostic (error/warning)
[ d          Jump to previous diagnostic
Space d      Show diagnostic details for current line
Space D      Open diagnostic picker (all errors in file)
```

### Example Workflow

1. Open a file with errors:
   ```bash
   hx /tmp/test_errors.py
   ```

2. You'll immediately see:
   - Red/yellow underlines
   - Inline error messages
   - Error count in status bar

3. Navigate through errors:
   - Press `] d` to jump to next error
   - Press `Space d` to see full error message

4. Fix errors:
   - Press `Space a` for code actions (auto-fixes)
   - Or manually fix and save

5. Watch errors disappear in real-time!

## Error Types by Language

### Python (Ruff + MyPy + Jedi)
- ❌ Syntax errors (red)
- ⚠️ Unused imports (yellow)
- ⚠️ Naming conventions (yellow)
- ⚠️ Type mismatches (yellow/red)
- ℹ️ Style suggestions (blue)

### TypeScript
- ❌ Type errors (red)
- ❌ Syntax errors (red)
- ⚠️ Unused variables (yellow)
- ℹ️ Deprecated APIs (blue)

### Go
- ❌ Compile errors (red)
- ⚠️ Vet warnings (yellow)
- ⚠️ Unused vars (yellow)
- ℹ️ Staticcheck suggestions (blue)

## Configuration

Current settings in `~/.config/helix/config.toml`:

```toml
[editor]
# Show diagnostics inline
inline-diagnostics.cursor-line = "hint"
inline-diagnostics.other-lines = "error"

[editor.lsp]
enable = true
display-messages = true
display-inlay-hints = true
display-signature-help-docs = true
```

## Customization Options

### Show more/less diagnostics inline:

```toml
# Show all diagnostics inline
inline-diagnostics.cursor-line = "all"
inline-diagnostics.other-lines = "all"

# Show only errors inline
inline-diagnostics.cursor-line = "error"
inline-diagnostics.other-lines = "error"

# Disable inline diagnostics
inline-diagnostics.cursor-line = "disable"
inline-diagnostics.other-lines = "disable"
```

### Diagnostic Picker

Press `Space D` (capital D) to open diagnostic picker:
- Shows all errors/warnings in current file
- Fuzzy searchable
- Jump to any diagnostic instantly

## Tips

1. **Real-time feedback**: Errors appear as you type!
2. **Auto-fix**: Press `Space a` on an error for quick fixes
3. **Jump mode**: Use `] d` and `[ d` to quickly review all errors
4. **Status bar**: Always shows total error/warning count
5. **Inline messages**: Hover cursor over underlined code to see full message

## Testing

Try opening these files to see error highlighting:
```bash
hx /tmp/test_errors.py      # Python errors
hx cmd/brains/main.go        # Go errors (if any)
hx web/src/app/page.tsx      # TypeScript errors (if any)
```

## No Additional Plugins Needed!

Unlike VS Code which needs extensions, Helix has:
- ✅ Built-in LSP error highlighting
- ✅ Inline diagnostics
- ✅ Error navigation
- ✅ Auto-fix suggestions
- ✅ Real-time updates

Everything works out of the box with your LSP configuration!
