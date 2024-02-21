# Petrea Andrei 331CC
.PHONY: build run clean

build: tema

tema: tema.l
	flex -o lex.yy.cpp tema.l
	g++ lex.yy.cpp -o tema

run: tema
	@echo "Introduceti fisierul de intrare:"; \
	read INPUT; \
	export INPUT; \
	FILENAME=$$(basename $$INPUT .tex); \
	./tema $$INPUT > $$FILENAME.md; \

clean:
	rm -rf lex.yy.cpp tema *.md


