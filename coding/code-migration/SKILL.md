---
name: code-migration
description: >-
  Expert guidance on migrating code between languages, frameworks, libraries,
  and architectural patterns with zero data loss. TRIGGERS: code migration,
  framework migration, language migration, refactor to new framework, upgrade
  codebase, migrate from X to Y, rewrite, modernize code, port code, convert
  codebase, migrate to TypeScript, migrate to React, migrate to FastAPI,
  schema migration, API versioning, legacy code, مهاجرت کد, ارتقای کد,
  بازنویسی کد, مهاجرت فریمورک, مهاجرت زبان, تبدیل کد, به‌روزرسانی کد,
  بازنویسی سیستم قدیمی, کد میراثی, 迁移代码, 框架迁移, 语言迁移,
  代码重构, 代码升级, 遗留代码, 转换代码, 代码现代化
priority: P0
dependencies: [algorithm-design, testing, code-review]
conflicts: []
---

# Code Migration Skill

## Overview

This skill provides a systematic, risk-mitigated approach to migrating code between languages, frameworks, libraries, and architectural patterns. It covers the full migration lifecycle: assessment, planning, incremental conversion, testing, and verification. The emphasis is on zero-downtime migrations using strangler-fig patterns, parallel-run validation, and automated tooling — not big-bang rewrites that fail in production.

## When to Use This Skill

- Migrating a codebase from one programming language to another (e.g., JavaScript to TypeScript, Python 2 to Python 3, PHP to Node.js).
- Upgrading a framework across major versions (e.g., AngularJS to Angular, React class components to hooks, Django 3.x to 4.x, Spring Boot 2 to 3).
- Migrating between architectural patterns (e.g., MVC to microservices, monolith to modular monolith, REST to GraphQL).
- Converting database schemas or ORM layers during platform changes (e.g., Sequelize to Prisma, SQLAlchemy to Django ORM, MySQL to PostgreSQL).
- Modernizing legacy codebases (e.g., jQuery to React, SOAP APIs to REST/gRPC, server-rendered to SPA/SSR).
- Migrating deployment infrastructure (e.g., bare metal to Docker/Kubernetes, AWS services migration, CI/CD pipeline overhaul).
- Renaming, restructuring, or reorganizing a large codebase while preserving behavior.
- API versioning and backward-compatible endpoint migration.
- Library replacements where the new library has a different API surface (e.g., Moment.js to date-fns, Lodash to native methods).

## When NOT to Use This Skill

- Small refactors within the same language/framework (use the code-review skill instead).
- Writing new features from scratch (use the relevant domain skill).
- Database query optimization (use the database-design or performance-tuning skill).
- UI/UX redesign (use the front-end skill).
- Performance tuning without language/framework change (use the performance-tuning skill).
- Algorithm optimization (use the algorithm-design skill).
- Security patching without API changes (use the security skill).

## Workflow

### Step 1 — Assessment and Inventory

Before any migration, build a complete picture of what exists:

```markdown
## Migration Inventory

| Component | Language/Framework | LOC | Dependencies | Risk Level | Priority |
|---|---|---|---|---|---|
| Auth service | Python 2 / Flask 0.12 | 4,200 | 12 packages | High | P0 |
| User API | Python 2 / Flask 0.12 | 8,100 | 18 packages | High | P0 |
| Admin dashboard | jQuery 1.x / PHP 5.6 | 15,000 | 8 packages | Medium | P1 |
| Email service | Python 2 / Celery 3.x | 1,800 | 6 packages | Low | P2 |
| Reporting module | Python 2 / Pandas 0.18 | 3,200 | 4 packages | Medium | P2 |
```

**Assessment Checklist:**

1. Count lines of code per module and identify hot paths.
2. Map all internal and external dependencies with version constraints.
3. Identify test coverage per module (target: >80% before migration).
4. Catalog all environment variables, secrets, and configuration.
5. Document all API contracts (request/response schemas).
6. Identify shared state (databases, caches, message queues).
7. Assess team expertise in source and target technologies.

### Step 2 — Migration Strategy Selection

Choose the appropriate migration pattern:

| Pattern | When to Use | Risk | Duration |
|---|---|---|---|
| **Big Bang** | Small codebase (<5K LOC), no uptime requirement | Very High | Short |
| **Strangler Fig** | Large codebase, high availability needed | Low | Long |
| **Branch by Abstraction** | Swapping internal implementations | Low | Medium |
| **Parallel Run** | Data-critical systems, zero data loss required | Very Low | Long |
| **Branch-by-Feature** | Module-by-module migration possible | Medium | Medium |
| **Blue-Green Deploy** | Infrastructure migration with rollback capability | Low | Short |

**Recommended default: Strangler Fig** — the most reliable for production systems.

### Step 3 — Strangler Fig Implementation

Route traffic progressively from old to new implementation:

```python
# traffic_router.py — Strangler Fig routing layer

class TrafficRouter:
    """
    Routes requests to old or new implementation based on
    configuration. Enables progressive migration with instant rollback.
    """
    def __init__(self, old_impl, new_impl, feature_flags):
        self.old = old_impl
        self.new = new_impl
        self.flags = feature_flags
    
    def handle_request(self, request):
        # Check if this route has been migrated
        route_key = f"migrated:{request.path}:{request.method}"
        
        if self.flags.get(route_key):
            # New implementation with error fallback
            try:
                return self.new.handle(request)
            except Exception as e:
                # Automatic rollback on failure
                self.flags.set(route_key, False)
                log.error(f"Migration fallback for {request.path}: {e}")
                return self.old.handle(request)
        else:
            return self.old.handle(request)
    
    def migrate_route(self, path, method="GET"):
        """Mark a specific route as migrated to new implementation."""
        self.flags.set(f"migrated:{path}:{method}", True)
        log.info(f"Migrated {method} {path} to new implementation")
```

