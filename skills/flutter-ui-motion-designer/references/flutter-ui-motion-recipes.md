# Flutter UI Motion Recipes

## Visual Direction Checklist

- Pick one focal area before styling the rest of the screen.
- Keep the palette tight: one main accent, supporting neutrals, and one background mood.
- Use spacing to group related content before adding borders or fills.
- Keep shape language consistent across cards, buttons, sheets, and chips.
- Make the primary action obvious without relying on a second accent color.

## By Screen Type

### Onboarding And Auth

- Use one dominant headline, short supporting copy, and one primary CTA.
- Give illustration, image, or shape layers room to breathe; do not let them compete with the CTA.
- Animate entrance with subtle fade or slide motion, usually `16-24dp` of travel.

### Dashboard And Home

- Surface the top metric, state, or next action first.
- Group dense information into clear sections instead of stacking many equal cards.
- Use `AnimatedSwitcher` or `TweenAnimationBuilder` for metrics and summary swaps.

### Catalog And Lists

- Keep search, filters, and sort controls anchored and easy to scan.
- Let product imagery and price carry the card; reduce chrome around them.
- Use `AnimatedSwitcher` for filter or state swaps and `Hero` for image-to-detail transitions.

### Detail Pages

- Create a strong hero area, then move into concise supporting sections.
- Keep the main CTA visible or easy to recover while scrolling.
- Animate the hero, CTA, or key spec changes rather than every section at once.

### Empty And Error States

- Keep copy brief and action-oriented.
- Use illustration or motion as reinforcement, not as the entire message.
- Emphasize recovery actions with one clear button and one small supportive hint.

## Flutter Animation API Map

| Need | Prefer | Notes |
| --- | --- | --- |
| Layout morph | `AnimatedContainer` | Good for padding, color, shape, size, and elevation changes. |
| Show or hide content | `AnimatedOpacity` or `AnimatedSlide` | Keep movement short and directional. |
| Swap child content | `AnimatedSwitcher` | Give children stable keys so swaps stay predictable. |
| Small local reveal | `TweenAnimationBuilder` | Useful for counters, badges, and one-off reveals. |
| Shared element transition | `Hero` | Keep tags stable and avoid heroing too many elements. |
| Sequenced choreography | `AnimationController` | Use only when timing and overlap really matter. |

## iOS And Android Adaptation

- Keep the same product hierarchy across platforms, but adapt presentation details.
- On iOS, watch status bar spacing, notch and bottom inset behavior, large-title patterns, modal sheets, and edge-swipe expectations.
- On Android, check app bar density, FAB or primary action emphasis, back handling, and tactile feedback clarity.
- Prefer adaptive decisions for navigation bars, dialogs, date pickers, switches, refresh patterns, and page transitions when users will feel the mismatch.
- Validate typography and spacing on both platforms because the same layout can feel heavier on Android and tighter on iOS.
- If the app intentionally uses one cross-platform design language, keep it consistent but still respect safe areas, gestures, and platform ergonomics.

## Review Prompts

- Can the user identify the main action in under three seconds?
- Does the screen still look good when every animation is frozen?
- Does the motion explain a state change, focus shift, or response?
- Are repeated surfaces following the same visual rules?
- Is there any visual effect that can be removed without hurting clarity?
