# Triage Criteria

## Decision Tree

```
Has workspace detection while-loop in SKILL.md?
  │
  ├─ YES → scriptable entry point. Check further:
  │         Has state.json writes or template creation? → hybrid
  │         Only path resolution?                       → state-machine
  │
  └─ NO  → Check primary job:
            Generates text via LLM conversation?        → content-core (skip)
            Documents a methodology/process?            → guidance (skip)
            Has state.json writes but no loop?          → hybrid
```

## Categories

### state-machine
Entire skill is deterministic routing. No LLM content needed.

Example: a dispatcher skill that reads `state.json` and outputs which skill to invoke.

Optimization: replace entire body with script output → LLM just routes.

### hybrid
Mix of scriptable boilerplate + LLM content generation.

Example: quiz skill — skeleton creation and state update are scriptable; matrix content needs LLM.

Optimization: scripts handle boilerplate, SKILL.md shrinks to content-only instructions.

### content-core
LLM text generation IS the job. No meaningful boilerplate to extract.

Examples: brainstorming (conversational), retrospective (learning extraction), writing-plans (plan authoring).

Decision: skip.

### guidance
Methodology documentation. No state, no generation.

Examples: TDD, systematic-debugging, receiving-code-review.

Decision: skip.

## Override Rules

- If a skill generates content AND has >10 lines of bash/python boilerplate in SKILL.md → treat as hybrid even if content-core.
- If a script already exists for a pattern, do not duplicate it. Reference the existing script.
- Guidance skills with a precondition check (e.g., `cat state.json`) are not hybrid — one read is not boilerplate.