### Step 4 — Automated Translation Tooling

Set up automated conversion for mechanical transformations:

```python
# auto_migrate.py — Example: Python 2 to Python 3 automated migration

import ast
import re
from pathlib import Path

class Py2ToPy3Migration:
    """
    Automated transformations for Python 2 to 3 migration.
    Handles print statements, string handling, imports, and exception syntax.
    """
    
    # Mapping of Python 2 builtins to Python 3
    BUILTIN_MAP = {
        'raw_input': 'input',
        'xrange': 'range',
        'unicode': 'str',
        'long': 'int',
        'basestring': 'str',
        'execfile': None,  # Must be handled specially
        'reduce': 'functools.reduce',
    }
    
    # Import remapping
    IMPORT_MAP = {
        'StringIO': ('io', 'StringIO'),
        'cStringIO': ('io', 'StringIO'),
        'urllib2': ('urllib.request', 'urlopen'),
        'urlparse': ('urllib.parse', 'urlparse'),
        'httplib': ('http.client', 'HTTPConnection'),
        'ConfigParser': ('configparser', 'ConfigParser'),
    }
    
    def migrate_file(self, filepath):
        """Apply all Python 2 to 3 transformations to a file."""
        source = Path(filepath).read_text(encoding='utf-8')
        original = source
        
        source = self._convert_print(source)
        source = self._convert_exceptions(source)
        source = self._convert_imports(source)
        source = self._convert_string_prefixes(source)
        source = self._convert_division(source)
        source = self._convert_dict_methods(source)
        
        if source != original:
            Path(filepath).write_text(source, encoding='utf-8')
            return True
        return False
    
    def _convert_print(self, source):
        """Convert print statements to print() function calls."""
        # Simple print statement → function
        source = re.sub(
            r'^(\s*)print\s+(?!\()',
            r'\1print(',
            source,
            flags=re.MULTILINE
        )
        # Add closing parenthesis (simplified — real tool would use AST)
        lines = source.split('\n')
        result = []
        for line in lines:
            if 'print(' in line and not line.rstrip().endswith(')'):
                line = line.rstrip() + ')'
            result.append(line)
        return '\n'.join(result)
    
    def _convert_exceptions(self, source):
        """Convert except Exception, e to except Exception as e."""
        source = re.sub(
            r'except\s+(\w+)\s*,\s*(\w+)',
            r'except \1 as \2',
            source
        )
        # Convert raise "string" syntax (deprecated)
        return re.sub(
            r"raise\s+'([^']+)'",
            r"raise Exception('\1')",
            source
        )
    
    def _convert_imports(self, source):
        """Remap moved standard library imports."""
        for old_module, (new_module, new_name) in self.IMPORT_MAP.items():
            source = source.replace(
                f'from {old_module} import',
                f'from {new_module} import'
            )
            source = source.replace(
                f'import {old_module}',
                f'from {new_module} import {new_name}'
            )
        return source
    
    def _convert_string_prefixes(self, source):
        """Remove u'' and b'' prefixes where appropriate."""
        # In Python 3, all strings are unicode by default
        source = re.sub(r"u'([^']*)'", r"'\1'", source)
        source = re.sub(r'u"([^"]*)"', r'"\1"', source)
        return source
    
    def _convert_division(self, source):
        """Add __future__ import for Python 3 division semantics."""
        if 'from __future__ import division' not in source:
            if '/' in source and '//' not in source:
                source = 'from __future__ import division\n' + source
        return source.replace(
            'from __future__ import division\nfrom __future__ import division',
            'from __future__ import division'
        )
    
    def _convert_dict_methods(self, source):
        """Convert .iteritems()/.iterkeys()/.itervalues() to .items()/.keys()/.values()."""
        source = source.replace('.iteritems()', '.items()')
        source = source.replace('.iterkeys()', '.keys()')
        source = source.replace('.itervalues()', '.values()')
        return source


# Example usage
migrator = Py2ToPy3Migration()
for py_file in Path('src').rglob('*.py'):
    if migrator.migrate_file(py_file):
        print(f"Migrated: {py_file}")
```

### Step 5 — Test Coverage Expansion

Before migrating, expand test coverage to create a safety net:

```python
# test_migration_parity.py — Verify old and new implementations match

import pytest
from old_service import UserService as OldUserService
from new_service import UserService as NewUserService

@pytest.fixture(params=['old', 'new'])
def service(request):
    if request.param == 'old':
        return OldUserService()
    return NewUserService()

class TestUserServiceParity:
    """
    Run the same tests against both old and new implementations
    to verify behavioral equivalence.
    """
    
    def test_create_user(self, service):
        user = service.create_user("alice", "alice@example.com")
        assert user.username == "alice"
        assert user.email == "alice@example.com"
        assert user.id is not None
    
    def test_create_duplicate_user(self, service):
        service.create_user("bob", "bob@example.com")
        with pytest.raises(ValueError, match="already exists"):
            service.create_user("bob", "bob2@example.com")
    
    def test_find_user_by_email(self, service):
        service.create_user("carol", "carol@example.com")
        found = service.find_by_email("carol@example.com")
        assert found is not None
        assert found.username == "carol"
    
    def test_delete_user(self, service):
        user = service.create_user("dave", "dave@example.com")
        service.delete_user(user.id)
        assert service.find_by_id(user.id) is None
    
    def test_pagination(self, service):
        for i in range(25):
            service.create_user(f"user{i}", f"user{i}@example.com")
        page1 = service.list_users(page=1, per_page=10)
        assert len(page1) == 10
        page3 = service.list_users(page=3, per_page=10)
        assert len(page3) == 5
```

