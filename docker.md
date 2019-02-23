# docker install in windows
- download and install docker program : https://hub.docker.com/editions/community/docker-ce-desktop-windows
- Open a command-line terminal like PowerShell, and try out some Docker commands!

# Verify CGADoxygen in docker
- docker run
```text
$ docker run --rm -it ubuntu:16.04 /bin/bash
```

- make environment in docker
```text
apt-get update
apt-get install -y --no-install-recommends apt-utils build-essential sudo git python-dev python-pip python-setuptools javacc java-common pandoc doxygen vim python3-pip python3-setuptools graphviz 

... Wait for a long long time.....

cpan Excel::Writer::XLSX

cd /tmp

git clone https://github.com/thibaultmarin/hpp2plantuml.git
cd hpp2plantuml
python3 setup.py install
cd ..

git clone https://github.com/jreese/markdown-pp.git
cd markdown-pp
python setup.py install
cd ..
```

- CGADOXYGEN download and run example
```text
git clone https://github.com/cheoljoo/CGADoxygen.git
cd CGADoxygen
sh run.sh clean
sh run.sh example/A
```
- This is running log of run.sh
```text
# sh run.sh example/A
/usr/local/bin/hpp2plantuml
/usr/bin/pandoc
/usr/local/bin/markdown-pp
Already perlmodule was installed. If you want to initialize , remove .perlmodule file
Machine => Linux
#### Make soft links in src ####
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
directory : example/A
    basefile : AKlass.cpp  ,  file : example/A/AKlass.cpp
make soft linke /tmp/CGADoxygen/example/A/AKlass.cpp <-- ./build_doxygen/src/AKlass.cpp  ./build_uml/src/AKlass.cpp ./build_perlmod/AKlass.cpp
    basefile : *.cc  ,  file : example/A/*.cc
    basefile : AKlass.h  ,  file : example/A/AKlass.h
make soft linke /tmp/CGADoxygen/example/A/AKlass.h <-- ./build_doxygen/src/AKlass.h  ./build_uml/src/AKlass.h ./build_perlmod/AKlass.h
    basefile : *.hpp  ,  file : example/A/*.hpp
    basefile : HLD.plantuml.md  ,  file : example/A/HLD.plantuml.md
make soft linke /tmp/CGADoxygen/example/A/HLD.plantuml.md <-- ./build_perlmod/work/HLD.plantuml.md
    basefile : README.md  ,  file : example/A/README.md
make soft linke /tmp/CGADoxygen/example/A/README.md <-- ./build_perlmod/work/README.md
    basefile : SRS.md  ,  file : example/A/SRS.md
make soft linke /tmp/CGADoxygen/example/A/SRS.md <-- ./build_perlmod/work/SRS.md
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
### Source C/C++/Header Files for making a doxygen : ls ./build_doxygen/src/ ####
total 8
drwxr-xr-x 2 root root 4096 Feb  1 01:53 ./
drwxr-xr-x 3 root root 4096 Feb  1 01:53 ../
lrwxrwxrwx 1 root root   36 Feb  1 01:53 AKlass.cpp -> /tmp/CGADoxygen/example/A/AKlass.cpp
lrwxrwxrwx 1 root root   34 Feb  1 01:53 AKlass.h -> /tmp/CGADoxygen/example/A/AKlass.h
### Source MarkDown Files for making a doxygen : ls ./build_perlmod/work/ ####
total 8
drwxr-xr-x 2 root root 4096 Feb  1 01:53 ./
drwxr-xr-x 5 root root 4096 Feb  1 01:53 ../
lrwxrwxrwx 1 root root   41 Feb  1 01:53 HLD.plantuml.md -> /tmp/CGADoxygen/example/A/HLD.plantuml.md
lrwxrwxrwx 1 root root   35 Feb  1 01:53 README.md -> /tmp/CGADoxygen/example/A/README.md
lrwxrwxrwx 1 root root   32 Feb  1 01:53 SRS.md -> /tmp/CGADoxygen/example/A/SRS.md
#### build_doxygen makefile ####
./doxygen.sh
#### Run Doxygen ####
warning: ignoring unsupported tag `OUTPUT_TEXT_DIRECTION  =' at line 102, file Doxyfile
warning: ignoring unsupported tag `TOC_INCLUDE_HEADINGS   =' at line 341, file Doxyfile
warning: ignoring unsupported tag `HTML_DYNAMIC_MENUS     =' at line 1264, file Doxyfile
warning: ignoring unsupported tag `PLANTUML_CFG_FILE      =' at line 2444, file Doxyfile
#### build_uml makefile ####
sh ./hpp2plantuml.sh
#### Check Differnce of Header files for hpp2plantuml####
--> overall information : hpp2plantuml -> UML/__ALL__.class
diff -q src/AKlass.h old/AKlass.h
diff: old/AKlass.h: No such file or directory
--> src/AKlass.h changed : hpp2plantuml -> UML/AKlass.h.uml
diff -q src/AKlass.cpp old/AKlass.cpp
diff: old/AKlass.cpp: No such file or directory
--> src/AKlass.cpp changed : hpp2plantuml -> UML/AKlass.cpp.uml
perl class.pl < UML/__ALL__.class
1: 2:AKlass
#### build_perlmod makefile ####
mkdir -p outplantuml
mkdir -p oldplantuml
mkdir -p OUTPUT
ln -sf ../outplantuml ./OUTPUT/outplantuml
ln -sf ../../build_uml/UML ./outplantuml/UML
ln -sf ./build_perlmod/OUTPUT ../OUTPUT
perl convert.pl ../build_doxygen/DOXYGEN_OUTPUT/perlmod/DoxyDocs.pm ./DoxyDocs.pm  > a.log
infile : ../build_doxygen/DOXYGEN_OUTPUT/perlmod/DoxyDocs.pm , outfile : ./DoxyDocs.pm

======================================================
 Current Version 1.8.11 <= 1.8.14
 Run convet.pl to modify DoxyDocs.pm (add braces).
======================================================

in : ../build_doxygen/DOXYGEN_OUTPUT/perlmod/DoxyDocs.pm  , outfile : ./DoxyDocs.pm
perl doxy2cga.pl default.GV > b.log
input DoxyDocs.pm  output filename = default.GV
input DoxyDocs.pm  output filename = DB4python.data
perl cga2md.pl default.GV OUTPUT/LLD.md > c1.log
in : default.GV  , out md file : OUTPUT/LLD.md , out md file with plantuml : OUTPUT/LLD.plantuml.md
in : default.GV  , out md file : OUTPUT/LLD.SRS.md , out md file with plantuml : OUTPUT/LLD.plantuml.SRS.md
perl cga2htmlmd.pl default.GV OUTPUT/LLD.html.md > c2.log
in : default.GV  , out md file : OUTPUT/LLD.html.md , out md file with plantuml : OUTPUT/LLD.html.plantuml.md
in : default.GV  , out md file : OUTPUT/LLD.html.SRS.md , out md file with plantuml : OUTPUT/LLD.html.plantuml.SRS.md
pandoc OUTPUT/LLD.html.md -o OUTPUT/LLD.html
pandoc OUTPUT/LLD.html.md -f markdown -t html -s -o OUTPUT/LLD.css.html -c ../gh-pandoc.css
#pandoc OUTPUT/LLD.html.md -f markdown -t html5 -s -o OUTPUT/LLD.styling.html -c styling.css
#pandoc --css=styling.css -V lang=en -V highlighting-css= --mathjax --smart --to=html5 OUTPUT/LLD.html.md -o OUTPUT/output.html
#pandoc --css=../gh-pandoc.css -V lang=en -V highlighting-css= --mathjax --smart --to=html5 OUTPUT/LLD.html.md -o OUTPUT/gh.html
#pandoc --css=styling.css -V lang=en -V highlighting-css= --mathjax --smart --to=html5 LLD.html.md -o output.html
perl ../collab.pl OUTPUT/LLD.md
infile = OUTPUT/LLD.md , outfile = OUTPUT/LLD.collab.md
perl ../collab.pl OUTPUT/LLD.html
infile = OUTPUT/LLD.html , outfile = OUTPUT/LLD.collab.html
perl ../collab.pl OUTPUT/LLD.html.md
infile = OUTPUT/LLD.html.md , outfile = OUTPUT/LLD.html.collab.md
perl ../collab.pl OUTPUT/LLD.css.html
infile = OUTPUT/LLD.css.html , outfile = OUTPUT/LLD.css.collab.html
perl cga2excel.pl default.GV OUTPUT/LLD.xlsx > c3.log
in : default.GV  , Excel out : OUTPUT/LLD.xlsx
sh makeBasicDocumentsInOUTPUT.sh
####  *.plantuml.md -> OUTPUT/*.md ####
HLD.plantuml.md
######  HLD.plantuml.md -> OUTPUT/ ######
infile : HLD.plantuml.md , outfile : ../OUTPUT/HLD.md
The generated plantuml files are in ./outplantuml directory.
[out:HLD_md_1_external_design] [f:external_design] [cnt:1]
Current Directory : /tmp/CGADoxygen/build_perlmod/work
Generated output file .plantuml : ../outplantuml/HLD_md_1_external_design.plantuml  depth(0)  desc(shows the relationship between MgrTelltale and other external components.)
Generated output file .png : HLD_md_1_external_design.png
[out:HLD_md_2_class_brief] [f:class_brief] [cnt:2]
Current Directory : /tmp/CGADoxygen/build_perlmod/work
Generated output file .plantuml : ../outplantuml/HLD_md_2_class_brief.plantuml  depth(0)  desc(Brief Class Diagram)
Generated output file .png : HLD_md_2_class_brief.png
[out:HLD_md_3_class_detail_png] [f:class_detail.png] [cnt:3]
Current Directory : /tmp/CGADoxygen/build_perlmod/work
Generated output file .plantuml : ../outplantuml/HLD_md_3_class_detail_png.plantuml  depth(0)  desc(Detailed Class Diagram)
Generated output file .png : HLD_md_3_class_detail_png.png
[out:HLD_md_4_total_seq_design] [f:total_seq_design] [cnt:4]
Current Directory : /tmp/CGADoxygen/build_perlmod/work
Generated output file .plantuml : ../outplantuml/HLD_md_4_total_seq_design.plantuml  depth(0)  desc(Overall Sequence)
Generated output file .png : HLD_md_4_total_seq_design.png
[out:HLD_md_5_] [f:] [cnt:5]
Current Directory : /tmp/CGADoxygen/build_perlmod/work
Generated output file .plantuml : ../outplantuml/HLD_md_5_.plantuml  depth(0)  desc(Simple Sequence between ODI Manager and CMgrTelltale class)
Generated output file .png : HLD_md_5_.png
[out:HLD_md_6_] [f:] [cnt:6]
Current Directory : /tmp/CGADoxygen/build_perlmod/work
Generated output file .plantuml : ../outplantuml/HLD_md_6_.plantuml  depth(1)  desc(process Telltale in CMgrTelltale class)
Generated output file .png : HLD_md_6_.png
[out:HLD_md_7_TimerSequence_png] [f:TimerSequence.png] [cnt:7]
Current Directory : /tmp/CGADoxygen/build_perlmod/work
Generated output file .plantuml : ../outplantuml/HLD_md_7_TimerSequence_png.plantuml  depth(1)  desc(Timer Sequence)
Generated output file .png : HLD_md_7_TimerSequence_png.png
README.md
######  README.md -> OUTPUT/ ######
copy outdir : ../OUTPUT , infile : README.md , outfile : ../OUTPUT/README.md
SRS.md
######  SRS.md -> OUTPUT/ ######
copy outdir : ../OUTPUT , infile : SRS.md , outfile : ../OUTPUT/SRS.md
#### Check basic files (SDD.mdpp SRS.md HLD.md) to make SDD ####
######  ./OUTPUT/SDD.mdpp does not exist in Source ######
######  So , we use default SDD.mdpp. ######
######  ./OUTPUT/SRS.md exists in Source ######
######  ./OUTPUT/HLD.md exists in Source ######
sh makePNG_jar_plantuml.sh
#### Check Differnce of plantuml files ####
diff -q HLD_md_1_external_design.plantuml ../oldplantuml/HLD_md_1_external_design.plantuml
diff: ../oldplantuml/HLD_md_1_external_design.plantuml: No such file or directory
--> HLD_md_1_external_design.plantuml changed : plantuml.jar -> png
diff -q HLD_md_2_class_brief.plantuml ../oldplantuml/HLD_md_2_class_brief.plantuml
diff: ../oldplantuml/HLD_md_2_class_brief.plantuml: No such file or directory
--> HLD_md_2_class_brief.plantuml changed : plantuml.jar -> png
diff -q HLD_md_3_class_detail_png.plantuml ../oldplantuml/HLD_md_3_class_detail_png.plantuml
diff: ../oldplantuml/HLD_md_3_class_detail_png.plantuml: No such file or directory
--> HLD_md_3_class_detail_png.plantuml changed : plantuml.jar -> png
diff -q HLD_md_4_total_seq_design.plantuml ../oldplantuml/HLD_md_4_total_seq_design.plantuml
diff: ../oldplantuml/HLD_md_4_total_seq_design.plantuml: No such file or directory
--> HLD_md_4_total_seq_design.plantuml changed : plantuml.jar -> png
diff -q HLD_md_5_.plantuml ../oldplantuml/HLD_md_5_.plantuml
diff: ../oldplantuml/HLD_md_5_.plantuml: No such file or directory
--> HLD_md_5_.plantuml changed : plantuml.jar -> png
diff -q HLD_md_6_.plantuml ../oldplantuml/HLD_md_6_.plantuml
diff: ../oldplantuml/HLD_md_6_.plantuml: No such file or directory
--> HLD_md_6_.plantuml changed : plantuml.jar -> png
diff -q HLD_md_7_TimerSequence_png.plantuml ../oldplantuml/HLD_md_7_TimerSequence_png.plantuml
diff: ../oldplantuml/HLD_md_7_TimerSequence_png.plantuml: No such file or directory
--> HLD_md_7_TimerSequence_png.plantuml changed : plantuml.jar -> png
diff -q class_CTelltaleBase.plantuml ../oldplantuml/class_CTelltaleBase.plantuml
diff: ../oldplantuml/class_CTelltaleBase.plantuml: No such file or directory
--> class_CTelltaleBase.plantuml changed : plantuml.jar -> png
diff -q class_family__AKlass.plantuml ../oldplantuml/class_family__AKlass.plantuml
diff: ../oldplantuml/class_family__AKlass.plantuml: No such file or directory
--> class_family__AKlass.plantuml changed : plantuml.jar -> png
diff -q class_family__AKlass_public_methods_AKlass.plantuml ../oldplantuml/class_family__AKlass_public_methods_AKlass.plantuml
diff: ../oldplantuml/class_family__AKlass_public_methods_AKlass.plantuml: No such file or directory
--> class_family__AKlass_public_methods_AKlass.plantuml changed : plantuml.jar -> png
diff -q class_family__AKlass_public_methods_Draw.plantuml ../oldplantuml/class_family__AKlass_public_methods_Draw.plantuml
diff: ../oldplantuml/class_family__AKlass_public_methods_Draw.plantuml: No such file or directory
--> class_family__AKlass_public_methods_Draw.plantuml changed : plantuml.jar -> png
cd OUTPUT; markdown-pp -o SDD.md    SDD.mdpp ; cd ..
pandoc OUTPUT/SDD.md -f markdown -t html -s -o OUTPUT/SDD.html -c ../gh-pandoc.css
perl ../collab.pl OUTPUT/SDD.md
infile = OUTPUT/SDD.md , outfile = OUTPUT/SDD.collab.md
perl ../collab.pl OUTPUT/SDD.html
infile = OUTPUT/SDD.html , outfile = OUTPUT/SDD.collab.html
sh makeWord.sh
/tmp/CGADoxygen/build_perlmod/OUTPUT
#### Check Differnce of md files for pandoc ####
diff -q LLD.md ../oldmd/LLD.md
diff: ../oldmd/LLD.md: No such file or directory
--> LLD.md changed : pandoc -o LLD.docx -f markdown -t docx LLD.md
diff -q HLD.md ../oldmd/HLD.md
diff: ../oldmd/HLD.md: No such file or directory
--> HLD.md changed : pandoc -o HLD.docx -f markdown -t docx HLD.md
diff -q SDD.md ../oldmd/SDD.md
diff: ../oldmd/SDD.md: No such file or directory
--> SDD.md changed : pandoc -o SDD.docx -f markdown -t docx SDD.md

```

