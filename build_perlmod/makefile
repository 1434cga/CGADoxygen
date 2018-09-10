ALL: 
	mkdir -p outplantuml
	mkdir -p oldplantuml
	/bin/rm -f outplantuml/*.plantuml
	perl convert.pl ../build_doxygen/DOXYGEN_OUTPUT/perlmod/DoxyDocs.pm ./DoxyDocs.pm  > a.log
	perl doxy2cga.pl default.GV > b.log
	perl cga2md.pl default.GV LLD.md > c1.log
	perl cga2htmlmd.pl default.GV LLD.html.md > c2.log
	pandoc -o LLD.html LLD.html.md
	pandoc LLD.html.md -f markdown -t html -s -o LLD.css.html -c pandoc.css
	perl ../collab.pl LLD.md
	perl ../collab.pl LLD.html
	perl ../collab.pl LLD.html.md
	perl ../collab.pl LLD.css.html
	perl cga2excel.pl default.GV LLD.xlsx > c3.log
	perl plantuml2fileInMarkdown.pl HLD.plantuml.md HLD.md > d1.log
	perl plantuml2fileInMarkdown.pl README.plantuml.md README.md > d2.log
	sh makePNG_jar_plantuml.sh
	markdown-pp -o LLD_SRS.md    LLD_SRS.mdpp
	pandoc LLD_SRS.md -f markdown -t html -s -o LLD_SRS.html -c pandoc.css
	perl ../collab.pl LLD_SRS.md
	perl ../collab.pl LLD_SRS.html
	markdown-pp -o CODEGEN.md    CODEGEN.mdpp
	pandoc CODEGEN.md -f markdown -t html -s -o CODEGEN.html -c pandoc.css
	perl ../collab.pl CODEGEN.md
	perl ../collab.pl CODEGEN.html
	markdown-pp -o SDD.md    SDD.mdpp
	pandoc SDD.md -f markdown -t html -s -o SDD.html -c pandoc.css
	perl ../collab.pl SDD.md
	perl ../collab.pl SDD.html
	markdown-pp -o DOC.md    README.mdpp
	pandoc DOC.md -f markdown -t html -s -o DOC.html -c pandoc.css
	perl ../collab.pl DOC.md
	perl ../collab.pl DOC.html
	sh pandoc.sh

clean:
	/bin/rm -rf ./outplantuml
	/bin/rm -rf ./oldplantuml
	/bin/rm -rf ./oldmd