### Step 6 — Parallel Run and Validation

Run both implementations simultaneously and compare outputs:

```python
# parallel_runner.py — Shadow traffic to both implementations

import json
import logging
from datetime import datetime
from typing import Any, Dict

logger = logging.getLogger(__name__)

class ParallelRunner:
    """
    Executes a request on both old and new implementations,
    logs discrepancies, and returns the old implementation's result
    until validation passes.
    """
    
    def __init__(self, old_impl, new_impl):
        self.old = old_impl
        self.new = new_impl
        self.discrepancies = []
        self.total_requests = 0
        self.matched_requests = 0
    
    def execute(self, method: str, *args, **kwargs) -> Any:
        """Execute on both and compare results."""
        self.total_requests += 1
        
        old_result = getattr(self.old, method)(*args, **kwargs)
        
        try:
            new_result = getattr(self.new, method)(*args, **kwargs)
            self._compare(method, args, kwargs, old_result, new_result)
        except Exception as e:
            self._log_discrepancy(method, args, "EXCEPTION", str(e))
            return old_result  # Fallback to old
        
        return old_result  # Always return old result during validation
    
    def _compare(self, method, args, kwargs, old_result, new_result):
        """Deep-compare results and log discrepancies."""
        old_serialized = self._serialize(old_result)
        new_serialized = self._serialize(new_result)
        
        if old_serialized == new_serialized:
            self.matched_requests += 1
        else:
            self._log_discrepancy(
                method, args, "MISMATCH",
                f"old={old_serialized} new={new_serialized}"
            )
    
    def _serialize(self, obj) -> str:
        """Serialize result for comparison."""
        if hasattr(obj, '__dict__'):
            return json.dumps(obj.__dict__, sort_keys=True, default=str)
        return json.dumps(obj, sort_keys=True, default=str)
    
    def _log_discrepancy(self, method, args, kind, detail):
        entry = {
            'timestamp': datetime.utcnow().isoformat(),
            'method': method,
            'args': str(args),
            'kind': kind,
            'detail': detail,
        }
        self.discrepancies.append(entry)
        logger.warning(f"Migration discrepancy: {entry}")
    
    def get_accuracy(self) -> float:
        if self.total_requests == 0:
            return 1.0
        return self.matched_requests / self.total_requests
    
    def get_report(self) -> Dict[str, Any]:
        return {
            'total_requests': self.total_requests,
            'matched_requests': self.matched_requests,
            'accuracy': f"{self.get_accuracy():.2%}",
            'discrepancies': len(self.discrepancies),
        }
```

### Step 7 — Cutover and Cleanup

Final migration steps:

1. **Freeze the old codebase** — Stop accepting changes to the source code.
2. **Verify parity metrics** — Parallel run accuracy > 99.9% over > 10,000 requests.
3. **Update routing** — Point 100% of traffic to the new implementation.
4. **Keep rollback ready** — Maintain the ability to revert for at least 2 weeks.
5. **Remove old code** — After stability period, delete the old implementation.
6. **Update documentation** — Reflect new architecture, dependencies, and deployment.
7. **Retrospective** — Document lessons learned, update the migration playbook.

## Advanced Techniques (7 Techniques)

### 1. Abstract Syntax Tree (AST) Transformation

For language-to-language migration, AST-level transformations are more reliable than regex-based text substitution. They preserve syntax correctness and handle nested structures.

```python
import ast

class PythonToTypeScriptAST:
    """
    Example AST transformer: extract Python function signatures
    to generate TypeScript type definitions.
    """
    
    def extract_functions(self, source: str) -> list:
        """Parse Python source and extract function signatures."""
        tree = ast.parse(source)
        functions = []
        
        for node in ast.walk(tree):
            if isinstance(node, ast.FunctionDef):
                func_info = {
                    'name': node.name,
                    'args': [],
                    'return_type': None,
                }
                
                # Extract argument types from annotations
                for arg in node.args.args:
                    arg_info = {'name': arg.arg}
                    if arg.annotation:
                        arg_info['type'] = ast.unparse(arg.annotation)
                    else:
                        arg_info['type'] = 'any'
                    func_info['args'].append(arg_info)
                
                # Extract return type
                if node.returns:
                    func_info['return_type'] = ast.unparse(node.returns)
                else:
                    func_info['return_type'] = 'void'
                
                functions.append(func_info)
        
        return functions
    
    def generate_typescript(self, functions: list) -> str:
        """Generate TypeScript function signatures from extracted info."""
        lines = []
        
        for func in functions:
            # Map Python types to TypeScript types
            type_map = {
                'str': 'string',
                'int': 'number',
                'float': 'number',
                'bool': 'boolean',
                'None': 'void',
                'list': 'Array<any>',
                'dict': 'Record<string, any>',
                'Optional': 'T | null',
            }
            
            args = []
            for arg in func['args']:
                ts_type = type_map.get(arg['type'], arg['type'])
                args.append(f"{arg['name']}: {ts_type}")
            
            return_type = type_map.get(func['return_type'], func['return_type'])
            
            sig = f"function {func['name']}({', '.join(args)}): {return_type};"
            lines.append(sig)
        
        return '\n'.join(lines)


# Example
source = """
def create_user(name: str, email: str, age: int = 0) -> dict:
    pass

def delete_user(user_id: int) -> None:
    pass

def get_users(limit: int = 100) -> list:
    pass
"""

transformer = PythonToTypeScriptAST()
functions = transformer.extract_functions(source)
print(transformer.generate_typescript(functions))
```

### 2. Dependency Graph Analysis

