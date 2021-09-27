PYTHON = python3
.PHONY = compile install test lint run dev

compile:
	pip install pip-tools
	pip-compile reqs/requirements_dev.in
	pip-compile reqs/requirements_test.in
	pip-compile reqs/requirements.in

install:
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
