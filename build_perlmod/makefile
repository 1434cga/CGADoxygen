all: 
	mkdir -p outplantuml
	mkdir -p oldplantuml
	mkdir -p OUTPUT
	ln -sf ../outplantuml ./OUTPUT/outplantuml
	ln -sf ../../build_uml/UML ./outplantuml/UML
	ln -sf ./build_perlmod/OUTPUT ../OUTPUT
	ln -sf ../build_uml/UML/ ./UML

	perl convert.pl ../build_doxygen/DOXYGEN_OUTPUT/perlmod/DoxyDocs.pm ./DoxyDocs.pm  > a.log
	perl doxy2cga.pl default.GV > b.log
	perl cga2md.pl default.GV OUTPUT/LLD.md > c1.log
	perl cga2htmlmd.pl default.GV OUTPUT/LLD.html.md > c2.log
	perl cga2nece.pl default.GV OUTPUT/nece.html.md > c_nece.log
	perl cga2sequential.pl default.GV OUTPUT/sequ.html.md > c_sequ.log
	pandoc OUTPUT/LLD.html.md -o OUTPUT/LLD.html
	pandoc OUTPUT/LLD.html.md -f markdown -t html -s -o OUTPUT/LLD.css.html -c ../gh-pandoc.css
	pandoc OUTPUT/nece.html.md -f markdown -t html -s -o OUTPUT/nece.css.html -c ../gh-pandoc.css
	pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.css.html -c ../gh-pandoc.css
	#pandoc OUTPUT/LLD.html.md -f markdown -t html5 -s -o OUTPUT/LLD.styling.html -c styling.css
	#pandoc --css=styling.css -V lang=en -V highlighting-css= --mathjax --smart --to=html5 OUTPUT/LLD.html.md -o OUTPUT/output.html
	#pandoc --css=../gh-pandoc.css -V lang=en -V highlighting-css= --mathjax --smart --to=html5 OUTPUT/LLD.html.md -o OUTPUT/gh.html
	#pandoc --css=styling.css -V lang=en -V highlighting-css= --mathjax --smart --to=html5 LLD.html.md -o output.html
	perl ../collab.pl OUTPUT/LLD.md
	perl ../collab.pl OUTPUT/LLD.html
	perl ../collab.pl OUTPUT/LLD.html.md
	perl ../collab.pl OUTPUT/LLD.css.html
	perl cga2excel.pl default.GV OUTPUT/LLD.xlsx > c3.log
	perl cga2class.pl > class.log

	sh makeBasicDocumentsInOUTPUT.sh
	sh makePNG_jar_plantuml.sh

	cd OUTPUT; markdown-pp -o SDD.md    SDD.mdpp ; cd ..

	pandoc OUTPUT/SDD.md -f markdown -t html -s -o OUTPUT/SDD.html -c ../gh-pandoc.css
	pandoc OUTPUT/SDD.md -f markdown -s -o OUTPUT/SDD.pdf
	echo "$?"
	perl ../collab.pl OUTPUT/SDD.md
	perl ../collab.pl OUTPUT/SDD.html
	sh makeWord.sh

tt:
	perl cga2sequential.pl default.GV OUTPUT/sequ.html.md > c_sequ.log
	pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.css.html -c ../gh-pandoc.css
doc:
	pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.css.html -c ../gh-pandoc.css
	#pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.1-css.html -c ../gh-pandoc.css
	#pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.2-css.html -c ../pandoc.css
	#pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.3-css.html -c ../github.css
	#pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.4-css.html -c ../styling.css
	#pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.5-css.html -c ../tufte.css
	#pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.6-css.html -c ../p2.css
	#pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.7-css.html -c ../github-pandoc.css
	#pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.8-css.html -c ../nrstyle.css
	#pandoc OUTPUT/sequ.html.md -f markdown -t html -s -o OUTPUT/sequ.9-css.html -c ../tufte.css


clean:
	/bin/rm -rf ./outplantuml
	/bin/rm -rf ./oldplantuml
	/bin/rm -rf ./oldmd
	/bin/rm -rf ./*.log
	/bin/rm -rf ./DB4python.data
	/bin/rm -rf ./default.GV
	/bin/rm -rf ./OUTPUT
	/bin/rm -rf ./DoxyDocs.pm
	/bin/rm -rf ../OUTPUT