Map the internal dependency graph to identify migration order and blast radius:

```python
from collections import defaultdict
from typing import Set, List, Dict

class DependencyAnalyzer:
    """
    Analyzes module dependencies to determine safe migration order.
    Modules with no internal dependents migrate first (leaves).
    """
    
    def __init__(self):
        self.depends_on: Dict[str, Set[str]] = defaultdict(set)
        self.depended_by: Dict[str, Set[str]] = defaultdict(set)
    
    def add_dependency(self, module: str, depends_on: str):
        """Record that `module` depends on `depends_on`."""
        self.depends_on[module].add(depends_on)
        self.depended_by[depends_on].add(module)
    
    def migration_order(self) -> List[str]:
        """
        Topological sort: modules with no dependents migrate first.
        Returns list in safe migration order.
        """
        # Calculate in-degree (number of modules depending on each)
        in_degree = {}
        for module in set(list(self.depends_on.keys()) + list(self.depended_by.keys())):
            in_degree[module] = len(self.depended_by.get(module, set()))
        
        # Start with leaf modules (nothing depends on them)
        queue = [m for m, d in in_degree.items() if d == 0]
        order = []
        
        while queue:
            queue.sort()  # Deterministic ordering
            module = queue.pop(0)
            order.append(module)
            
            # Reduce in-degree for modules this one depends on
            for dep in self.depends_on.get(module, set()):
                in_degree[dep] -= 1
                if in_degree[dep] == 0:
                    queue.append(dep)
        
        return order
    
    def blast_radius(self, module: str) -> Set[str]:
        """Find all modules that would be affected if `module` changes."""
        affected = set()
        stack = [module]
        while stack:
            current = stack.pop()
            for dependent in self.depended_by.get(current, set()):
                if dependent not in affected:
                    affected.add(dependent)
                    stack.append(dependent)
        return affected


# Example: Analyze a microservices architecture
analyzer = DependencyAnalyzer()
analyzer.add_dependency('api-gateway', 'auth-service')
analyzer.add_dependency('api-gateway', 'user-service')
analyzer.add_dependency('user-service', 'database')
analyzer.add_dependency('auth-service', 'database')
analyzer.add_dependency('auth-service', 'cache')
analyzer.add_dependency('notification-service', 'email-provider')
analyzer.add_dependency('user-service', 'notification-service')

print("Migration order:", analyzer.migration_order())
# ['database', 'cache', 'email-provider', 'notification-service',
#  'auth-service', 'user-service', 'api-gateway']

print("Blast radius of 'database':", analyzer.blast_radius('database'))
# {'user-service', 'auth-service', 'api-gateway'}
```

### 3. Configuration Mapping Tables

Create explicit mappings between old and new configuration formats:

```python
# config_mapper.py — Migrate configuration between framework versions

CONFIG_MAP = {
    # Django 3.x → Django 4.x settings migration
    'django': {
        'MIDDLEWARE_CLASSES': {
            'new_key': 'MIDDLEWARE',
            'transforms': [
                lambda v: [m if m.endswith('.') else m + 'Middleware'
                           for m in v],
            ],
        },
        'DATABASES': {
            'new_key': 'DATABASES',
            'nested': {
                'ENGINE': {
                    'old_values': {
                        'django.db.backends.postgresql_psycopg2':
                            'django.db.backends.postgresql',
                    }
                },
                'OPTIONS': {
                    'transforms': [
                        lambda opts: {
                            k: v for k, v in opts.items()
                            if k != 'debug'  # Removed in Django 4
                        }
                    ]
                }
            }
        },
        'TEMPLATES': {
            'new_key': 'TEMPLATES',
            'transforms': [
                lambda old: [{
                    'BACKEND': 'django.template.backends.django.DjangoTemplates',
                    'DIRS': old.get('DIRS', []),
                    'APP_DIRS': True,
                    'OPTIONS': {
                        'context_processors': old.get('context_processors', []),
                    },
                }]
            ],
        },
    }
}


class ConfigMapper:
    """Apply configuration mappings between framework versions."""
    
    def __init__(self, mappings: dict):
        self.mappings = mappings
    
    def migrate_config(self, old_config: dict, framework: str) -> dict:
        """Transform old config to new format."""
        if framework not in self.mappings:
            raise ValueError(f"No mappings for framework: {framework}")
        
        new_config = {}
        framework_map = self.mappings[framework]
        
        for old_key, mapping in framework_map.items():
            if old_key not in old_config:
                continue
            
            new_key = mapping.get('new_key', old_key)
            value = old_config[old_key]
            
            # Apply simple value transformations
            if 'old_values' in mapping.get('nested', {}).get(old_key, {}):
                value_map = mapping['nested'][old_key]['old_values']
                value = value_map.get(value, value)
            
            # Apply transformation functions
            for transform in mapping.get('transforms', []):
                value = transform(value)
            
            new_config[new_key] = value
        
        return new_config
```

### 4. Schema Migration Generators

Automatically generate database migration scripts from schema diffs:

