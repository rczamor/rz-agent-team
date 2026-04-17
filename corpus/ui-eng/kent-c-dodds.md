---
name: Kent C. Dodds
role: ui-eng
type: individual
researched: 2026-04-16
---

# Kent C. Dodds

## Why they matter to the UI Eng
Kent C. Dodds is the clearest voice on *how to structure a React app at the component level*. KCD also appears in the QA Eng corpus for Testing Library — **here, the focus is strictly React architecture**: state colocation, compound components, lifting state, composition patterns, and the "server cache vs. UI state" split. When UI Eng is productionizing a Designer prototype, the big structural questions ("where does this state live? which component owns this prop? should this be Context or a prop drilled two levels?") are the ones KCD has written about most rigorously. Epic React and the Epic Web courses codify the patterns; the blog is the reference. On richezamor.com these patterns shape every Client Component island; on SIA they matter less (HTMX handles most state via the server), but composition and colocation still apply to Jinja partials.

## Signature works & primary sources
- *State Colocation will make your React app faster* — https://kentcdodds.com/blog/state-colocation-will-make-your-react-app-faster — the canonical argument for pushing state *down* rather than lifting it up.
- *Application State Management with React* — https://kentcdodds.com/blog/application-state-management-with-react — the server-cache vs. UI-state split; why `react-query` + `useState` beats Redux for most apps.
- *Compound Components: Truly Flexible React APIs* — https://www.epicreact.dev/compound-components-truly-flexible-react-apis — implicit state sharing through `React.Children` or Context.
- *Prop Drilling* — https://kentcdodds.com/blog/prop-drilling — why it's usually fine, and when Context is the right fix.
- *When to useMemo and useCallback* — https://kentcdodds.com/blog/usememo-and-usecallback — a reminder that memoization is a cost, not a free optimization.
- Epic React — https://www.epicreact.dev — full course on React patterns, hooks, advanced component APIs.

## Core principles (recurring patterns)
- **Colocate state with the component that uses it.** State lifted to the root invalidates the whole tree on every update; state colocated invalidates a subtree. The perf fix is often *moving state down*, not adding `memo`.
- **Server cache is not UI state.** Data from the server (lists, detail records) needs caching, revalidation, and invalidation — use `react-query`/SWR. UI state (open/closed, selected tab) is plain `useState`.
- **Composition before Context before Redux.** Reach for component composition first, Context for genuinely shared UI state, and an external store only when you have actual cross-tree writes.
- **Compound components for flexible APIs.** Expose `<Menu>`, `<Menu.Button>`, `<Menu.Item>` rather than a monolithic `<Menu items={[...]}>` — consumers get layout freedom; implementors keep state private.
- **Write tests against behavior, not structure.** (Referenced here only because it directly affects component API design: components with clean a11y roles and behaviors are easier to compose.)
- **Don't sync state — derive it.** Two pieces of state that must stay in sync are one piece of state plus a derivation.

## Concrete templates, checklists, or artifacts the agent can reuse
**State-placement decision tree (run when productionizing a prototype):**
1. Only one component reads it? → `useState` inside that component. Done.
2. Siblings read it? → lift to nearest common parent.
3. Far-apart components read it, and it's UI state (theme, auth user)? → `createContext` + provider at the right subtree root.
4. It's server data? → `react-query` / `useSWR` / Next.js Server Component — not Context, not Redux.

**Compound component skeleton:**
```tsx
const DisclosureContext = createContext<{ open: boolean; toggle: () => void } | null>(null)

export function Disclosure({ children, defaultOpen = false }) {
  const [open, setOpen] = useState(defaultOpen)
  const value = useMemo(() => ({ open, toggle: () => setOpen(o => !o) }), [open])
  return <DisclosureContext.Provider value={value}>{children}</DisclosureContext.Provider>
}

Disclosure.Button = function DisclosureButton(props) {
  const ctx = useContext(DisclosureContext)!
  return <button aria-expanded={ctx.open} onClick={ctx.toggle} {...props} />
}

Disclosure.Panel = function DisclosurePanel({ children }) {
  const ctx = useContext(DisclosureContext)!
  return ctx.open ? <div>{children}</div> : null
}
```

**Two-buckets state checklist:** every piece of state answers *"server cache or UI state?"* — if the answer is "both," split it.

## Where they disagree with others
- **KCD vs. Redux-everywhere advocates:** he has argued publicly (including on X) that "`react-query` + React state" covers the vast majority of apps and that reaching for Redux is usually premature.
- **KCD vs. "lift state as high as possible" folklore:** he flipped this — the *default* should be to push state down; lift only as needed.
- **KCD vs. Storybook-driven development:** he prefers in-app reasoning and behavior tests over isolated component catalogs as the primary feedback loop (though he uses Storybook where appropriate).

## Pointers to source material
- Blog: https://kentcdodds.com/blog
- Epic React: https://www.epicreact.dev
- Epic Web: https://www.epicweb.dev
- Talks: https://kentcdodds.com/talks (especially *Managing State Management*)
