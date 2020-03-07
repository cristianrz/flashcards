all: flashcards_add flashcards_study

install:
	mv flashcards_add flashcards_study ${HOME}/bin

flashcards_add: flashcards_add.go
	go build flashcards_add.go