# CGADOXYGEN docker distribution
- docker run with volume in windows (if linux , you change directory of host part.)
```text
docker run -it -v c:\Users\USER\docker:/docker --name CGADOXYGEN ubuntu:16.04 /bin/bash
```
    - share the diretory between c:\Users\USER\docker (host) and /docker (container)
    
- make environment in docker
```text
apt-get update
apt-get install -y --no-install-recommends apt-utils build-essential sudo git python-dev python-pip python-setuptools javacc java-common pandoc doxygen vim python3-pip python3-setuptools graphviz 

... Wait for a long long time.....

cpan Excel::Writer::XLSX

cd /tmp

git clone https://github.com/thibaultmarin/hpp2plantuml.git
cd hpp2plantuml
python3 setup.py install
cd ..

git clone https://github.com/jreese/markdown-pp.git
cd markdown-pp
python setup.py install
cd ..

```

- docker push into hub (container CGADOXYGEN)
```text
docker ps -all
     CONTAINER ID        IMAGE                          COMMAND                  CREATED             STATUS                        PORTS               NAMES
     be6618c88e99        ubuntu:16.04                   "/bin/bash"              3 hours ago         Exited (0) 2 hours ago                            CGADOXYGEN

docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
    ubuntu                     16.04               7e87e2b3bf7a        9 days ago          117MB

docker commit CGADOXYGEN ubuntu16:cgadoxygen

docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
    ubuntu16                   cgadoxygen          17a991622e19        4 seconds ago       833MB

docker run -it ubuntu16:cgadoxygen /bin/bash

docker ps --all
    CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                      PORTS               NAMES
    f3ede611a5e0        ubuntu16:cgadoxygen   "/bin/bash"         52 seconds ago      Exited (0) 34 seconds ago                       quizzical_goldwasser
    
docker login --username=[ID]
    Password:
    Login Succeeded

docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
    ubuntu16                   cgadoxygen          17a991622e19        4 seconds ago       833MB

docker tag 17a991622e19 cheoljoo/ubuntu16:cgadoxygen

docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
    ubuntu16                   cgadoxygen          17a991622e19        About an hour ago   833MB
    cheoljoo/ubuntu16          cgadoxygen          17a991622e19        About an hour ago   833MB

docker push cheoljoo/ubuntu16
    The push refers to repository [docker.io/cheoljoo/ubuntu16]
    5e3bfc1e2c78: Pushed
    68dda0c9a8cd: Pushed
    f67191ae09b8: Pushed
    b2fd8b4c3da7: Pushed
    0de2edf7bff4: Pushed
    cgadoxygen: digest: sha256:557bfaf8c1648fe55ec508f53ecdb06c42bdce2d8c0b459a52309555d575cdbb size: 1363
```


