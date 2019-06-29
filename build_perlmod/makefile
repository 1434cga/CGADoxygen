ALL: 
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
	pandoc OUTPUT/LLD.html.md -o OUTPUT/LLD.html
	pandoc OUTPUT/LLD.html.md -f markdown -t html -s -o OUTPUT/LLD.css.html -c ../gh-pandoc.css
	#pandoc OUTPUT/LLD.html.md -f markdown -t html5 -s -o OUTPUT/LLD.styling.html -c styling.css
	#pandoc --css=styling.css -V lang=en -V highlighting-css= --mathjax --smart --to=html5 OUTPUT/LLD.html.md -o OUTPUT/output.html
	#pandoc --css=../gh-pandoc.css -V lang=en -V highlighting-css= --mathjax --smart --to=html5 OUTPUT/LLD.html.md -o OUTPUT/gh.html
	#pandoc --css=styling.css -V lang=en -V highlighting-css= --mathjax --smart --to=html5 LLD.html.md -o output.html
	perl ../collab.pl OUTPUT/LLD.md
	perl ../collab.pl OUTPUT/LLD.html
	perl ../collab.pl OUTPUT/LLD.html.md
	perl ../collab.pl OUTPUT/LLD.css.html
	perl cga2excel.pl default.GV OUTPUT/LLD.xlsx > c3.log

	sh makeBasicDocumentsInOUTPUT.sh
	sh makePNG_jar_plantuml.sh

	cd OUTPUT; markdown-pp -o SDD.md    SDD.mdpp ; cd ..

	pandoc OUTPUT/SDD.md -f markdown -t html -s -o OUTPUT/SDD.html -c ../gh-pandoc.css
	perl ../collab.pl OUTPUT/SDD.md
	perl ../collab.pl OUTPUT/SDD.html
	sh makeWord.sh

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
