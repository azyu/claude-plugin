# Prompt Patterns

Proven patterns for common prompt engineering scenarios.

## Chain-of-Thought (CoT)

**When to use:** Complex reasoning, math, multi-step logic, analysis tasks.

**Why it works:** Forces the model to show intermediate steps, reducing errors in final output.

**Template:**
```
[Task description]

Think through this step by step:
1. First, identify [relevant factors]
2. Then, analyze [relationships]
3. Finally, conclude [answer]

Show your reasoning for each step.
```

**Example:**
```
A store has 3 types of fruit. Apples cost $2, bananas cost $1, and oranges cost $3.
If I buy 4 apples, 6 bananas, and 2 oranges, how much do I spend?

Think through this step by step before giving the final answer.
```

---

## Few-Shot Learning

**When to use:** Format calibration, style matching, classification, consistent output patterns.

**Why it works:** Examples define the expected behavior more precisely than instructions.

**Template:**
```
[Task description]

Examples:

Input: [example 1 input]
Output: [example 1 output]

Input: [example 2 input]
Output: [example 2 output]

Input: [actual input]
Output:
```

**Best practices:**
- Use 2-3 examples (diminishing returns beyond 5)
- Choose diverse examples covering edge cases
- Keep example format identical to desired output
- Order examples from simple to complex

---

## Role-Based Prompting

**When to use:** Domain expertise needed, specific perspective required, tone control.

**Why it works:** Activates relevant knowledge patterns and constrains the response style.

**Template:**
```
You are a [specific role] with [years] of experience in [domain].
Your expertise includes [specific areas].

[Task description]

Respond as this expert would, focusing on [priority areas].
```

**Tips:**
- Be specific: "senior backend engineer" > "engineer"
- Add experience markers: "10 years of production experience"
- Define scope: "specializing in distributed systems"
- Avoid impossible roles: don't claim access to private data or systems

---

## Structured Output

**When to use:** Data extraction, API responses, reports, any output that needs parsing.

**Why it works:** Explicit structure prevents format drift and ensures completeness.

**Template:**
```
[Task description]

Return your response in the following format:

## Summary
[1-2 sentence overview]

## Findings
- Finding 1: [description]
- Finding 2: [description]

## Recommendation
[Actionable next step]

## Confidence
[High/Medium/Low] — [Brief justification]
```

**For JSON output:**
```
Return a JSON object with this exact structure:
{
  "category": "string",
  "confidence": "number between 0 and 1",
  "reasoning": "string explaining the classification"
}

Return ONLY the JSON object, no additional text.
```

---

## Task Decomposition

**When to use:** Complex multi-part tasks, long documents, tasks requiring different skills.

**Why it works:** Smaller focused tasks produce higher quality than a single complex prompt.

**Template:**
```
Phase 1 — Analysis:
[Specific analysis task]

Phase 2 — Synthesis:
Using the analysis from Phase 1, [synthesis task]

Phase 3 — Output:
Format the results as [output format]
```

**Chaining pattern:**
```
Prompt 1: "Extract all technical requirements from this document"
→ Output becomes input for:
Prompt 2: "Categorize these requirements by priority and feasibility"
→ Output becomes input for:
Prompt 3: "Create a sprint plan from these prioritized requirements"
```

---

## Self-Evaluation

**When to use:** Quality-critical outputs, creative work, decisions with consequences.

**Why it works:** The model catches its own errors when explicitly asked to review.

**Template:**
```
[Task description]

After completing your response:
1. Rate your output on [criteria] from 1-10
2. Identify the weakest part of your response
3. If your rating is below 8, revise that section
4. Explain what you improved and why
```

**Variation — Adversarial self-review:**
```
First, write [the output].
Then, act as a critic and identify 3 weaknesses.
Finally, write an improved version addressing those weaknesses.
```

---

## Constrained Generation

**When to use:** Strict format requirements, character limits, vocabulary restrictions, compliance.

**Why it works:** Explicit constraints prevent the model from defaulting to verbose, generic responses.

**Template:**
```
[Task description]

Constraints:
- Maximum [N] words/sentences/paragraphs
- Must include: [required elements]
- Must NOT include: [excluded elements]
- Vocabulary level: [target audience]
- Tone: [specific tone]
```

**Example:**
```
Write a tweet about our new product launch.

Constraints:
- Maximum 280 characters
- Must include the product name "CloudSync"
- Must include one emoji
- Tone: excited but professional
- Do NOT use: "revolutionary", "game-changing", or "unprecedented"
```

---

## Persona + Audience

**When to use:** Communication tasks, documentation, teaching, customer-facing content.

**Why it works:** Dual-anchoring on both speaker and listener produces appropriate content.

**Template:**
```
You are a [persona] explaining [topic] to [audience].

The audience:
- Knows: [existing knowledge]
- Doesn't know: [gaps]
- Cares about: [priorities]
- Prefers: [communication style]

[Task description]
```

---

## Pattern Selection Guide

| Task Type | Primary Pattern | Supporting Pattern |
|-----------|----------------|-------------------|
| Analysis | Chain-of-Thought | Self-Evaluation |
| Classification | Few-Shot | Structured Output |
| Creative writing | Role-Based | Constrained Generation |
| Data extraction | Structured Output | Few-Shot |
| Decision support | Chain-of-Thought | Persona + Audience |
| Documentation | Role-Based | Task Decomposition |
| Code generation | Role-Based | Structured Output |
| Summarization | Constrained Generation | Chain-of-Thought |
