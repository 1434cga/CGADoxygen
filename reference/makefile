all: doxyfile
	mkdir -p build_doxygen/DOXYGEN_OUTPUT/html
	ln -sf ../../../PNG  ./build_doxygen/DOXYGEN_OUTPUT/html/PNG
	sh makeSrcLink.sh .. ../inc
	cd build_doxygen; make ; cd ..
	cd build_uml; make ; cd ..
	cd build_perlmod; make ; cd ..

clean:
	cd build_doxygen; make clean; cd ..
	cd build_uml; make clean; cd ..
	cd build_perlmod; make clean; cd ..

backup:
	/bin/rm -rf result/*
	mkdir -p result
	/bin/cp -L -r build_perlmod result
	/bin/cp -L -r build_doxygen/DOXYGEN_OUTPUT result

test: doxyfile
	mkdir -p build_doxygen/DOXYGEN_OUTPUT/html
	ln -sf ../../../PNG  ./build_doxygen/DOXYGEN_OUTPUT/html/PNG
	echo "Example"
	sh makeSrcLink.sh ./example
	cd build_doxygen; make ; cd ..
	cd build_uml; make ; cd ..
	cd build_perlmod; make ; cd ..
	pandoc -o README.docx -f markdown -t docx README.md

lgsi-org:
	mkdir -p build_doxygen/DOXYGEN_OUTPUT/html
	ln -sf ../../../PNG  ./build_doxygen/DOXYGEN_OUTPUT/html/PNG
	echo "LGSI Original"
	sh makeSrcLink.sh ./lgsi/original
	cd build_doxygen; make ; cd ..
	cd build_uml; make ; cd ..
	cd build_perlmod; make ; cd ..

lgsi-new: doxyfile
	mkdir -p build_doxygen/DOXYGEN_OUTPUT/html
	ln -sf ../../../PNG  ./build_doxygen/DOXYGEN_OUTPUT/html/PNG
	echo "LGSI New (Correct)"
	sh makeSrcLink.sh ./lgsi/correct
	cd build_doxygen; make ; cd ..
	cd build_uml; make ; cd ..
	cd build_perlmod; make ; cd ..

doxyfile:
	perl doxyfile.pl
