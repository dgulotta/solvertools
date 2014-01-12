PYTHON=python3.3

all: setup wordlists

setup: env/bin/activate julia-setup.log

julia-setup.log: julia/setup.jl
	julia julia/setup.jl > julia-setup.log

wordlists: wordlists/enable.txt wordlists/twl06.txt \
	wordlists/google-books.ascii.freq.txt \
	wordlists/google-books.ascii.alph.txt

env/bin/activate: py-requirements.txt
	test -d env || virtualenv --python=$(PYTHON) env
	. env/bin/activate ; pip install -U -r py-requirements.txt
	touch env/bin/activate

wordlists/google-books.ascii.freq.txt: wordlists/raw/google-books-1grams.txt
	LC_ALL=C egrep "^[A-Z]+	" $< > $@

wordlists/google-books.ascii.alph.txt: wordlists/google-books.ascii.freq.txt
	LC_ALL=C sort $< > $@

wordlists/enable.txt: wordlists/raw/enable.txt
	tr a-z A-Z < $< | shell/freq1.sh > $@

wordlists/twl06.txt: wordlists/raw/twl06.txt
	tr a-z A-Z < $< | shell/freq1.sh > $@

doc: docs/SolverTools.html

docs/SolverTools.html: julia/SolverTools.jl jocco.jl
	julia julia/jocco.jl julia/SolverTools.jl