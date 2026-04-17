---
name: Dan Abramov
role: ui-eng
type: individual
researched: 2026-04-16
---

# Dan Abramov

## Why they matter to the UI Eng
Dan Abramov (co-creator of Redux, ex-React core team) is the clearest thinker on *why* React is shaped the way it is. For a UI Eng productionizing Designer prototypes into Next.js App Router, Abramov's recent arc — *The Two Reacts* (2024), *React for Two Computers* (April 2025), *What Does 'use client' Do?* (April 2025), and the 2025 RSC essays — is the intellectual foundation for deciding where a component runs. On richezamor.com (Next.js), nearly every "is this a Server Component or Client Component?" judgement traces back to ideas he articulates. He does not write much Next.js-specific code, but he teaches the mental model that keeps `"use client"` boundaries tight, prevents accidental client-bundle bloat, and makes streaming, Suspense, and Server Actions feel coherent rather than magical.

## Signature works & primary sources
- *React for Two Computers* — https://overreacted.io/react-for-two-computers/ — the essay that frames RSC as "two things, one origin"; the clearest statement of the cross-boundary model.
- *What Does 'use client' Do?* — https://overreacted.io/what-does-use-client-do/ — "two worlds, two doors"; defines the directive semantically, not operationally.
- *The Two Reacts* — https://overreacted.io/the-two-reacts/ — `UI = f(data)(state)`; why server and client React are the same library specialized for different stages.
- *Why Does RSC Integrate with a Bundler?* — https://overreacted.io/why-does-rsc-integrate-with-a-bundler/ — "one does not simply serialize a module"; why `"use client"` is not just a build hint.
- *How Imports Work in RSC* — https://overreacted.io/how-imports-work-in-rsc/ — layered module system; why a server import graph is distinct from the client graph.
- *Before You memo()* — https://overreacted.io/before-you-memo/ — composition over memoization; applies in Client Component trees.

## Core principles (recurring patterns)
- **Server Components by default; `"use client"` is a doorway, not a default.** Every `"use client"` marks a boundary where data stops flowing as props and starts being serialized.
- **`UI = f(data)(state)`.** Data is fetched on the server; state lives on the client. Mixing the two concerns inside one component is usually the bug.
- **Composition beats memoization.** If a tree re-renders too much, the first move is to lift slow children out and pass them as `children` props, not `useMemo`.
- **Props are the serialization boundary.** Anything crossing a `"use client"` boundary must be serializable — so keep functions, Dates, and class instances on the server side of the line.
- **"Two computers" is literal.** When a prototype ships, draw the component tree and physically color the server half vs. the client half before writing code.
- **Directives are semantic.** `"use client"` and `"use server"` describe *where code runs and how it's imported*, not magic runtime flags.

## Concrete templates, checklists, or artifacts the agent can reuse
**Component-boundary checklist (use before productionizing a Designer prototype in Next.js):**
1. Does this component read `useState`, `useEffect`, `onClick`, browser APIs, or a React Context? If no → Server Component.
2. Does it only present data (MDX, marketing copy, product cards)? → Server Component, fetch inline with `await`.
3. Does it have interactivity concentrated in a leaf (a button, a modal trigger)? → keep the page server, put `"use client"` only on that leaf.
4. Are you passing a function prop across the boundary? → stop; either move state up, or move the function to a Server Action.

**Server/Client split skeleton:**
```tsx
// app/posts/[slug]/page.tsx — Server Component
import { getPost } from '@/lib/posts'
import LikeButton from './like-button' // "use client"

export default async function Page({ params }) {
  const post = await getPost(params.slug)
  return (
    <article>
      <h1>{post.title}</h1>
      <MDXContent source={post.body} />
      <LikeButton postId={post.id} initial={post.likes} />
    </article>
  )
}
```

**"Before you reach for useMemo" order of operations:** lift expensive children out as `children` → move state down (colocate) → split the component → *then* consider `useMemo`/`memo`.

## Where they disagree with others
- **Abramov (RSC model) vs. Carson Gross (HTMX/hypermedia):** Abramov frames the client/server split as one React program across two computers; Gross frames the browser as a hypermedia client that should never run an app VDOM at all. On richezamor.com (Next.js) Abramov wins; on SIA (Flask + HTMX) Gross wins.
- **Abramov vs. the "Redux everywhere" crowd he helped create:** post-2019 he has repeatedly de-emphasized global state stores in favor of local state, server data, and now RSC. His own historical work is the thing he most frequently argues against.
- **Abramov vs. Storybook-centric workflows:** he prefers reasoning about components in-app (where the real data and boundaries live) over isolating them in a component explorer.

## Pointers to source material
- Primary blog: https://overreacted.io
- Bluesky: https://bsky.app/profile/danabra.mov
- RSC Explorer (hobby project): https://overreacted.io/introducing-rsc-explorer/
- React docs he co-authored: https://react.dev
