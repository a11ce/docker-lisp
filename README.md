# Docker Lisp

A Docker image is a piece of executable code that produces some output given some input.

## Requirements

- Docker

## Setup

First, build the base images and builtins.

```bash
./scripts/build-base
./scripts/build-builtins
```

Then, run the tests. Be patient.
```bash
./scripts/run-tests
```

## Usage

Run `eval` to evaluate expressions.
```bash
./scripts/run eval "(cons 1 2)"
```

Pass `--trace` to `run` to see all calls.
```bash
./scripts/run --trace eval "(car (cdr (cons 1 (cons 2 (list)))))"
```

You can write programs:
```dockerfile
FROM docker-lisp/eval
CMD ["(car (cdr (list 1 2 3 4 5)))"]
```

Build them with
```bash
./scripts/build <program path> [name]
```
or
```bash
./scripts/build <program path> # Uses the filename if no name is specified
```

Then run with
```bash
./scripts/run <name>
```

## Scripts

| Script | Purpose |
|--------|-------------|
| `build <file> [name]` | Build a Dockerfile into `docker-lisp/<name>`. Defaults to basename. |
| `build-base` | Build base images (`docker-lisp/base-racket`, `docker-lisp/base-call`) |
| `build-builtins` | Build all builtin images |
| `run [--trace] <image> [args]` | Run a `docker-lisp/<image>` container |
| `run-tests [--no-trace] [--rebuild-base] [prefix filter]` | Run the tests (with traces by default) |
| `clean` | Kill all `docker-lisp/*` containers and remove all built `docker-lisp/*` images |
