import path from "node:path"
import { tool } from "@opencode-ai/plugin"

function resolveSearchRoot(inputPath: string | undefined, directory: string, worktree: string) {
  const resolved = inputPath
    ? path.resolve(path.isAbsolute(inputPath) ? inputPath : path.join(directory, inputPath))
    : worktree

  const relativeToWorktree = path.relative(worktree, resolved)
  const escapesWorktree =
    relativeToWorktree === ".." || relativeToWorktree.startsWith(`..${path.sep}`)

  if (escapesWorktree) {
    throw new Error(`path escapes worktree: ${inputPath}`)
  }

  return resolved
}

function normalizeOutput(output: string, worktree: string) {
  return output
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean)
    .map((line) => {
      const absolute = path.isAbsolute(line) ? line : path.resolve(worktree, line)
      return path.relative(worktree, absolute) || "."
    })
    .join("\n")
}

export default tool({
  description: "Find files by pattern with fd",
  args: {
    pattern: tool.schema.string().describe("Glob-style file pattern to search for"),
    path: tool.schema.string().optional().describe("Optional directory to search within"),
  },
  async execute(args, context) {
    const root = resolveSearchRoot(args.path, context.directory, context.worktree)
    const needsFullPath = !args.path && /[\\/]/.test(args.pattern)

    context.metadata({
      title: "glob",
      metadata: { pattern: args.pattern, root },
    })

    const command = needsFullPath
      ? Bun.$`fd --hidden --exclude .git --full-path --glob ${args.pattern} ${context.worktree}`
      : Bun.$`fd --hidden --exclude .git --glob ${args.pattern} ${root}`

    const output = await command.nothrow().quiet().text()
    return normalizeOutput(output, context.worktree)
  },
})
