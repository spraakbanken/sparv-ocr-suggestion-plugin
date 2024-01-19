

.default: help

.PHONY: help
help:
	@echo "usage:"
	@echo "dev | install-dev"
	@echo "   setup development environment"
	@echo ""
	@echo ""
	@echo "test | run-all-tests"
	@echo "   run all tests"
	@echo ""
	@echo "test-w-coverage"
	@echo "   run all tests with coverage collection"
	@echo ""
	@echo "lint"
	@echo "   lint the code"
	@echo ""
	@echo "type-check"
	@echo "   check types"
	@echo ""
	@echo "fmt"
	@echo "   format the code"
	@echo ""
	@echo "check-fmt"
	@echo "   check that the code is formatted"
	@echo ""

PLATFORM := `uname -o`
PROJECT := "sparv_ocr_suggestion"
PROJECT_SRC := "src/sparv_ocr_suggestion"

ifeq (${VIRTUAL_ENV},)
  VENV_NAME = .venv
  INVENV = rye run
else
  VENV_NAME = ${VIRTUAL_ENV}
  INVENV =
endif

default_cov := "--cov=src/json_streams"
cov_report := "term-missing"
cov := ${default_cov}

all_tests := tests
tests := tests

info:
	@echo "Platform: ${PLATFORM}"
	@echo "INVENV: '${INVENV}'"

dev: install-dev

# setup development environment
install-dev:
	rye sync --no-lock

test: run-all-tests

# run all tests
run-all-tests:
	${INVENV} pytest -vv ${tests}

# run all tests with coverage collection
test-w-coverage:
	${INVENV} pytest -vv ${cov}  --cov-report=${cov_report} ${all_tests}

# check types
type-check:
	${INVENV} mypy ${PROJECT_SRC} ${tests}

# lint the code
lint:
	${INVENV} ruff ${PROJECT_SRC} ${tests}

part := "patch"
bumpversion: install-dev
	${INVENV} bump2version ${part}

# run formatter(s)
fmt:
	${INVENV} ruff ${PROJECT_SRC} ${tests}

# check formatting
check-fmt:
	${INVENV} ruff format --check ${PROJECT_SRC} ${tests}