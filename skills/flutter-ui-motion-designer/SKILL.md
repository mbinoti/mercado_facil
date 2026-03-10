---
name: flutter-ui-motion-designer
description: Create or refine visually strong Flutter screens with deliberate layout, typography, color, component composition, and purposeful animation for both iOS and Android. Use when Codex needs to design, polish, or review Flutter UI for onboarding, auth, dashboards, product or catalog screens, detail pages, empty states, or animated interactions, especially when the user asks for beautiful screens, stronger visual direction, better UX polish, platform-appropriate mobile UI, or Flutter animations.
---

# Flutter Ui Motion Designer

## Overview

Create Flutter UI that feels directed rather than generic. Start from the product task and current design language, define a clear visual concept, then implement responsive screens and animations that improve focus, feedback, and flow.

## Workflow

1. Audit the current app before designing.
   - Inspect `ThemeData`, color tokens, text styles, spacing patterns, reusable widgets, and route transitions.
   - Read product or feature docs when present, especially `docs/project-context.md`, `docs/README.md`, and feature specs under `docs/`.
   - Reuse the existing visual language if it is coherent. Only introduce a new direction when the screen is isolated or the current UI is clearly incomplete.

2. Define a visual concept before writing widgets.
   - Summarize the intended look in 2 or 3 traits such as `clean, energetic, retail-first` or `premium, calm, editorial`.
   - Choose a restrained palette, spacing rhythm, corner radius scale, and typography hierarchy.
   - Prefer contrast, whitespace, alignment, and grouping over decorative clutter.

3. Structure the screen around hierarchy and action.
   - Lead with the primary user task.
   - Make important numbers, statuses, and calls to action visually dominant.
   - Avoid generic centered columns, repeated cards, or empty decoration unless they help the task.
   - Design for small phones first, then widen gracefully.

4. Add motion with intent.
   - Animate state changes, focus shifts, confirmation feedback, and route transitions.
   - Prefer built-in Flutter APIs for most work: `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSlide`, `AnimatedScale`, `AnimatedSwitcher`, `TweenAnimationBuilder`, `Hero`.
   - Use explicit `AnimationController` only when sequencing, choreography, or custom curves are required.
   - Keep motion subtle enough that content stays readable and interaction remains fast.

5. Implement production-ready Flutter code.
   - Keep screen composition readable; extract sections and reusable widgets once structure stabilizes.
   - Drive styles from theme or tokens instead of hardcoding every value.
   - Use packages for motion only when the project already depends on them or the effect clearly justifies the dependency.
   - Make the result feel correct on both iOS and Android, adapting navigation chrome, safe areas, touch targets, and motion tone when platform differences materially affect the experience.
   - Preserve accessibility, semantics, and scroll performance.

6. Validate the result.
   - Check overflow, keyboard behavior, safe areas, loading or empty or error states, and responsiveness.
   - Run `flutter analyze` after meaningful UI work.
   - If possible, add or update widget tests for the critical visible state.

## Design Rules

- Start with one strong focal area per screen.
- Use one primary accent color and a small set of supporting neutrals.
- Build depth with scale, spacing, tone, and restrained shadow use, not random decoration.
- Make text hierarchy obvious without relying on giant font jumps.
- Keep surfaces and component shapes consistent across the screen.
- If the app already has a design system, stay inside it before inventing new patterns.
- Respect platform expectations when they improve usability, especially for navigation bars, page transitions, modal presentation, back behavior, and scroll feel on iOS versus Android.

## Motion Rules

- Default durations:
  - feedback and microinteractions: `120-180ms`
  - state changes and item reveals: `180-280ms`
  - route or hero transitions: `240-360ms`
- Use easing that matches intent:
  - `easeOut` for reveal
  - `easeInOut` for layout or state changes
  - spring-like curves only when the product tone supports it
- Limit simultaneous attention-grabbing animations.
- Stagger only when it helps the user parse sequence or hierarchy.
- Avoid autoplay loops unless they communicate live state.

## Platform Rules

- Treat iOS and Android as first-class targets, not as one platform plus a fallback.
- Preserve shared brand direction while adapting the final feel to each platform when useful.
- On iOS, prefer cleaner top bars, careful safe area handling, smoother modal and sheet presentation, and more restrained visual density.
- On Android, support clearer elevation cues, direct action emphasis, predictable back navigation, and Material-appropriate interaction feedback.
- Use adaptive widgets or small platform branches when that meaningfully improves the experience; avoid duplicating entire screens unless necessary.

## Deliverables

When using this skill, produce:
- a short visual direction summary
- the Flutter implementation
- a brief note on why the chosen animation improves the experience
- any assumptions made because product or design context was missing

## References

- Read [references/flutter-ui-motion-recipes.md](references/flutter-ui-motion-recipes.md) when the task needs:
  - layout and composition heuristics
  - guidance by screen type
  - Flutter animation API selection help
  - iOS and Android adaptation heuristics
