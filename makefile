PYTHON = python3
.PHONY = setup test lint run

setup:
	pip install -r reqs/requirements_dev.txt
	pip install -r reqs/requirements_test.txt
	pip install -r reqs/requirements.txt
	pre-commit install

test:
	pytest tests/

lint:
	pre-commit run --all-files

run:
	python example/