- delete container and images   to check pull request
```text
docker rmi cheoljoo/ubuntu16:cgadoxygen              <- remove image tag

docker rmi ubuntu16:cgadoxygen
    Untagged: ubuntu16:cgadoxygen
    Deleted: sha256:17a991622e190fa0d509a71a7124ff42c96dc9f40ebdecbc1de0b2003f3af692
    Deleted: sha256:4d63c67cb814753a6e69b141afdd5cd06a555162f86352a43af355164c279e2f
```
   
# docker environment from dockerhub
- docker pull from hub  (cheoljoo/ubuntu16:cgadoxygen)
```text
docker pull cheoljoo/ubuntu16:cgadoxygen
    cgadoxygen: Pulling from cheoljoo/ubuntu16
    7b722c1070cd: Already exists
    5fbf74db61f1: Already exists
    ed41cb72e5c9: Already exists
    7ea47a67709e: Already exists
    38181ed22b86: Pull complete
    Digest: sha256:557bfaf8c1648fe55ec508f53ecdb06c42bdce2d8c0b459a52309555d575cdbb
    Status: Downloaded newer image for cheoljoo/ubuntu16:cgadoxygen

docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
    cheoljoo/ubuntu16          cgadoxygen          17a991622e19        About an hour ago   833MB

docker run -it -v c:\Users\USER\docker:/docker --name cga1 cheoljoo/ubuntu16:cgadoxygen  /bin/bash
    root@086eddeb073b:/# exit

docker start cga1
docker attach cga1
    root@086eddeb073b:/#
```

# BLOG
- [Pushing and Pulling to and from Docker Hub](https://ropenscilabs.github.io/r-docker-tutorial/04-Dockerhub.html)
- [초보를 위한 도커 안내서 - 설치하고 컨테이너 실행하기](https://subicura.com/2017/01/19/docker-guide-for-beginners-2.html)
- [초보를 위한 도커 안내서 - 이미지 만들고 배포하기](https://subicura.com/2017/02/10/docker-guide-for-beginners-create-image-and-deploy.html)
- [Dockerfile 작성부터 이미지 배포까지 간단 요약](https://adhrinae.github.io/posts/docker-101)
- [Docker Image Extraction](http://avilos.codes/infra-management/virtualization-platform/docker/docker-image-extraction-and-publish/)
- [Docker Hub – Docker 이미지를 Git 처럼 배포 할 수 있다고?](https://blog.minivet.kr/?p=175)
- [도커(Docker) 튜토리얼 : 깐 김에 배포까지](https://blog.nacyot.com/articles/2014-01-27-easy-deploy-with-docker/)
- [Dockerfile](https://gist.github.com/minhoryang/2a36fa760fa7a6cf9dce09d8c9ef532d)
