# Global OpenCode Agent Instructions

## Core Project Rules
- **Respect Architecture:** Always adhere strictly to the established project rules, architecture, and design patterns found in the codebase. You must always read the `README.md` file to understand the project context, structure, and setup before beginning any work.
- **Task Management:** Always use the commands defined in the `Makefile` or `Taskfile` for building, linting, or running tasks. Do not invent custom build commands.
- **Test-Driven Delivery:** Before declaring any feature, bug fix, or change as "done," you must always run the existing tests and update them (or write new ones) to cover your changes. Also use the built in playwright browser to test the new feature.
- **Small Reusable Components with props:** When building new features or improving existing ones on the frontend we will always use small, reusable, proffesional componets with props instead of huge all in one files. Check out the current componnet structure.
