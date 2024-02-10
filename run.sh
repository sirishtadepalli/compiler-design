bison -d -v parser.y
mv parser.tab.c parser.c
cp parser.tab.h tokens.h
g++ -c parser.c
g++ -o compile scanner.o parser.o listing.o
#./compile <test10.txt
#./compile <test11.txt
