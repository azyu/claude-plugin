# Anti-Patterns

Common prompt engineering mistakes, why they fail, and how to fix them.

---

## 1. Vague Instructions

**Problem:** Ambiguous wording lets the model choose any interpretation.

**Bad:**
```
Make this better.
```

**Why it fails:** "Better" has no measurable criteria. The model guesses what you want.

**Fix:**
```
Improve this product description by:
- Reducing word count to under 80 words
- Leading with the primary customer benefit
- Adding a clear call-to-action
```

---

## 2. Missing Role

**Problem:** No persona means the model uses a generic voice.

**Bad:**
```
Review this code for issues.
```

**Why it fails:** Without a defined perspective, the review will be shallow and unfocused.

**Fix:**
```
You are a senior security engineer. Review this code for:
- SQL injection vulnerabilities
- Improper input validation
- Authentication/authorization flaws

For each issue found, provide: location, severity (Critical/High/Medium/Low), and fix.
```

---

## 3. No Format Specification

**Problem:** Output structure is unpredictable without explicit formatting.

**Bad:**
```
Compare React and Vue.
```

**Why it fails:** Could produce an essay, a list, a table, or anything in between.

**Fix:**
```
Compare React and Vue in a table with these columns:
| Criteria | React | Vue | Winner |

Cover: learning curve, ecosystem, performance, hiring market, TypeScript support.
Add a 2-sentence recommendation at the end.
```

---

## 4. Over-Constraining

**Problem:** Too many rules conflict with each other or leave no room for useful output.

**Bad:**
```
Write a blog post about AI. It must be exactly 500 words. Use no jargon.
Include at least 10 technical terms. Be accessible to beginners. Include
expert-level analysis. Keep sentences under 15 words. Use varied sentence
length. Don't use passive voice. Include passive constructions for academic
tone. Be conversational. Maintain formal register.
```

**Why it fails:** Contradictory constraints make the task impossible. The model thrashes between conflicting rules.

**Fix:** Prioritize constraints. Remove contradictions:
```
Write a 400-600 word blog post about AI for a general audience.
Tone: conversational but informed.
When using technical terms, define them in parentheses.
Focus on practical impact rather than theory.
```

---

## 5. Context Overload

**Problem:** Dumping excessive irrelevant information dilutes the signal.

**Bad:**
```
Here's our entire company wiki [50 pages]. What should we name our new product?
```

**Why it fails:** The model struggles to identify what's relevant in noise. Key information gets lost.

**Fix:**
```
We're naming a new cloud storage product. Key factors:
- Target: small business owners (non-technical)
- Brand values: simplicity, reliability, affordability
- Competitors: Dropbox, Google Drive, OneDrive
- Avoid: technical jargon, names similar to competitors

Generate 5 name options with rationale for each.
```

---

## 6. Negative-Only Instructions

**Problem:** Telling the model what NOT to do without saying what TO do.

**Bad:**
```
Don't be wordy. Don't use bullet points. Don't be too formal.
Don't include examples. Don't repeat yourself.
```

**Why it fails:** Negative constraints eliminate options but don't guide toward a goal. The model has to guess your intent through exclusion.

**Fix:**
```
Write in concise paragraphs (2-3 sentences each).
Use a conversational tone similar to a tech blog.
State each point once and move on.
```

---

## 7. Assumed Context

**Problem:** The prompt assumes knowledge the model doesn't have.

**Bad:**
```
Update the dashboard like we discussed.
```

**Why it fails:** The model has no memory of previous conversations (unless context is provided). References to "we discussed" point to nothing.

**Fix:**
```
Update the sales dashboard:
- Add a date range filter (default: last 30 days)
- Replace the pie chart with a stacked bar chart
- Add a "Total Revenue" card at the top
- Data source: /api/sales endpoint
```

---

## 8. Kitchen-Sink Prompting

**Problem:** Cramming multiple unrelated tasks into one prompt.

**Bad:**
```
Write a blog post about React, also create a tweet about it,
and generate 5 SEO keywords, plus write an email to our newsletter
subscribers about it, and suggest 3 YouTube video titles.
```

**Why it fails:** Quality degrades when the model splits attention across many tasks. Later tasks get less attention than earlier ones.

**Fix:** One prompt per task, or use explicit task decomposition:
```
Task 1: Write a 300-word blog post about React Server Components.
Task 2: Based on the blog post, write a promotional tweet (max 280 chars).
Task 3: Generate 5 SEO keywords for the blog post.
```

---

## 9. Premature Optimization

**Problem:** Adding complexity before testing the simple version.

**Bad approach:**
```
First attempt: 200-line prompt with 15 constraints, 5 examples,
3 output formats, error handling, and edge cases.
```

**Why it fails:** You can't tell which parts help and which hurt. Debugging is impossible.

**Fix:** Start simple. Add constraints only when output deviates:
```
Iteration 1: "Summarize this article in 3 bullet points."
→ Output is too long? Add: "Each bullet: one sentence, max 20 words."
→ Missing key points? Add: "Focus on methodology, findings, and implications."
→ Wrong tone? Add: "Write for a scientific audience."
```

---

## 10. Ignoring Model Strengths

**Problem:** Using the model for tasks it's bad at, or not leveraging what it's good at.

**Common mistakes:**
- Asking for real-time data (models have knowledge cutoffs)
- Asking for precise math on large numbers (use code instead)
- Asking for URL verification (models can't browse)
- Not using structured reasoning for analysis tasks
- Not using few-shot examples for classification tasks

**Fix:** Match the task to the model's strengths:
```
# Instead of: "What's the current stock price?"
# Use: "Based on the financial data I'll provide, analyze trends..."

# Instead of: "Calculate 847,293 x 38,461"
# Use: "Write Python code to calculate 847,293 x 38,461"

# Instead of bare classification:
# Use few-shot examples to calibrate
```

---

## Quick Detection Checklist

| Symptom | Likely Anti-Pattern |
|---------|-------------------|
| Output is unpredictable | Vague instructions, no format spec |
| Output is generic/shallow | Missing role, no context |
| Output contradicts itself | Over-constraining |
| Output misses the point | Assumed context, context overload |
| Output quality inconsistent | Kitchen-sink, no few-shot examples |
| Output ignores constraints | Too many constraints, conflicting rules |
| Output is wrong format | No format specification |
| Model says "I can't" | Ignoring model strengths |
