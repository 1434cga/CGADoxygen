ALL: 
	mkdir -p outplantuml
	mkdir -p oldplantuml
	mkdir -p OUTPUT
	ln -sf ../SDD.mdpp OUTPUT/SDD.mdpp
	ln -sf ../outplantuml OUTPUT/outplantuml
	/bin/rm -f outplantuml/*.plantuml

	perl convert.pl ../build_doxygen/DOXYGEN_OUTPUT/perlmod/DoxyDocs.pm ./DoxyDocs.pm  > a.log
	perl doxy2cga.pl default.GV > b.log
	perl cga2md.pl default.GV OUTPUT/LLD.md > c1.log
	perl cga2htmlmd.pl default.GV OUTPUT/LLD.html.md > c2.log
	pandoc OUTPUT/LLD.html.md -o OUTPUT/LLD.html 
	pandoc OUTPUT/LLD.html.md -f markdown -t html -s -o OUTPUT/LLD.css.html -c pandoc.css
	perl ../collab.pl OUTPUT/LLD.md
	perl ../collab.pl OUTPUT/LLD.html
	perl ../collab.pl OUTPUT/LLD.html.md
	perl ../collab.pl OUTPUT/LLD.css.html
	perl cga2excel.pl default.GV OUTPUT/LLD.xlsx > c3.log
	perl plantuml2fileInMarkdown.pl work/HLD.plantuml.md OUTPUT/HLD.md > d1.log
	#perl plantuml2fileInMarkdown.pl README.plantuml.md README.md > d2.log
	sh makePNG_jar_plantuml.sh
	markdown-pp -o OUTPUT/LLD_SRS.md    LLD_SRS.mdpp
	pandoc OUTPUT/LLD_SRS.md -f markdown -t html -s -o OUTPUT/LLD_SRS.html -c pandoc.css
	perl ../collab.pl OUTPUT/LLD_SRS.md
	perl ../collab.pl OUTPUT/LLD_SRS.html
	#markdown-pp -o OUTPUT/CODEGEN.md    CODEGEN.mdpp
	#pandoc CODEGEN.md -f markdown -t html -s -o OUTPUT/CODEGEN.html -c pandoc.css
	#perl ../collab.pl OUTPUT/CODEGEN.md
	#perl ../collab.pl OUTPUT/CODEGEN.html
	markdown-pp -o OUTPUT/SDD.md    SDD.mdpp
	pandoc OUTPUT/SDD.md -f markdown -t html -s -o OUTPUT/SDD.html -c pandoc.css
	perl ../collab.pl OUTPUT/SDD.md
	perl ../collab.pl OUTPUT/SDD.html
	#markdown-pp -o DOC.md    README.mdpp
	#pandoc DOC.md -f markdown -t html -s -o DOC.html -c pandoc.css
	#perl ../collab.pl DOC.md
	#perl ../collab.pl DOC.html
	sh pandoc.sh

clean:
	/bin/rm -rf ./outplantuml
	/bin/rm -rf ./oldplantuml
	/bin/rm -rf ./oldmd
