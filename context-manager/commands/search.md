---
name: search
description: Search context documents using semantic or keyword matching
arguments:
  - name: query
    description: Search query (keywords or natural language question)
    required: true
---

# /context:search

Search for relevant context documents using semantic search (qmd) or keyword matching.

## Usage

```
/context:search <query>
```

## Examples

```
/context:search monitoring setup
/context:search "how to deploy to production"
/context:search authentication OAuth integration
```

## Workflow

1. **Check for .context directory**
   ```bash
   if [ ! -d ".context" ]; then
     echo "❌ No .context directory found. Run /context:init first."
     exit 1
   fi
   ```

2. **Determine search method**
   ```bash
   if command -v qmd &> /dev/null && qmd list 2>/dev/null | grep -q "context"; then
     SEARCH_METHOD="semantic"
   else
     SEARCH_METHOD="keyword"
   fi
   ```

3. **Execute search**

   ### Semantic Search (qmd available)
   ```bash
   qmd query "$QUERY" --collection context --top-k 5
   ```

   ### Keyword Search (fallback)
   ```bash
   python "$PLUGIN_DIR/scripts/find_context.py" \
     --context-dir .context \
     --keywords $QUERY \
     --max-results 5 \
     --json
   ```

4. **Display results**
   ```
   🔍 Search: "$QUERY"
   📊 Method: [Semantic (qmd) | Keyword]

   Found 3 relevant documents:

   1. .context/monitoring/getting_started.md (0.92)
      Category: monitoring
      Summary: Getting started with monitoring setup...

   2. .context/operations/deployment.md (0.85)
      Category: operations
      Summary: Production deployment procedures...

   3. .context/guides/setup.md (0.78)
      Category: guides
      Summary: Initial project setup guide...
   ```

5. **Load top documents**
   After displaying results, read the top 2-3 documents to inform the current task:
   - Use the Read tool to load document contents
   - Summarize key points from loaded documents
   - Note any conflicts or outdated information

## Search Algorithm

### Keyword Search (find_context.py)

Uses weighted scoring:
- **Keyword matching (40%)**: filename, category name, content
- **Path-based matching (30%)**: file path overlap with category
- **Task type matching (20%)**: inferred from keywords
- **Recency (10%)**: recently modified files

### Semantic Search (qmd)

Uses embeddings for semantic similarity:
- Natural language queries supported
- Finds conceptually related documents
- Better for vague or exploratory searches

## Tips

- Use specific keywords for precise matching
- Use natural language for exploratory searches
- Combine with task type: `/context:search authentication --task-type bugfix`
- Check README.md if no relevant results found
