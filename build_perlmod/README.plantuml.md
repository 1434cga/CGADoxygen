# doxygen Doxyfile

# Install
- https://perlmaven.com/read-an-excel-file-in-perl

## perl module install
- cpan
	- $ install Spreadsheet::Read
		- When I run read.pl , I meet the following msg "Parser for XLSX is not installed at read.pl line 9."
	- $ install Spreadsheet::XLSX

- install tools
	- setting_env.sh : It should be changed.
- sh makeSrcLink.sh : make a soft link in src
- cd build_doxygen; make
	- DOXYGEN_OUT   :  doxygen documents
	- DOXYGEN_OUT/perlmod/DoxyDocs.pm  : this is perl module for doxygen.
- cd build_uml; make
	- UML  : class files and uml files of plantuml
- cd build_perlmod; make
	- MgrTelltale.md :  Telltale detailed documents based on doxygen (Classes)
	- MgrTelltale.plantuml.md  :  Telltale detailed documents based on doxygen with plantuml (Classes)
	- MgrTelltale.xlsx : use as reference about classes and variables
	- SDD.md : chapter 1,2 of Telltale
	- MgrTelltale4OEM.md : it is made from SDD.mdpp (combined file)
		chapter 1,2 (SDD.plantuml.md) , Chapter 3,4,5 (MgrTelltale.md : file from doxygen)
	- SDD.docx : Chapter 1,2
	- MgrTelltale.docx : Chapter 3,4,5
	- MgrTelltale4OEM.docx : Chapter 1,2,3,4,5 (all)

# perl convert.pl
- Change DoxyDocs.pm to correct the error. The Error is that hash is not in array directly.
	- default input : ../build_doxygen/DOXYGEN_OUTPUT/perlmod/DoxyDocs.pm
	- default output : ./DoxyDocs.pm


```
!include ./UML/CTelltaleBase.class
AKlass -up-> CTelltaleBase
AKtmp -up-> CTelltaleBase
```

# perl doxy2cga.pl
- DoxyDocs.pm (one data structure) will be changed into perl hash type.
	- understand easily : $D { files } { 2 } { includes } { 1 } { name } =  "Inc/Cmn/CGlobalData.h"
	- default input : DoxyDocs.pm
	- default output : default.GV

# perl cga2md.pl
- make a LLD markdown file from easier understandable perl hash type.
	- default input : default.GV
	- default output : out.md

```
!include ./UML/CTelltaleBase.class
!include ./UML/CNormal.class
CNormal -up-> CTelltaleBase
```

# perl cga2excel.pl
- make a LLD excel file from easier understandable perl hash type.
	- default input : default.GV
	- default output : out.xlsx

## Need to install perl module  ( Excel::Writer::XLSX )
- $ cpan
	- [all yes]
	- cpan[1]> install Excel::Writer::XLSX

## help
- http://search.cpan.org/~jmcnamara/Excel-Writer-XLSX/lib/Excel/Writer/XLSX.pm
- https://metacpan.org/pod/Excel::Writer::XLSX

## run cga2excel.pl
- make a out.xlsx file

# todo
- class : note date author
- public_members    [OK:18/07/05]
- public_static_methods    [OK:18/07/05]
- retvals : add { } like params [OK:18/07/04]
- create plantuml file    [OK:18/07/05]
- create plantuml png : ./plantuml/run.sh   [OK:18/07/05]
	-  /startuml [file] [caption] [sizeindication=size]
							width=5cm
- md include the link of plantuml png (ex. outWithImage.md)   [OK:18/07/05]
- verify  (doxygen_example/src/KKK.cpp)
	- creating the new method like @todo1 / @todo2 / @todo3 / @step [OK:18/07/07]
		- xrefitem  then find the same contents in page hash
	- @code (Can we make a Title?  If not , we will use the first line as a title.(Title:....))         ********
		- preformatted   (for algorithm)
	- We should find matching in pages =>  . Choose the pages => name with maximum count of match.  [OK:18/07/07]
		<-- this is the second best solution..... *^^*  I will try it.
- check group function and code or verbatim and snippet  / section <- Not proper command for documents [OK:18/07/07]
	- \snippet
		- purpose : reuse the sample code from sample code file
		- @snippet file SNIPPET_NAME
		- insert following lines at proper location in file
			//! [SNIPPET_NAME]
			codes.......
			//! [SNIPPET_NAME]
		- working well : change the EXAMPLE_PATH in Doxyfile (config)
	- \defgroup
		- wrong operation : Do not work.
	- section does not give the right result
- class basic plantuml file (class definition plantuml : private public)
	- includes!             [OK:18/07/08]
	- hpp2plantuml      (Just OSX) - I failed to install hpp2plantuml in Linux.
- python -> office word file        <-  refer to pandoc. So , I will not try it.
- pandoc to convert into word   [OK:18/07/08]
	- pandoc -o outWithImageLink.docx -f markdown -t docx outWithImageLink.md
	- Caution :
		- insert enter key before/after table
		- adjust the proper tab count.  Do not skip the tab count.   Start the - indication from ^ of line.
		- translate plantuml to png
- mdpp : include function [https://github.com/jreese/markdown-pp]
	- First of all , make the markdown with plantuml.
	  You can show markdown with plantuml in ATOM editor with enhanced-markdown-preview plugin.
		- verify include in plnatuml --> OK  [OK:18/07/08]
```
			!include ./outplantuml/class_AKlass.uml
			AKlass -up-> CTelltaleBase
```
			- cat outplantuml/class_AKlass.uml
			Class AKlass
			AKlass : int size()
			AKlass : void clear()
		- When I make a png , can we use !include in plantuml?  --> OK [OK:18/07/08]
	- combine markdown files with mdpp
		- md file written for documents
			I will change the plantuml when I include md file with plantuml.
		- md file from doxygen
- SRS
	- refer to since{2,16}   <- it is a good solution for making the SRS number
		I will find which function uses since number in default.GV.
		https://mail.gnome.org/archives/commits-list/2009-August/msg05596.html

