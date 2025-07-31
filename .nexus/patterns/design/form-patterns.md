# Form Design Patterns

> Category: User Interface
> Agent: Designer
> Last Updated: 2025-01-31

## Pattern: Progressive Disclosure Form

### Context
Long forms with many fields can overwhelm users and reduce completion rates.

### Solution
Break forms into logical sections and reveal them progressively as users complete each section.

### Implementation
```jsx
// Example using React and shadcn/ui
<Form>
  <FormSection active={step === 1}>
    <FormField name="email" />
    <FormField name="password" />
  </FormSection>
  
  <FormSection active={step === 2}>
    <FormField name="firstName" />
    <FormField name="lastName" />
  </FormSection>
  
  <FormProgress current={step} total={totalSteps} />
</Form>
```

### Benefits
- Reduced cognitive load
- Higher completion rates
- Clear progress indication
- Ability to save partial progress

### When to Use
- Forms with more than 5-7 fields
- Multi-step processes (checkout, onboarding)
- Complex data collection

### Accessibility Notes
- Maintain keyboard navigation between steps
- Announce step changes to screen readers
- Allow backward navigation
- Save progress to prevent data loss

---

## Pattern: Inline Validation

### Context
Users need immediate feedback on form input validity.

### Solution
Validate fields as users type or on blur, showing success/error states inline.

### Implementation
```jsx
<FormField
  name="email"
  validate={validateEmail}
  showValidation="onBlur"
  renderError={(error) => (
    <FormError>{error}</FormError>
  )}
  renderSuccess={() => (
    <CheckIcon className="text-green-500" />
  )}
/>
```

### Benefits
- Immediate feedback
- Reduced form submission errors
- Better user experience
- Clear error communication

### When to Use
- Email/username availability
- Password strength
- Format validation (phone, date)
- Required field indication

---

## Pattern: Smart Defaults

### Context
Reduce user effort by providing intelligent default values.

### Solution
Pre-fill forms with sensible defaults based on context, user history, or common choices.

### Examples
- Current date for date fields
- User's country based on IP
- Previous shipping address
- Most common selections

### Caution
- Make defaults obvious and editable
- Don't assume incorrectly
- Respect user privacy
- Allow clearing of defaults

---

*Patterns discovered and refined through actual usage*