---
name: feature-flag
description: >-
  Implement feature flags, feature toggles, and progressive rollouts for controlled feature
  releases, A/B testing, and kill switches. Use this skill when the user mentions feature flag,
  feature toggle, feature toggle, release flag, kill switch, A/B testing, canary deployment,
  progressive rollout, dark launch, experiment, percentage rollout, user targeting,
  or says پرچم ویژگی، کنترل انتشار، تست A/B، استقرار تدریجی.
---

# Feature Flag Skill — Controlled Releases, A/B Testing & Progressive Rollouts

## Overview

This skill covers feature flag implementation, from simple on/off toggles to sophisticated targeting rules, percentage rollouts, and A/B experiments. Feature flags decouple deployment from release, allowing you to deploy code to production without exposing it to users. This enables safe rollbacks, gradual rollouts, and data-driven decisions.

## When to Use This Skill

- User wants to release a feature gradually
- User needs A/B testing infrastructure
- User wants a kill switch for problematic features
- User asks about canary deployments or progressive rollouts
- User mentions feature flags, toggles, or experiments
- User mentions پرچم ویژگی, کنترل انتشار, or تست A/B

---

## Part 1: Feature Flag Types

### Flag Categories

| Type | Purpose | Example | Lifetime |
|------|---------|---------|----------|
| **Release Flag** | Control feature visibility | "New checkout flow" | Days-weeks |
| **Experiment Flag** | A/B test variants | "Button color: blue vs green" | Weeks-months |
| **Ops Flag** | Operational control | "Enable rate limiting" | Permanent |
| **Permission Flag** | User permissions | "Admin-only features" | Permanent |

### Simple Boolean Flag

```python
# Simple feature flag check
FEATURE_NEW_CHECKOUT = True

def checkout(cart):
    if FEATURE_NEW_CHECKOUT:
        return new_checkout_flow(cart)
    else:
        return old_checkout_flow(cart)
```

### Flag with Targeting

```python
import hashlib

def is_feature_enabled(flag_name, user, context=None):
    """Check if a feature flag is enabled for a user."""
    flags = get_flags_from_config()  # Load from config/database
    
    if flag_name not in flags:
        return False
    
    flag = flags[flag_name]
    
    # Kill switch: if flag is globally disabled
    if not flag.get("enabled", False):
        return False
    
    # Percentage rollout
    if "percentage" in flag:
        hash_val = int(hashlib.md5(f"{flag_name}:{user.id}".encode()).hexdigest(), 16)
        if (hash_val % 100) >= flag["percentage"]:
            return False
    
    # User targeting
    if "user_ids" in flag:
        return user.id in flag["user_ids"]
    
    # Group targeting
    if "groups" in flag:
        return any(user.groups.contains(g) for g in flag["groups"])
    
    return True
```

---

## Part 2: Feature Flag Architecture

### Flag Configuration Structure

```json
{
  "flags": {
    "new_checkout": {
      "enabled": true,
      "description": "New checkout flow with Stripe integration",
      "type": "release",
      "percentage": 25,
      "user_ids": ["usr_123", "usr_456"],
      "groups": ["beta-testers", "internal"],
      "variants": {
        "control": { "weight": 50 },
        "treatment": { "weight": 50 }
      },
      "created_at": "2024-01-15",
      "owner": "team-payments"
    }
  }
}
```

### Flag Evaluation Engine

```python
class FeatureFlagEvaluator:
    def __init__(self, flags_config):
        self.flags = flags_config
    
    def evaluate(self, flag_name, user, context=None):
        """Evaluate a feature flag for a user."""
        flag = self.flags.get(flag_name)
        
        if not flag:
            return {"enabled": False, "variant": None}
        
        # 1. Global kill switch
        if not flag.get("enabled", False):
            return {"enabled": False, "variant": None}
        
        # 2. User whitelist (always enabled)
        if flag.get("user_ids") and user.id in flag["user_ids"]:
            return {"enabled": True, "variant": self._get_variant(flag, user)}
        
        # 3. User blacklist (always disabled)
        if flag.get("exclude_user_ids") and user.id in flag["exclude_user_ids"]:
            return {"enabled": False, "variant": None}
        
        # 4. Group targeting
        if flag.get("groups"):
            user_groups = set(user.groups)
            if not user_groups.intersection(set(flag["groups"])):
                return {"enabled": False, "variant": None}
        
        # 5. Percentage rollout
        percentage = flag.get("percentage", 100)
        hash_val = self._hash(flag_name, user.id)
        if (hash_val % 100) >= percentage:
            return {"enabled": False, "variant": None}
        
        # 6. Return enabled with variant
        return {"enabled": True, "variant": self._get_variant(flag, user)}
    
    def _hash(self, flag_name, user_id):
        """Consistent hash for percentage rollout."""
        import hashlib
        return int(hashlib.md5(f"{flag_name}:{user_id}".encode()).hexdigest(), 16)
    
    def _get_variant(self, flag, user):
        """Determine A/B test variant."""
        if "variants" not in flag:
            return None
        
        hash_val = self._hash(flag["name"], user.id)
        cumulative = 0
        
        for variant, config in flag["variants"].items():
            cumulative += config.get("weight", 0)
            if (hash_val % 100) < cumulative:
                return variant
        
        return list(flag["variants"].keys())[-1]
```

