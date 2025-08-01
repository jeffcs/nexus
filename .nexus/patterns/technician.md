# Technician Patterns

## Pattern: Debugging - Scientific Method

**Context**: Systematic approach to troubleshooting

**Process**:
1. **Observe**: What exactly is happening?
2. **Hypothesize**: What might cause this?
3. **Experiment**: Test one variable at a time
4. **Analyze**: Did it fix the issue?
5. **Document**: Record solution for future

**Example**:
```bash
# 1. Observe
tail -f /var/log/app.log | grep ERROR

# 2. Hypothesize: Memory leak?
free -h

# 3. Experiment: Increase heap
export NODE_OPTIONS="--max-old-space-size=4096"

# 4. Analyze: Monitor metrics
htop

# 5. Document in runbook
```

---

## Pattern: Health Check Endpoint

**Context**: Monitor service health and dependencies

**Structure**:
```typescript
app.get('/health', async (req, res) => {
  const checks = {
    database: await checkDatabase(),
    redis: await checkRedis(),
    disk: await checkDiskSpace()
  };
  
  const healthy = Object.values(checks).every(c => c.ok);
  
  res.status(healthy ? 200 : 503).json({
    status: healthy ? 'healthy' : 'unhealthy',
    timestamp: new Date().toISOString(),
    checks
  });
});
```