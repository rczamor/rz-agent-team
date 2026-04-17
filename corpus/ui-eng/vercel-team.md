---
name: Vercel team (Lee Robinson, Delba de Oliveira, Guillermo Rauch)
role: ui-eng
type: organization
researched: 2026-04-16
---

# Vercel team (Lee Robinson, Delba de Oliveira, Guillermo Rauch)

## Why they matter to the UI Eng
Next.js is the framework for richezamor.com, so the Vercel team is the *normative* source on App Router architecture — what a page file should look like, where to put `loading.tsx` and `error.tsx`, when to cache, when to opt out, how Server Actions differ from Route Handlers, how to stream. Lee Robinson (VP DX) writes the most accessible practical guides; Delba de Oliveira authored much of the App Router documentation and the RSC educational content; Guillermo Rauch (CEO) articulates the higher-level infra picture (edge, streaming, ISR, PPR). For a UI Eng productionizing Designer prototypes, this team's docs and blog posts are the first reference for framework-level decisions — and the source of truth for Next.js 16 features like Cache Components, `use cache`, `cacheLife`, and `cacheTag`.

## Signature works & primary sources
- Next.js App Router docs — https://nextjs.org/docs/app — canonical reference for layouts, pages, loading, error, Server Actions, caching.
- Lee Robinson's blog — https://leerob.com — practical Next.js patterns, auth, data fetching, real-world examples.
- Vercel Blog — https://vercel.com/blog — release notes, migration guides, patterns (PPR, Fluid Compute, AI Gateway).
- *Making Next.js the best way to build the web* — Guillermo Rauch keynotes from Next.js Conf — frames the "the framework handles the boring, correct parts" thesis.
- Delba's App Router learn course — https://nextjs.org/learn/dashboard-app — the canonical hands-on intro to RSC, Server Actions, and streaming.

## Core principles (recurring patterns)
- **Server Components by default; push `"use client"` down to the leaves.** Pages, layouts, and data-fetching wrappers stay server; interactivity is a leaf concern.
- **Colocate file-system conventions with routes.** `loading.tsx`, `error.tsx`, `not-found.tsx`, `route.ts`, `layout.tsx`, `page.tsx` — the directory *is* the architecture.
- **Stream what's slow.** Wrap slow server components in `<Suspense>`; the rest of the page renders immediately. Don't block the shell for an async product recommendation.
- **Cache explicitly.** In Next.js 16, `use cache` + `cacheLife` + `cacheTag` are the primitives; don't rely on implicit fetch caching as a design — state the cache policy.
- **Server Actions for mutations; Route Handlers for public APIs.** Progressive-enhancement form submissions should be Server Actions, not client-side `fetch` + `/api/*`.
- **Edge where latency matters, Node where the ecosystem matters.** Default to Node runtime; opt into Edge for geo-distributed reads and middleware.

## Concrete templates, checklists, or artifacts the agent can reuse
**Page skeleton with loading, error, streaming:**
```
app/
  (marketing)/
    layout.tsx           # shared nav/footer
    page.tsx             # landing
  posts/
    [slug]/
      page.tsx           # Server Component, async
      loading.tsx        # skeleton, shown immediately
      error.tsx          # 'use client' — error boundary
      opengraph-image.tsx
```

```tsx
// app/posts/[slug]/page.tsx
import { Suspense } from 'react'
import { getPost } from '@/lib/posts'
import Comments from './comments' // slow

export default async function PostPage({ params }) {
  const post = await getPost(params.slug)
  return (
    <>
      <article>{/* fast path */}</article>
      <Suspense fallback={<CommentsSkeleton />}>
        <Comments postId={post.id} />
      </Suspense>
    </>
  )
}
```

**Server Action form (progressive enhancement, no client JS required for happy path):**
```tsx
// app/contact/page.tsx
async function submit(formData: FormData) {
  'use server'
  await sendEmail({
    from: String(formData.get('email')),
    body: String(formData.get('message')),
  })
}

export default function Page() {
  return (
    <form action={submit}>
      <input type="email" name="email" required />
      <textarea name="message" required />
      <button>Send</button>
    </form>
  )
}
```

**Next.js pre-deploy checklist:** `next build` clean → no accidental `"use client"` on data-fetching parents → `loading.tsx` on every dynamic route → `next/image` with explicit width/height → `next/font` for all web fonts → metadata exported → Lighthouse > 90 on mobile.

**Image-component pattern:** always `next/image` with `alt`, explicit `width`/`height` (avoids CLS), `priority` only on above-the-fold hero, `sizes` on responsive images.

## Where they disagree with others
- **Vercel (edge-everywhere, serverless, managed infra) vs. self-hosted simplicity:** the default posture assumes a Vercel-class deploy target; on a plain VPS (SIA's Hostinger box) Edge Functions, ISR, and image optimization aren't free — UI Eng must know when to opt out.
- **Vercel vs. Remix/React Router:** both now ship Server Components, but Next.js leans on caching primitives (`use cache`, tag revalidation) while React Router leans on loaders/actions and browser navigation semantics.
- **Vercel vs. HTMX/hypermedia:** Next.js assumes a heavy JS runtime is a given and optimizes within that; HTMX rejects that premise. Different stacks, not a winner.

## Pointers to source material
- Docs: https://nextjs.org/docs
- Learn course: https://nextjs.org/learn
- Lee Robinson: https://leerob.com
- Guillermo Rauch: https://rauchg.com
- Vercel blog: https://vercel.com/blog
- Next.js Conf talks: https://nextjs.org/conf