```python
from dataclasses import dataclass, field
from typing import List, Optional

@dataclass
class ColumnDiff:
    name: str
    old_type: Optional[str] = None
    new_type: Optional[str] = None
    added: bool = False
    removed: bool = False
    renamed_from: Optional[str] = None

@dataclass
class TableDiff:
    name: str
    added: bool = False
    removed: bool = False
    columns: List[ColumnDiff] = field(default_factory=list)
    renamed_from: Optional[str] = None

class MigrationGenerator:
    """
    Generate SQL migration scripts from schema diffs.
    Supports PostgreSQL, MySQL, and SQLite.
    """
    
    TYPE_MAP = {
        'mysql': {
            'string': 'VARCHAR(255)',
            'text': 'TEXT',
            'integer': 'INT',
            'bigint': 'BIGINT',
            'float': 'DOUBLE',
            'boolean': 'TINYINT(1)',
            'datetime': 'DATETIME',
            'json': 'JSON',
        },
        'postgresql': {
            'string': 'VARCHAR(255)',
            'text': 'TEXT',
            'integer': 'INTEGER',
            'bigint': 'BIGINT',
            'float': 'DOUBLE PRECISION',
            'boolean': 'BOOLEAN',
            'datetime': 'TIMESTAMP',
            'json': 'JSONB',
        },
    }
    
    def generate(self, diffs: List[TableDiff], dialect: str = 'postgresql') -> str:
        """Generate SQL migration from table diffs."""
        statements = []
        statements.append(f"-- Generated migration — {dialect}")
        statements.append("BEGIN;\n")
        
        for diff in diffs:
            if diff.added:
                statements.append(self._create_table(diff, dialect))
            elif diff.removed:
                statements.append(f"DROP TABLE IF EXISTS {diff.name};\n")
            elif diff.renamed_from:
                statements.append(
                    f"ALTER TABLE {diff.renamed_from} RENAME TO {diff.name};\n"
                )
            
            for col in diff.columns:
                if col.added:
                    col_type = self.TYPE_MAP[dialect].get(col.new_type, 'TEXT')
                    statements.append(
                        f"ALTER TABLE {diff.name} ADD COLUMN {col.name} {col_type};"
                    )
                elif col.removed:
                    statements.append(
                        f"ALTER TABLE {diff.name} DROP COLUMN {col.name};"
                    )
                elif col.renamed_from:
                    statements.append(
                        f"ALTER TABLE {diff.name} RENAME COLUMN "
                        f"{col.renamed_from} TO {col.name};"
                    )
                elif col.old_type != col.new_type:
                    new_type = self.TYPE_MAP[dialect].get(col.new_type, 'TEXT')
                    statements.append(
                        f"ALTER TABLE {diff.name} ALTER COLUMN {col.name} "
                        f"TYPE {new_type};"
                    )
        
        statements.append("\nCOMMIT;")
        return '\n'.join(statements)
    
    def _create_table(self, diff: TableDiff, dialect: str) -> str:
        cols = []
        for col in diff.columns:
            col_type = self.TYPE_MAP[dialect].get(col.new_type or 'string', 'TEXT')
            cols.append(f"    {col.name} {col_type}")
        cols_str = ',\n'.join(cols)
        return f"CREATE TABLE {diff.name} (\n{cols_str}\n);\n"


# Example: Generate migration for renamed columns and added fields
diffs = [
    TableDiff(
        name='users_v2',
        renamed_from='users',
        columns=[
            ColumnDiff(name='full_name', renamed_from='username'),
            ColumnDiff(name='phone', added=True, new_type='string'),
        ]
    )
]

gen = MigrationGenerator()
print(gen.generate(diffs, dialect='postgresql'))
```

### 5. API Contract Migration with OpenAPI

Use OpenAPI/Swagger specs to migrate API contracts between versions while maintaining backward compatibility:

```yaml
# openapi_v2_to_v3_migration.yaml
# Migration guide for API v2 → v3

openapi: "3.0.3"
info:
  title: Migration Helper — API v2 to v3
  description: |
    This document defines the mapping between v2 and v3 endpoints.
    All v2 endpoints are proxied through a compatibility layer.

paths:
  /api/v2/users:
    get:
      x-migration:
        target: /api/v3/users
        transforms:
          - rename_param: pageSize → limit
          - rename_param: pageNum → offset
          - rename_response: users.items
          - add_header: X-API-Version: 3
        deprecated: true
        sunset: "2025-06-01"
  
  /api/v3/users:
    get:
      summary: List users (v3)
      parameters:
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
        - name: offset
          in: query
          schema:
            type: integer
            default: 0
```

### 6. Feature Flag–Driven Migration

Use feature flags to control which code path executes, enabling instant rollback:

```python
from enum import Enum
from functools import wraps

class MigrationFlag(Enum):
    """Feature flags controlling migration state."""
    USE_NEW_AUTH = "use_new_auth_service"
    USE_NEW_DATABASE = "use_new_database_driver"
    USE_NEW_CACHE = "use_new_cache_layer"
    USE_NEW_QUEUE = "use_new_queue_system"

class FeatureFlagStore:
    """Simple in-memory feature flag store (replace with Redis/DB in production)."""
    
    def __init__(self):
        self._flags = {}
    
    def is_enabled(self, flag: MigrationFlag, default=False) -> bool:
        return self._flags.get(flag.value, default)
    
    def enable(self, flag: MigrationFlag):
        self._flags[flag.value] = True
    
    def disable(self, flag: MigrationFlag):
        self._flags[flag.value] = False
    
    def toggle(self, flag: MigrationFlag):
        current = self.is_enabled(flag)
        self._flags[flag.value] = not current

flags = FeatureFlagStore()

def migrated_service(flag: MigrationFlag, new_func, old_func):
    """Decorator that routes to old or new based on feature flag."""
    def wrapper(*args, **kwargs):
        if flags.is_enabled(flag):
            try:
                return new_func(*args, **kwargs)
            except Exception as e:
                # Auto-rollback on failure
                flags.disable(flag)
                log.error(f"Migration fallback: {e}")
                return old_func(*args, **kwargs)
        return old_func(*args, **kwargs)
    return wrapper


# Usage
# @migrated_service(MigrationFlag.USE_NEW_AUTH, new_authenticate, old_authenticate)
# def authenticate(username, password): ...
```

