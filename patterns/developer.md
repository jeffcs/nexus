# Developer Patterns

## Pattern: Error Handling - Result Type

**Context**: Type-safe error handling without exceptions

**Structure**:
```typescript
type Result<T, E = Error> = 
  | { ok: true; value: T }
  | { ok: false; error: E };

async function fetchUser(id: string): Promise<Result<User>> {
  try {
    const user = await api.get(`/users/${id}`);
    return { ok: true, value: user };
  } catch (error) {
    return { ok: false, error };
  }
}
```

**Usage**:
```typescript
const result = await fetchUser('123');
if (result.ok) {
  console.log(result.value.name);
} else {
  console.error(result.error.message);
}
```

---

## Pattern: Test Structure - AAA

**Context**: Consistent, readable test structure

**Structure**:
```typescript
test('should calculate discount correctly', () => {
  // Arrange
  const order = { total: 100, coupon: 'SAVE10' };
  
  // Act  
  const discount = calculateDiscount(order);
  
  // Assert
  expect(discount).toBe(10);
});
```