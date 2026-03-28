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

function normalizeMatches(output: string, searchRoot: string, worktree: string) {
  return output
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean)
    .map((line) => {
      const parts = line.split(":")
      if (parts.length < 3) return line
      const [filePath, lineNumber, ...rest] = parts
      const absolute = path.isAbsolute(filePath) ? filePath : path.resolve(searchRoot, filePath)
      return `${path.relative(worktree, absolute)}:${lineNumber}:${rest.join(":")}`
    })
    .join("\n")
}

export default tool({
  description: "Search file contents with ripgrep",
  args: {
    pattern: tool.schema.string().describe("Regular expression to search for"),
    path: tool.schema.string().optional().describe("Optional directory to search within"),
    include: tool.schema.string().optional().describe("Optional file glob filter"),
  },
  async execute(args, context) {
    const root = resolveSearchRoot(args.path, context.directory, context.worktree)

    context.metadata({
      title: "grep",
      metadata: { pattern: args.pattern, root, include: args.include ?? null },
    })

    const command = args.include
      ? Bun.$`rg --line-number --no-heading --color=never --hidden --glob ${args.include} ${args.pattern} .`.cwd(root)
      : Bun.$`rg --line-number --no-heading --color=never --hidden ${args.pattern} .`.cwd(root)

    const output = await command.nothrow().quiet().text()
    return normalizeMatches(output, root, context.worktree)
  },
})