### 7. Rollback Strategy Templates

Every migration needs a tested rollback plan:

```python
class RollbackManager:
    """
    Manages migration rollback with checkpoints.
    Each step is reversible; the manager tracks the current position
    in the migration sequence.
    """
    
    def __init__(self):
        self.steps = []
        self.completed = []
        self.checkpoints = {}
    
    def add_step(self, name: str, apply_fn, rollback_fn):
        """Register a migration step with its rollback function."""
        self.steps.append({
            'name': name,
            'apply': apply_fn,
            'rollback': rollback_fn,
            'applied': False,
        })
    
    def apply_all(self):
        """Apply all steps in order, stopping on failure."""
        for i, step in enumerate(self.steps):
            try:
                step['apply']()
                step['applied'] = True
                self.completed.append(i)
                self._save_checkpoint(i)
                print(f"Applied: {step['name']}")
            except Exception as e:
                print(f"Failed at step {step['name']}: {e}")
                print("Initiating rollback...")
                self.rollback_to(-1)
                raise
    
    def rollback_to(self, step_index: int):
        """Rollback to a specific step index (or -1 for full rollback)."""
        for i in reversed(self.completed):
            if i <= step_index:
                break
            step = self.steps[i]
            try:
                step['rollback']()
                step['applied'] = False
                self.completed.remove(i)
                print(f"Rolled back: {step['name']}")
            except Exception as e:
                print(f"CRITICAL: Rollback failed for {step['name']}: {e}")
                raise
    
    def _save_checkpoint(self, step_index: int):
        self.checkpoints[step_index] = {
            'completed_steps': list(self.completed),
        }


# Example usage
manager = RollbackManager()

manager.add_step(
    "backup_database",
    apply_fn=lambda: print("Creating database backup..."),
    rollback_fn=lambda: print("Restoring database from backup..."),
)

manager.add_step(
    "add_new_columns",
    apply_fn=lambda: print("ALTER TABLE users ADD COLUMN email_v2 VARCHAR(255);"),
    rollback_fn=lambda: print("ALTER TABLE users DROP COLUMN email_v2;"),
)

manager.add_step(
    "migrate_data",
    apply_fn=lambda: print("UPDATE users SET email_v2 = email;"),
    rollback_fn=lambda: print("UPDATE users SET email = email_v2;"),
)

manager.add_step(
    "drop_old_column",
    apply_fn=lambda: print("ALTER TABLE users DROP COLUMN email;"),
    rollback_fn=lambda: print("ALTER TABLE users ADD COLUMN email VARCHAR(255);"),
)
```

## Common Patterns

### Pattern 1 — Language Migration Checklist

```markdown
## Language Migration: {Source} → {Target}

### Pre-Migration
- [ ] Audit all source files and dependencies
- [ ] Set up target language build/compile pipeline
- [ ] Ensure test coverage > 80% on source code
- [ ] Document all configuration and environment variables
- [ ] Map source language idioms to target language idioms

### Migration
- [ ] Convert build system (Maven→Gradle, setup.py→pyproject.toml, etc.)
- [ ] Migrate automated tests first (they become the safety net)
- [ ] Migrate utility/library modules first (fewest dependencies)
- [ ] Migrate domain logic (business rules)
- [ ] Migrate API layer (controllers/routes/handlers)
- [ ] Migrate configuration and deployment scripts

### Post-Migration
- [ ] Run full test suite in target language
- [ ] Benchmark key performance metrics
- [ ] Deploy to staging and run shadow traffic
- [ ] Update documentation and developer guides
- [ ] Remove source language files after stability period
```

### Pattern 2 — Framework Upgrade Ladder

When jumping multiple major versions, upgrade one version at a time:

```python
# Example: Django 2.2 → 4.2 requires step-by-step upgrade
UPGRADE_LADDER = [
    {
        'from': 'Django 2.2',
        'to': 'Django 3.2',
        'key_changes': [
            'MIDDLEWARE_CLASSES → MIDDLEWARE',
            'NullBooleanField → BooleanField(null=True)',
            'USE_L10N default changed to True',
            'django.utils.timezone.utc replaces pytz.utc',
        ],
        'required_steps': [
            'Fix deprecation warnings first',
            'Update middleware configuration',
            'Run django-3.2-compatibility checks',
        ],
    },
    {
        'from': 'Django 3.2',
        'to': 'Django 4.1',
        'key_changes': [
            'DEFAULT_AUTO_FIELD required',
            'CSRF_TRUSTED_ORIGINS requires scheme',
            'File-based cache key function change',
            'django.utils.encoding.force_text → force_str',
        ],
    },
    {
        'from': 'Django 4.1',
        'to': 'Django 4.2',
        'key_changes': [
            'STORAGES setting replaces individual settings',
            'django.utils.timezone.utc removal (use datetime.timezone.utc)',
            'CSRF_COOKIE_MASKED default True',
        ],
    },
]
```

### Pattern 3 — Code Translation Ruleset

Document systematic translation rules for language pairs:

```python
# JavaScript → TypeScript translation rules
TRANSLATION_RULES = {
    'js_to_ts': [
        {
            'pattern': r'function\s+(\w+)\((.*?)\)',
            'replacement': r'function \1(\2): any',
            'description': 'Add explicit return type annotation',
        },
        {
            'pattern': r'(\w+)\s*:\s*any',
            'replacement': r'\1: unknown',
            'description': 'Replace `any` with `unknown` where possible',
        },
        {
            'pattern': r'==\s*null',
            'replacement': r'=== null || \1 === undefined',
            'description': 'Replace loose null check with strict equality',
        },
    ],
    'py2_to_py3': [
        {
            'pattern': r'print\s+(?!\()',
            'replacement': r'print(',
            'description': 'Convert print statement to function call',
        },
        {
            'pattern': r'except\s+(\w+)\s*,\s*(\w+)',
            'replacement': r'except \1 as \2',
            'description': 'Convert old-style except syntax',
        },
    ],
}
```

