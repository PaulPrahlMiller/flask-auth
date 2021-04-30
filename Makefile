#!/usr/bin/env make

# Change this to be your variant of the python command
# PYTHON = python3
PYTHON = python
#PYTHON = py

.PHONY: pydoc

all:

venv:
	$(PYTHON) -m venv .venv

install:
	$(PYTHON) -m pip install -r requirements.txt

installed:
	$(PYTHON) -m pip list

clean:
	rm -f .coverage *.pyc
	rm -rf __pycache__
	rm -rf htmlcov

clean-doc:
	rm -rf doc

clean-all: clean clean-doc
	rm -rf .venv

database:
	$(PYTHON) -c 'import website.database as db; db.create_database("database.db")'

	sqlite3 database.db < ./db/schema.sql

	sqlite3 database.db \
	-cmd ".mode csv" \
	-cmd ".import ./db/restaurants.csv restaurants" \
	-cmd ".import ./db/foods.csv foods" \
	-cmd ".import ./db/foods_orders.csv foods_orders" \
	-cmd ".import ./db/orders.csv orders" \
	-cmd ".import ./db/organizations.csv organizations"

app:
	$(PYTHON) main.py

unittest:
	 $(PYTHON) -m unittest discover . "*_test.py"

coverage:
	coverage run -m unittest discover . "*_test.py"
	coverage html
	coverage report -m

pylint:
	pylint *.py

flake8:
	flake8

pydoc:
	install -d doc/pydoc
	$(PYTHON) -m pydoc -w "$(PWD)"
	mv *.html doc/pydoc

pdoc:
	rm -rf doc/pdoc
	pdoc --html -o doc/pdoc .

doc: pdoc pyreverse #pydoc sphinx

pyreverse:
	install -d doc/pyreverse
	pyreverse *.py
	dot -Tpng classes.dot -o doc/pyreverse/classes.png
	dot -Tpng packages.dot -o doc/pyreverse/packages.png
	rm -f classes.dot packages.dot
	ls -l doc/pyreverse

radon-cc:
	radon cc . -a

radon-mi:
	radon mi .

radon-raw:
	radon raw .

radon-hal:
	radon hal .

bandit:
	bandit -r .

lint: flake8 pylint

test: lint coverage
