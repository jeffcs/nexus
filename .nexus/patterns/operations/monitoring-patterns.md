# Monitoring & Operations Patterns

> Category: DevOps
> Agent: Technician  
> Last Updated: 2025-01-31

## Pattern: Structured Logging

### Context
Logs need to be searchable, parseable, and provide context for debugging.

### Solution
Use structured logging with consistent format and contextual information.

### Implementation
```typescript
interface LogContext {
  userId?: string;
  requestId?: string;
  action?: string;
  metadata?: Record<string, any>;
}

class Logger {
  private context: LogContext = {};

  withContext(context: LogContext): Logger {
    return Object.assign(Object.create(this), {
      context: { ...this.context, ...context }
    });
  }

  info(message: string, metadata?: Record<string, any>) {
    this.log('INFO', message, metadata);
  }

  error(message: string, error?: Error, metadata?: Record<string, any>) {
    this.log('ERROR', message, {
      ...metadata,
      error: {
        message: error?.message,
        stack: error?.stack,
        name: error?.name
      }
    });
  }

  private log(level: string, message: string, metadata?: Record<string, any>) {
    console.log(JSON.stringify({
      timestamp: new Date().toISOString(),
      level,
      message,
      ...this.context,
      ...metadata
    }));
  }
}

// Usage
const logger = new Logger();
const userLogger = logger.withContext({ userId: '123' });
userLogger.info('User action performed', { action: 'login' });
```

---

## Pattern: Health Checks

### Context
Need to monitor service health and readiness for production traffic.

### Solution
Implement standardized health check endpoints.

### Implementation
```typescript
interface HealthCheck {
  name: string;
  check: () => Promise<HealthStatus>;
}

interface HealthStatus {
  status: 'healthy' | 'unhealthy';
  message?: string;
  duration?: number;
}

class HealthChecker {
  private checks: HealthCheck[] = [];

  register(check: HealthCheck) {
    this.checks.push(check);
  }

  async checkHealth(): Promise<{
    status: 'healthy' | 'unhealthy';
    checks: Record<string, HealthStatus>;
  }> {
    const results: Record<string, HealthStatus> = {};
    let overallHealthy = true;

    for (const check of this.checks) {
      const start = Date.now();
      try {
        const result = await check.check();
        results[check.name] = {
          ...result,
          duration: Date.now() - start
        };
        if (result.status === 'unhealthy') {
          overallHealthy = false;
        }
      } catch (error) {
        results[check.name] = {
          status: 'unhealthy',
          message: error.message,
          duration: Date.now() - start
        };
        overallHealthy = false;
      }
    }

    return {
      status: overallHealthy ? 'healthy' : 'unhealthy',
      checks: results
    };
  }
}

// Usage
healthChecker.register({
  name: 'database',
  check: async () => {
    await db.query('SELECT 1');
    return { status: 'healthy' };
  }
});
```

---

## Pattern: Circuit Breaker

### Context
Prevent cascading failures when external services are down.

### Solution
Implement circuit breaker pattern to fail fast.

### Implementation
```typescript
class CircuitBreaker {
  private failures = 0;
  private lastFailureTime?: number;
  private state: 'closed' | 'open' | 'half-open' = 'closed';

  constructor(
    private threshold: number = 5,
    private timeout: number = 60000
  ) {}

  async call<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === 'open') {
      if (Date.now() - this.lastFailureTime! > this.timeout) {
        this.state = 'half-open';
      } else {
        throw new Error('Circuit breaker is open');
      }
    }

    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }

  private onSuccess() {
    this.failures = 0;
    this.state = 'closed';
  }

  private onFailure() {
    this.failures++;
    this.lastFailureTime = Date.now();
    
    if (this.failures >= this.threshold) {
      this.state = 'open';
    }
  }
}
```

---

## Pattern: Performance Monitoring

### Context
Need visibility into application performance and bottlenecks.

### Solution
Implement performance tracking with key metrics.

### Implementation
```typescript
class PerformanceMonitor {
  private metrics: Map<string, number[]> = new Map();

  startTimer(name: string): () => void {
    const start = performance.now();
    
    return () => {
      const duration = performance.now() - start;
      this.record(name, duration);
    };
  }

  record(name: string, value: number) {
    if (!this.metrics.has(name)) {
      this.metrics.set(name, []);
    }
    
    const values = this.metrics.get(name)!;
    values.push(value);
    
    // Keep only last 1000 values
    if (values.length > 1000) {
      values.shift();
    }
  }

  getStats(name: string) {
    const values = this.metrics.get(name) || [];
    if (values.length === 0) return null;

    const sorted = [...values].sort((a, b) => a - b);
    
    return {
      count: values.length,
      min: sorted[0],
      max: sorted[sorted.length - 1],
      avg: values.reduce((a, b) => a + b, 0) / values.length,
      p50: sorted[Math.floor(values.length * 0.5)],
      p95: sorted[Math.floor(values.length * 0.95)],
      p99: sorted[Math.floor(values.length * 0.99)]
    };
  }
}

// Usage
const monitor = new PerformanceMonitor();
const done = monitor.startTimer('api.users.fetch');
// ... do work
done();
```

---

## Pattern: Graceful Shutdown

### Context
Services need to shut down cleanly without losing in-flight requests.

### Solution
Implement graceful shutdown handling.

### Implementation
```typescript
class GracefulShutdown {
  private shutdownHandlers: Array<() => Promise<void>> = [];
  private isShuttingDown = false;

  register(handler: () => Promise<void>) {
    this.shutdownHandlers.push(handler);
  }

  async shutdown(signal: string) {
    if (this.isShuttingDown) return;
    
    this.isShuttingDown = true;
    console.log(`Received ${signal}, starting graceful shutdown...`);

    // Stop accepting new requests
    server.close();

    // Wait for ongoing requests with timeout
    const timeout = setTimeout(() => {
      console.error('Graceful shutdown timeout, forcing exit');
      process.exit(1);
    }, 30000);

    try {
      // Run all shutdown handlers
      await Promise.all(
        this.shutdownHandlers.map(handler => 
          handler().catch(err => 
            console.error('Shutdown handler error:', err)
          )
        )
      );
      
      clearTimeout(timeout);
      console.log('Graceful shutdown complete');
      process.exit(0);
    } catch (error) {
      clearTimeout(timeout);
      console.error('Error during shutdown:', error);
      process.exit(1);
    }
  }
}

// Usage
const shutdown = new GracefulShutdown();
shutdown.register(async () => {
  await database.close();
});
shutdown.register(async () => {
  await cache.disconnect();
});

process.on('SIGTERM', () => shutdown.shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown.shutdown('SIGINT'));
```

---

*Patterns discovered and refined through actual usage*