### Pattern 4 — Database Migration Safety Rules

```python
DATABASE_MIGRATION_RULES = """
## Zero-Downtime Database Migration Rules

1. NEVER drop a column while old code still references it.
2. ALWAYS add new columns as nullable first; backfill, then add constraints.
3. RENAME columns using a three-step process:
   a. Add new column
   b. Dual-write to both columns
   c. Backfill old column, then drop it
4. CREATE INDEX CONCURRENTLY (PostgreSQL) to avoid table locks.
5. TEST migrations against a production-size dataset before deploying.
6. KEEP migration scripts version-controlled and immutable.
7. SEQUENCE migrations: expand (add new), migrate (backfill), contract (remove old).
"""
```

### Pattern 5 — Automated Compatibility Testing

```python
# compatibility_test.py — Verify API backward compatibility

import requests
import json
from typing import Dict, Any

class CompatibilityTester:
    """
    Tests that a new API version maintains backward compatibility
    with documented v2 contracts.
    """
    
    def __init__(self, v2_base: str, v3_base: str):
        self.v2 = v2_base
        self.v3 = v3_base
        self.results = []
    
    def test_endpoint(self, method: str, path: str, payload: Dict = None,
                      headers: Dict = None) -> Dict[str, Any]:
        """Test the same request against both API versions."""
        url_v2 = f"{self.v2}{path}"
        url_v3 = f"{self.v3}{path}"
        
        resp_v2 = requests.request(method, url_v2, json=payload, headers=headers)
        resp_v3 = requests.request(method, url_v3, json=payload, headers=headers)
        
        result = {
            'endpoint': f"{method} {path}",
            'v2_status': resp_v2.status_code,
            'v3_status': resp_v3.status_code,
            'status_match': resp_v2.status_code == resp_v3.status_code,
            'v2_body': resp_v2.json() if resp_v2.headers.get('content-type', '').startswith('application/json') else None,
            'v3_body': resp_v3.json() if resp_v3.headers.get('content-type', '').startswith('application/json') else None,
        }
        
        self.results.append(result)
        return result
    
    def run_full_suite(self):
        """Run compatibility tests against all documented endpoints."""
        endpoints = [
            ('GET', '/api/users'),
            ('GET', '/api/users/1'),
            ('POST', '/api/users', {'name': 'Test', 'email': 'test@example.com'}),
            ('PUT', '/api/users/1', {'name': 'Updated'}),
            ('DELETE', '/api/users/1'),
        ]
        
        for method, path, *args in payload in args else (None,):
            self.test_endpoint(method, path, payload)
        
        passed = sum(1 for r in self.results if r['status_match'])
        print(f"\nCompatibility: {passed}/{len(self.results)} endpoints matched")
        
        for r in self.results:
            status = "PASS" if r['status_match'] else "FAIL"
            print(f"  [{status}] {r['endpoint']}: v2={r['v2_status']}, v3={r['v3_status']}")
```

## Edge Cases & Pitfalls

### 1. Implicit Type Coercion Differences
Languages handle type coercion differently. Python `3 + "3"` raises TypeError; JavaScript `3 + "3"` returns `"33"`. During migration, audit all mixed-type operations and add explicit conversions.

### 2. Integer Overflow Behavior
Python integers have unlimited precision; C/C++/Java/Go integers overflow silently. When migrating from Python to a typed language, choose the appropriate integer width (int32, int64, BigInteger) based on expected value ranges.

### 3. Floating Point Representation
Different languages may use different floating point implementations (IEEE 754 vs. IBM decimal). Financial calculations that use floats will produce different results across platforms. Migrate to decimal types for money.

### 4. String Encoding Assumptions
Python 3 defaults to UTF-8; older PHP/Java versions may use Latin-1 or platform-specific encodings. Migrating text data without explicit encoding specification causes mojibake and data corruption.

### 5. Null/None Semantics
`None` (Python), `null` (JavaScript/Java), `NULL` (SQL), `nil` (Ruby/Swift), and `undefined` (JavaScript) have different semantics. A `None` check in Python does not map 1:1 to a JavaScript null check. Audit all null comparisons.

### 6. Concurrent Execution Models
Threading, async/await, multiprocessing, and event loops differ dramatically across frameworks. Node.js is single-threaded event-loop; Python has the GIL; Go has goroutines. Migration requires rethinking concurrency, not just translating syntax.

### 7. Serialization Format Differences
JSON, YAML, MessagePack, Thrift, and Protocol Buffers handle edge cases differently (NaN, Infinity, dates, binary data). Migration between serialization frameworks requires explicit format testing.

### 8. Timezone and Locale Handling
Date/time handling varies enormously. Python `datetime` is naive by default; JavaScript `Date` always includes timezone offset; Java `LocalDateTime` vs `ZonedDateTime`. Migration must audit all datetime operations.

### 9. Exception/Error Model Differences
Python raises exceptions; Go uses multiple return values with error; Rust uses `Result<T, E>`; C uses error codes. Migration between these models requires systematic conversion of every error-handling path.

### 10. Memory Management Differences
Garbage-collected languages (Python, Java, Go) vs. manual management (C, C++, Rust) vs. reference counting (Swift). Migration from GC to manual management requires careful audit of resource lifetimes.

### 11. Package Manager Lock File Compatibility
Lock files (package-lock.json, yarn.lock, Pipfile.lock, Cargo.lock) are not portable between package managers. Migration requires regenerating lock files and verifying dependency resolution.

