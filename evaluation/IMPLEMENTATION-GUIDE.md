# NAIES Implementation Guide

## Quick Start

### 1. Installation

```bash
# Make scripts executable
chmod +x .nexus/evaluation/*.sh
chmod +x .nexus/evaluation/lib/*.sh

# Create initial directories
mkdir -p .nexus/evaluation/{versions,results,analytics,improvements}

# Initialize metrics configuration
cp .nexus/evaluation/metrics.yaml.example .nexus/evaluation/metrics.yaml
```

### 2. Basic Usage

#### Testing an Agent
```bash
# Test current product agent
nexus eval test product:current standard

# Test a variant
nexus eval create product:user-focused
# Edit the variant file, then:
nexus eval test product:user-focused standard --compare-to current
```

#### Hot Reload for Rapid Iteration
```bash
# Terminal 1: Start hot reload
.nexus/evaluation/hot-reload.sh --mode test

# Terminal 2: Edit agent files - changes apply automatically
```

#### Monitor Performance
```bash
# Start dashboard
nexus eval monitor

# View in browser
open .nexus/evaluation/dashboard/index.html
```

## Integration with Nexus V2

### 1. Add to PATH

Add this to your shell configuration:
```bash
# ~/.bashrc or ~/.zshrc
alias nexus-eval="$HOME/nexus/.nexus/evaluation/nexus-eval.sh"
```

### 2. Configure Teacher Integration

The improvement engine can automatically teach successful patterns:

```bash
# Enable auto-teaching
export NAIES_AUTO_TEACH=true

# Run improvement cycle
.nexus/evaluation/lib/improvement-engine.sh
```

### 3. Set Quality Thresholds

Define minimum quality standards:
```bash
nexus-eval threshold product response_quality 0.85
nexus-eval threshold designer user_satisfaction 0.90
nexus-eval threshold architect pattern_adherence 0.95
```

## Workflows

### Rapid Experimentation Workflow

1. **Identify Improvement Area**
   ```bash
   nexus-eval analyze --agent product --period 7d
   ```

2. **Create Variant**
   ```bash
   nexus-eval create product:experiment-1
   ```

3. **Enable Hot Reload**
   ```bash
   .nexus/evaluation/hot-reload.sh --mode test &
   ```

4. **Iterate and Test**
   - Edit variant file
   - Changes apply automatically
   - View results in real-time

5. **Deploy if Successful**
   ```bash
   nexus-eval deploy product:experiment-1 --rollout 25
   ```

### A/B Testing Workflow

1. **Create Variants**
   ```bash
   nexus-eval create designer:variant-a
   nexus-eval create designer:variant-b
   ```

2. **Run Comparison**
   ```bash
   nexus-eval compare designer:current,designer:variant-a,designer:variant-b
   ```

3. **Monitor Results**
   ```bash
   nexus-eval monitor --focus designer
   ```

4. **Gradual Rollout**
   ```bash
   # Start with 10%
   nexus-eval deploy designer:variant-a --rollout 10
   
   # Increase if metrics are good
   nexus-eval deploy designer:variant-a --rollout 50
   nexus-eval deploy designer:variant-a --rollout 100
   ```

### Continuous Improvement Workflow

1. **Enable Automated Analysis**
   ```bash
   # Add to crontab for daily runs
   0 2 * * * /path/to/nexus/.nexus/evaluation/lib/improvement-engine.sh
   ```

2. **Review Suggestions**
   ```bash
   ls .nexus/evaluation/improvements/*-suggestions-*.md
   ```

3. **Test Top Improvements**
   ```bash
   # Automated testing of suggestions
   nexus-eval suggest architect --based-on analysis
   ```

## Metrics Deep Dive

### Core Metrics

1. **Response Quality (30%)**
   - Relevance to request
   - Completeness of answer
   - Clarity of communication
   - Actionability of advice

2. **Task Completion (25%)**
   - Requirements fulfilled
   - Deliverables created
   - No hallucinations
   - Error-free execution

3. **Collaboration (20%)**
   - Clear handoffs
   - Context preservation
   - Agent coordination
   - Workflow efficiency

4. **Pattern Adherence (15%)**
   - Follows documented patterns
   - Applies learned behaviors
   - Maintains consistency
   - Uses best practices

5. **User Satisfaction (10%)**
   - Task success
   - Experience quality
   - Would recommend

### Custom Metrics

Add custom metrics in `metrics.yaml`:
```yaml
custom_metrics:
  code_quality:
    weight: 0.2
    evaluator: custom
    script: ./evaluators/code-quality.sh
    criteria:
      - syntax_valid
      - follows_style
      - has_tests
```

## Advanced Features

### LLM-as-Judge Configuration

Configure automated evaluation:
```yaml
# .nexus/evaluation/judge-config.yaml
llm_judge:
  model: claude-3-sonnet
  temperature: 0.3
  criteria:
    - relevance
    - completeness
    - accuracy
    - helpfulness
  rubric: |
    Score 1-5 for each criterion:
    5: Exceptional
    4: Good
    3: Acceptable
    2: Below average
    1: Poor
```

### Pattern Learning Integration

Successful improvements automatically become patterns:

```bash
# After successful deployment
nexus-eval teach --from-deployment product:latest

# Manually teach specific improvement
nexus-eval teach product "Always validate competitor features first"
```

### Export and Reporting

Generate reports for analysis:
```bash
# Weekly performance report
nexus-eval report --period 7d --format pdf

# Agent comparison matrix
nexus-eval report --type comparison --agents all

# Export raw data
nexus-eval export --format csv --output metrics.csv
```

## Troubleshooting

### Common Issues

1. **Hot reload not detecting changes**
   - Check file permissions
   - Verify `fswatch` or `inotify` is installed
   - Try increasing watch interval

2. **Metrics not calculating**
   - Ensure `jq` and `bc` are installed
   - Check results directory permissions
   - Verify JSON format in results

3. **Dashboard not updating**
   - Clear browser cache
   - Check WebSocket connection
   - Verify data directory access

### Debug Mode

Enable detailed logging:
```bash
export NAIES_DEBUG=true
nexus-eval test product:current --verbose
```

## Best Practices

1. **Start Small**: Test with one agent before rolling out
2. **Baseline First**: Always establish baseline metrics
3. **Incremental Changes**: Make small, measurable improvements
4. **Document Changes**: Keep notes on what worked
5. **Regular Reviews**: Weekly analysis of trends
6. **Automate**: Use continuous improvement cycles

## Next Steps

1. Run your first evaluation:
   ```bash
   nexus-eval test product:current standard
   ```

2. Set up monitoring:
   ```bash
   nexus-eval monitor &
   open .nexus/evaluation/dashboard/index.html
   ```

3. Create your first improvement:
   ```bash
   nexus-eval analyze --agent product
   nexus-eval create product:improved
   # Edit and test
   nexus-eval test product:improved
   ```

Remember: The goal is continuous, data-driven improvement. Start simple, measure everything, and iterate based on results.