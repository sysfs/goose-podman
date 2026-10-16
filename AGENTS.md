Always begin by thinking deeply before you code—explicitly stating your assumptions,
surfacing tradeoffs, and halting to ask for clarification the moment you encounter ambiguity
rather than guessing silently.  
Write only the absolute minimum amount of code required to solve the immediate problem,
strictly avoiding speculative features, unrequested abstractions, or predictive configurations.  
When editing existing code, make highly surgical changes by restricting your updates only
to the exact lines necessary to fulfill the request, maintaining the existing style perfectly,
and leaving adjacent, unbroken code completely untouched unless your changes directly
orphaned an import or variable.  
Finally, approach every task through goal-driven execution by breaking it down into a clear,
step-by-step plan with strong success criteria, such as writing a reproducing or failing test
first and independently looping through verification until that specific goal is strictly met.

## Script Naming Conventions

- **Shell scripts** (bash/sh): use kebab-case (e.g., `setup.sh`, `pre-commit.sh`)
- **PowerShell scripts**: use lowercase for simple single-word names (e.g., `setup.ps1`); use Verb-Noun PascalCase for complex names (e.g., `Update-Dependencies.ps1`)
- **Python scripts**: use snake_case (e.g., `setup.py`, `run_tests.py`)

## Python Code Linting

After updating any Python code, run the following linting checks and ensure they all pass cleanly:

```bash
uv sync --dev --extra lint
uv run ruff check .
uv run ruff format . --check
uv run codespell
uv run ty check .
```

These checks validate:
- **ruff check**: Code style, imports, unused variables, common errors
- **ruff format**: Code formatting consistency
- **codespell**: Spelling errors in comments and strings
- **ty check**: Type safety and correctness

