---
name: Precision Workshop
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f4'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#47464b'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f0f1f1'
  outline: '#78767b'
  outline-variant: '#c8c5cb'
  surface-tint: '#5f5e63'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1b1b20'
  on-primary-container: '#858389'
  inverse-primary: '#c8c5cc'
  secondary: '#aa3000'
  on-secondary: '#ffffff'
  secondary-container: '#d43f00'
  on-secondary-container: '#fffbff'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#1b1c1c'
  on-tertiary-container: '#848484'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e5e1e8'
  primary-fixed-dim: '#c8c5cc'
  on-primary-fixed: '#1b1b20'
  on-primary-fixed-variant: '#47464b'
  secondary-fixed: '#ffdbd0'
  secondary-fixed-dim: '#ffb59e'
  on-secondary-fixed: '#3a0b00'
  on-secondary-fixed-variant: '#852400'
  tertiary-fixed: '#e4e2e2'
  tertiary-fixed-dim: '#c7c6c6'
  on-tertiary-fixed: '#1b1c1c'
  on-tertiary-fixed-variant: '#464747'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  touch-min: 48px
  touch-spacious: 56px
  space-2xs: 4px
  space-xs: 8px
  space-sm: 12px
  space-md: 16px
  space-lg: 20px
  space-xl: 24px
  space-2xl: 32px
  screen-edge-mobile: 16px
  screen-edge-tablet: 24px
  gutter-list: 12px
---

## Brand & Style

The design system embodies utilitarian functionalism, high operational efficiency, and industrial clarity. Crafted explicitly for fast-paced automotive workshop environments, mechanics, service advisors, and shop managers, the visual language prioritizes instant scanning, absolute readability in variable lighting (including harsh glare or dim repair bays), and confident interaction via touch targets calibrated for active, one-handed, or gloved hand usage.

The aesthetic fuses modern technical minimalism with robust utility:
- **Tone:** Methodical, reliable, precise, no-nonsense.
- **Physical context:** High-contrast surfaces that resist visual noise amidst physical chaos, grease, and shop movement.
- **Visual anchors:** Crisp structural borders, disciplined data density, and purposeful industrial accents that immediately distinguish work order statuses, diagnostic alerts, and dispatch actions.

## Colors

The color palette is built on strict contrast and high legibility, avoiding purely decorative tints in favor of semantic clarity.

### Functional Palette Structure
- **Primary (`#020204` - Deep Industrial Black):** Dedicated to primary action triggers, confirmed completions, focus states, and primary navigational waypoints. Conveys stark engineering precision and structural stability.
- **Secondary (`#ff4d00` - High-Visibility Safety Orange):** High-priority maintenance alerts, pending parts approvals, technician hold flags, and cautionary vehicle diagnostic codes.
- **Tertiary (`#6e6e6e` - Industrial Grey):** Structural dividers, secondary button controls, inactive metadata tags, and non-critical status badges.
- **Neutral Core (`#ffffff` - Clean White):** Forms the foundational text baseline and structural accents.

### Semantic Status Indicators
- **Success / Ready for Delivery:** `#15803D` (Deep Forest Green) on `#DCFCE7`.
- **In Progress / Under Inspection:** `#1E40AF` (Technical Blue) on `#DBEAFE`.
- **Pending / Parts On Order:** `#B45309` (Amber) on `#FEF3C7`.
- **Critical / Safety Hold:** `#B91C1C` (Engine Red) on `#FEE2E2`.
- **Archived / Invoiced:** `#475569` (Slate) on `#F1F5F9`.

## Typography

Inter serves as the primary typographic workhorse due to its tall x-height, distinct letterforms, and optimized screen rendering across mobile hardware. 

To maximize operational speed in diagnosing vehicles and managing parts:
- **Tabular Figures:** Always configure numbers with `font-feature-settings: "tnum"` for odometer readings, labor hours, VIN records, and invoice values to prevent visual jitter.
- **License Plates & VINs:** Render vehicle identification tokens in `label-mono` (JetBrains Mono) with uppercase casing to eradicate ambiguity between characters like `0` and `O`, `1` and `I`.
- **Text Density vs. Legibility:** Limit descriptive notes on card views to a maximum of two lines (`line-clamp-2`), utilizing clear section headers to anchor mechanic workflows.

## Layout & Spacing

The layout system is optimized for mobile-first handheld devices used on the shop floor, scaling to tablet terminals mounted on roll carts or service intake desks.

