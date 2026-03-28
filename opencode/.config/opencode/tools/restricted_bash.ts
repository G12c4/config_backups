import path from "node:path"
import { tool } from "@opencode-ai/plugin"

const DISALLOWED_TOKENS = /[|&;><`$(){}\[\]]/
const ALLOWED_PREFIX = /^(make|task)(\s+.+)?$/

function resolveRunDirectory(inputPath: string | undefined, directory: string, worktree: string) {
  const resolved = inputPath
    ? path.resolve(path.isAbsolute(inputPath) ? inputPath : path.join(directory, inputPath))
    : directory

  const relativeToWorktree = path.relative(worktree, resolved)
  const escapesWorktree =
    relativeToWorktree === ".." || relativeToWorktree.startsWith(`..${path.sep}`)

  if (escapesWorktree) {
    throw new Error(`workdir escapes worktree: ${inputPath}`)
  }

  return resolved
}

function validateCommand(command: string) {
  const trimmed = command.trim()

  if (!trimmed) {
    throw new Error("blocked: command is empty")
  }

  if (DISALLOWED_TOKENS.test(trimmed)) {
    throw new Error("blocked: shell metacharacters are not allowed; use a single make/task command")
  }

  if (!ALLOWED_PREFIX.test(trimmed)) {
    throw new Error("blocked: only `make ...` and `task ...` are allowed")
  }

  return trimmed
}

export default tool({
  description: "Test restricted shell execution",
  args: {
    command: tool.schema.string().describe("Command to run"),
    workdir: tool.schema.string().optional().describe("Optional working directory inside the worktree"),
  },
  async execute(args, context) {
    const command = validateCommand(args.command)
    const workdir = resolveRunDirectory(args.workdir, context.directory, context.worktree)

    context.metadata({
      title: "restricted_bash",
      metadata: { command, workdir },
    })

    const result = await Bun.$`${{ raw: command }}`.cwd(workdir).nothrow().quiet()
    const stdout = result.stdout.toString().trimEnd()
    const stderr = result.stderr.toString().trimEnd()

    if (result.exitCode !== 0) {
      return [
        `exitCode: ${result.exitCode}`,
        stdout ? `stdout:\n${stdout}` : "stdout:",
        stderr ? `stderr:\n${stderr}` : "stderr:",
      ].join("\n")
    }

    return stdout || stderr || "ok"
  },
})