---

## Part 3: A/B Testing

### A/B Test Design

```python
class ABTest:
    def __init__(self, name, variants, traffic_percentage=100):
        self.name = name
        self.variants = variants  # {"control": 50, "treatment": 50}
        self.traffic_percentage = traffic_percentage
    
    def assign_variant(self, user_id):
        """Assign a user to a variant."""
        import hashlib
        hash_val = int(hashlib.md5(f"{self.name}:{user_id}".encode()).hexdigest(), 16)
        
        # Check if user is in the test traffic
        if (hash_val % 100) >= self.traffic_percentage:
            return None  # Not in test
        
        # Assign to variant
        cumulative = 0
        for variant, weight in self.variants.items():
            cumulative += weight
            if (hash_val % 100) < cumulative:
                return variant
        
        return list(self.variants.keys())[-1]
    
    def track_event(self, user_id, variant, event_name, value=None):
        """Track an experiment event."""
        log_event({
            "experiment": self.name,
            "variant": variant,
            "user_id": user_id,
            "event": event_name,
            "value": value,
            "timestamp": datetime.utcnow().isoformat()
        })
```

### Statistical Significance

```python
from scipy import stats
import numpy as np

def calculate_significance(control_conversions, control_total,
                          treatment_conversions, treatment_total,
                          confidence_level=0.95):
    """Calculate statistical significance of A/B test."""
    control_rate = control_conversions / control_total
    treatment_rate = treatment_conversions / treatment_total
    
    # Z-test for proportions
    pooled_rate = (control_conversions + treatment_conversions) / (control_total + treatment_total)
    se = np.sqrt(pooled_rate * (1 - pooled_rate) * (1/control_total + 1/treatment_total))
    
    z_score = (treatment_rate - control_rate) / se
    p_value = 2 * (1 - stats.norm.cdf(abs(z_score)))
    
    is_significant = p_value < (1 - confidence_level)
    
    return {
        "control_rate": control_rate,
        "treatment_rate": treatment_rate,
        "lift": (treatment_rate - control_rate) / control_rate * 100,
        "p_value": p_value,
        "is_significant": is_significant,
        "confidence": (1 - p_value) * 100
    }
```

---

## Part 4: Progressive Rollout

### Rollout Strategy

```python
class ProgressiveRollout:
    def __init__(self, flag_name):
        self.flag_name = flag_name
        self.stages = [
            {"percentage": 1, "duration_hours": 24, "name": "Canary"},
            {"percentage": 5, "duration_hours": 48, "name": "Early Adopters"},
            {"percentage": 25, "duration_hours": 72, "name": "Quarter"},
            {"percentage": 50, "duration_hours": 72, "name": "Half"},
            {"percentage": 100, "duration_hours": 0, "name": "Full"},
        ]
    
    def get_current_stage(self):
        """Determine current rollout stage based on metrics."""
        for stage in self.stages:
            if not self._check_health(stage):
                return self._rollback(stage)
        
        return {"status": "completed", "percentage": 100}
    
    def _check_health(self, stage):
        """Check if the rollout is healthy at current percentage."""
        # Check error rate
        error_rate = get_error_rate(self.flag_name)
        if error_rate > 0.01:  # > 1% error rate
            return False
        
        # Check latency
        p95_latency = get_p95_latency(self.flag_name)
        if p95_latency > 500:  # > 500ms
            return False
        
        # Check business metrics
        conversion_rate = get_conversion_rate(self.flag_name)
        if conversion_rate < baseline_conversion * 0.9:  # < 10% drop
            return False
        
        return True
    
    def _rollback(self, stage):
        """Rollback to previous stage."""
        disable_flag(self.flag_name)
        send_alert(f"Rollback triggered for {self.flag_name} at {stage['name']}")
        return {"status": "rolled_back", "at_stage": stage["name"]}
```