### Layout Philosophy & Rules
- **Grid Architecture:** Single-column fluid view on mobile devices (`< 640px`) with guaranteed minimum side padding of `16px`. On tablet viewports (`640px - 1024px`), layouts expand to an asymmetrical 2-column or dual-pane master-detail pattern with `24px` margins.
- **Touch-First Spatial Target:** Primary action targets (buttons, checklist rows, vehicle switchers) maintain a strict minimum bounding box of `48px × 48px`, expanding to `56px` for primary submission bars at the bottom of the viewport.
- **Generous Vertical Spacing:** List elements utilize `space-md` (`16px`) internal vertical padding and `space-sm` (`12px`) separation between list items to eliminate mistaps during oily or rapid thumb-driven operations.

## Elevation & Depth

To prevent visual murkiness under harsh overhead shop lighting, this design system rejects heavy, diffused, drop-shadow-heavy layers. Depth is communicated primarily through **tonal layering** and **crisp 1px low-contrast outlines**.

### Depth Layers
- **Floor Level (Canvas / Background):** `#F8FAFC`. A clean, non-glare off-white surface.
- **Surface Level 1 (Cards, Modules, List Rows):** `#FFFFFF` paired with an explicit `1px solid #E2E8F0` border. Zero or subtle ambient shadow (`0 1px 2px rgba(15, 23, 42, 0.05)`).
- **Surface Level 2 (Active/Pressed Cards & Modals):** `#FFFFFF` with `1px solid #CBD5E1` and a focused structural shadow: `0 4px 6px -1px rgba(15, 23, 42, 0.08), 0 2px 4px -2px rgba(15, 23, 42, 0.04)`.
- **Surface Level 3 (Sticky Bottom Operational Trays & Action Bars):** Elevated over content via a top border `1px solid #E2E8F0` and `0 -4px 12px rgba(15, 23, 42, 0.06)`.

## Shapes

The design system adopts a **Soft (`1`)** shape logic (base `4px` radius, cards/buttons at `8px`, containers at `12px`). 

Rounded corners remain restrained and architectural:
- Excessively round or pill shapes are prohibited for operational elements to prevent wasted interactive surface area on compact mobile displays.
- Status badges and chips utilize a tight `4px` radius to maintain a structured, stamp-like mechanical look.
- Inputs, list cards, and primary buttons conform strictly to `8px` (`0.5rem`), ensuring solid corner geometry that visually locks into the grid.

## Components

### Buttons
- **Primary Action (e.g., "Iniciar Orden", "Guardar Diagnóstico"):** Full-width or auto-stretched, `52px` height, background `#020204`, text `#FFFFFF`, font `label-lg`, radius `8px`. Active tap state dims to `#222222`.
- **Secondary Action (e.g., "Añadir Repuesto", "Pausar"):** Height `48px`, background `#F1F5F9`, border `1px solid #CBD5E1`, text `#0F172A`.
- **Danger / Stop Action (e.g., "Rechazar Presupuesto"):** Height `48px`, background `#FEE2E2`, border `1px solid #FCA5A5`, text `#991B1B`.

### List Rows & Work Order Cards
- Encased in individual `#FFFFFF` card containers with `1px solid #E2E8F0`.
- Padding: `16px` all around.
- **Top Row:** Vehicle license plate in `label-mono` badge, aligned opposite the status chip.
- **Middle Row:** Vehicle model and year in `title-md` (`#0F172A`), followed by concise fault summary (`body-md`, `#475569`).
- **Footer Row:** Assigned mechanic name and elapsed time counter with icon. Whole card acts as a single large press target with instantaneous `#F8FAFC` background feedback.

### Status Chips & Badges
- Height: `24px` to `28px`.
- Padding: `4px 10px`.
- Font: `label-md` uppercase.
- Structural style: High-contrast tint fill with matching border (e.g., for "En Taller": Background `#DBEAFE`, Border `1px solid #93C5FD`, Text `#1E40AF`).

### Checklists & Multi-Inspection Items (MPI)
- Row height: Minimum `56px`.
- Layout: Large checkbox/toggle button on the trailing side (`28px × 28px` hit area inside a padded container).
- States: Unchecked (`#FFFFFF` with `#94A3B8` border), Passed (`#16A34A`), Attention Required (`#FF4D00`), Failed/Replace (`#DC2626`).

### Input Fields & Search Bars
- Height: `48px`.
- Base background: `#FFFFFF`, border: `1.5px solid #CBD5E1`, radius: `8px`.
- Focus State: Border shifts to `#020204` with a crisp `2px` concentric ring (`#E2E8F0`).
- Accompanying numeric keyboard layouts enforced by default for odometer, part SKU, and quantity fields.

### Sticky Bottom Utility Bar
- Anchored to bottom edge of the mobile screen with safe-area bottom padding.
- Contains the primary next step (e.g., "Completar Inspección") alongside a quick-dial or camera shortcut button for immediate vehicle damage photo documentation.