### 12. Test Framework Parity
Unit test frameworks have different assertion libraries, mocking systems, and fixture lifecycles. pytest fixtures, Jest mocks, JUnit annotations, and Go test tables all work differently. Migrate tests carefully.

### 13. Build System Differences
Maven → Gradle, Webpack → Vite, Make → CMake, setup.py → pyproject.toml. Build system migration affects CI/CD pipelines, IDE integration, and developer onboarding. Test the full build chain.

### 14. Configuration Environment Variable Conventions
Some frameworks use `SCREAMING_SNAKE_CASE`, others use `kebab-case`, others use `camelCase`. When migrating, ensure environment variable names are consistently mapped to avoid silent misconfigurations.

### 15. License Compatibility
When replacing libraries during migration, verify that new dependencies have compatible licenses (MIT, Apache 2.0, GPL). Mixing licenses can create legal exposure.

## Integration with Other Skills

| Skill | When to Combine | How |
|---|---|---|
| algorithm-design | Preserving algorithmic correctness during migration | Verify that translated algorithms produce identical results; compare output checksums |
| testing | Expanding test coverage before migration | Create behavioral equivalence tests running against both old and new implementations |
| code-review | Reviewing migrated code for correctness | Focus on semantic differences between languages, not just syntax translation |
| performance-tuning | Benchmarking old vs new implementation | Establish performance baselines before migration; compare after each phase |
| database-design | Migrating database schemas and ORM layers | Generate migration scripts from schema diffs; test with production data snapshots |
| security | Maintaining security invariants during migration | Audit authentication, authorization, and data handling in both implementations |
| documentation | Updating docs to reflect new architecture | Document API changes, new configuration, and updated deployment procedures |

## Output Format Templates

### Template 1 — Migration Plan

```markdown
## Migration Plan: {Source} → {Target}

### Overview
- **Source**: {technology stack, version, LOC}
- **Target**: {technology stack, version}
- **Estimated Duration**: {weeks/months}
- **Risk Level**: {Low/Medium/High/Critical}

### Phase 1: Assessment
- [ ] Complete inventory of modules, dependencies, and test coverage
- [ ] Identify high-risk components (auth, payments, data storage)
- [ ] Set up target environment

### Phase 2: Preparation
- [ ] Expand test coverage to >80%
- [ ] Set up automated conversion tooling
- [ ] Create migration branch

### Phase 3: Execution
- [ ] Migrate utility modules
- [ ] Migrate business logic
- [ ] Migrate API layer
- [ ] Migrate configuration

### Phase 4: Validation
- [ ] Run parallel comparison
- [ ] Performance benchmarking
- [ ] Security audit

### Phase 5: Cutover
- [ ] Deploy to staging
- [ ] Shadow traffic testing
- [ ] Production deployment
- [ ] Monitor and rollback readiness
```

### Template 2 — Compatibility Report

```markdown
## Compatibility Report: {Module Name}

| Feature | Old Behavior | New Behavior | Status | Notes |
|---|---|---|---|---|
| {feature 1} | {description} | {description} | PASS/FAIL | {notes} |
| {feature 2} | {description} | {description} | PASS/FAIL | {notes} |

### Test Results
- Total tests: {N}
- Passed: {N}
- Failed: {N}
- Skipped: {N}

### Known Differences
1. {Non-breaking behavioral difference}
2. {Intentional change with rationale}
```

### Template 3 — Quick Migration Guide

```markdown
## Quick Guide: {Specific Migration}

**What changes**:
- {Key change 1}
- {Key change 2}

**What stays the same**:
- {Unchanged element 1}
- {Unchanged element 2}

**Action items**:
1. {Most important change to make}
2. {Second priority}
3. {Third priority}
```

### Template 4 — Agent-Friendly Structured Output

```json
{
  "migration": {
    "source": {"language": "...", "framework": "...", "version": "..."},
    "target": {"language": "...", "framework": "...", "version": "..."},
    "estimated_effort": "...",
    "risk_level": "...",
    "phases": [
      {
        "name": "...",
        "tasks": ["..."],
        "dependencies": ["..."],
        "rollback_procedure": "..."
      }
    ],
    "known_incompatibilities": ["..."],
    "testing_requirements": ["..."]
  }
}
```

## Rules

1. **Never do a big-bang migration** — Always use incremental, reversible migration patterns (Strangler Fig, Parallel Run) for production systems.
2. **Test before you migrate** — Expand test coverage to >80% on the old codebase before changing anything. Tests are your safety net.
3. **Migrate tests first** — Convert test suites before production code; they validate correctness of the migration.
4. **Keep rollback paths open** — Every migration step must be reversible. Maintain the ability to revert for at least 2 weeks after cutover.
5. **Migrate leaf modules first** — Start with modules that have no dependents; work inward toward the core.
6. **Automate mechanical transformations** — Use AST-based tools, linters, and codemods for systematic changes; don't hand-edit hundreds of files.
7. **Verify data integrity at every step** — After each migration phase, compare data between old and new systems using checksums and row counts.
8. **Document every behavioral difference** — Even small differences (rounding, null handling, date formatting) can cause production incidents.
9. **Profile performance before and after** — Migration often introduces performance regressions that only appear under load. Benchmark key metrics.
10. **Maintain backward compatibility during transition** — APIs, data formats, and configuration must remain compatible during the migration window.
11. **Update CI/CD first** — Ensure your pipeline can build, test, and deploy the new code before migrating any application code.
12. **Communicate the migration plan** — Ensure all stakeholders (developers, ops, product, security) are aware of the migration timeline and rollback procedures.