---

## Part 5: Kill Switch

### Circuit Breaker Pattern

```python
class FeatureKillSwitch:
    def __init__(self, flag_name):
        self.flag_name = flag_name
        self.error_count = 0
        self.last_error_time = None
        self.circuit_open = False
    
    def check_and_execute(self, func, *args, **kwargs):
        """Execute function with kill switch protection."""
        if self.circuit_open:
            if self._should_retry():
                self.circuit_open = False
            else:
                raise CircuitOpenError(f"Feature {self.flag_name} is disabled")
        
        try:
            result = func(*args, **kwargs)
            self.error_count = 0  # Reset on success
            return result
        except Exception as e:
            self.error_count += 1
            self.last_error_time = time.time()
            
            if self.error_count >= 5:  # Trip after 5 errors
                self.circuit_open = True
                self._notify_ops()
            
            raise
    
    def _should_retry(self):
        """Check if enough time has passed to retry."""
        if not self.last_error_time:
            return True
        return time.time() - self.last_error_time > 60  # 1 minute cooldown
    
    def _notify_ops(self):
        """Notify operations team."""
        send_alert(f"Kill switch activated for {self.flag_name}")
```

---

## Part 6: Flag Management

### Flag Lifecycle

```
1. CREATION → Define flag, set default value
2. DEVELOPMENT → Code behind flag, test locally
3. TESTING → Enable for internal users
4. CANARY → Enable for 1% of production
5. ROLLOUT → Gradually increase percentage
6. FULL → Enable for 100% of users
7. CLEANUP → Remove flag and dead code
```

### Flag Cleanup

```python
# ❌ BAD: Leaving old flags
if FEATURE_FLAG_OLD_CHECKOUT:
    old_checkout()
else:
    new_checkout()

# ✅ GOOD: Clean up after full rollout
# After flag is at 100% for 2+ weeks, remove the flag:
new_checkout()  # Direct call, no flag check
```

### Flag Documentation

```markdown
## Feature Flag: new_checkout

- **Owner:** team-payments
- **Created:** 2024-01-15
- **Type:** Release flag
- **Purpose:** Control new checkout flow with Stripe integration
- **Rollout:** 25% → 50% → 100%
- **Cleanup:** Remove after 2024-02-15
- **Related:** [PR #123](link), [A/B Test #456](link)
```

---

## Part 7: SDK Integration

### JavaScript SDK

```javascript
import { FeatureFlags } from '@company/feature-flags';

const flags = new FeatureFlags({
  apiKey: 'your-api-key',
  user: { id: 'usr_123', groups: ['beta-testers'] }
});

// Check flag
if (flags.isEnabled('new_checkout')) {
  renderNewCheckout();
}

// Get variant for A/B test
const variant = flags.getVariant('button_color_experiment');
renderButton(variant === 'blue' ? 'blue' : 'green');

// Track experiment event
flags.track('purchase_completed', { amount: 99.99 });
```

### Python SDK

```python
from feature_flags import FeatureFlags

flags = FeatureFlags(api_key="your-api-key", user_id="usr_123")

if flags.is_enabled("new_checkout"):
    new_checkout()

variant = flags.get_variant("pricing_experiment")
show_pricing(variant)
```

---

## Output Format

```
## Feature Flag Implementation

### Flag Configuration
| Flag | Type | Default | Targeting |
|------|------|---------|-----------|
| [name] | [type] | [default] | [rules] |

### Rollout Plan
1. [Stage 1]: X% for Y hours
2. [Stage 2]: X% for Y hours
3. Full rollout

### Metrics to Monitor
- Error rate
- P95 latency
- Conversion rate
- Business KPIs

### Cleanup Date
[When to remove the flag]
```

## Rules

- **Keep flags short-lived** — Remove after full rollout (2 weeks max)
- **Document every flag** — Owner, purpose, cleanup date
- **Default to safe** — Flag should default to old behavior
- **Clean up dead code** — Don't leave old code paths forever
- **Monitor during rollout** — Watch error rates, latency, and business metrics
- **Have a rollback plan** — Kill switch should work instantly
- **Use consistent hashing** — Same user always gets same variant
