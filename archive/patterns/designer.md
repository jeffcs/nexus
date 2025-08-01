# Designer Patterns

## Pattern: Mobile-First Responsive

**Context**: Design interfaces that work across all devices

**Structure**:
```
Mobile (320px)     Tablet (768px)     Desktop (1024px+)
┌─────────┐       ┌──────┬──────┐    ┌────┬─────────┬────┐
│ Header  │       │ Head │ Head │    │ Nav│ Content │Side│
├─────────┤       ├──────┴──────┤    ├────┼─────────┼────┤
│ Content │  →    │   Content   │ →  │    │ Primary │    │
├─────────┤       ├─────────────┤    │    ├─────────┤    │
│ Footer  │       │   Footer    │    │    │ Footer  │    │
└─────────┘       └─────────────┘    └────┴─────────┴────┘
```

---

## Pattern: Form Field States

**Context**: Consistent feedback for form interactions

**States**:
1. **Default**: Neutral, ready for input
2. **Focus**: Blue border, clear label
3. **Error**: Red border, error message below
4. **Success**: Green check, subtle confirmation
5. **Disabled**: Gray, reduced opacity

**Example**:
```html
<!-- Error State -->
<div class="field field--error">
  <label>Email</label>
  <input type="email" aria-invalid="true">
  <span class="error">Invalid email format</span>
</div>
```