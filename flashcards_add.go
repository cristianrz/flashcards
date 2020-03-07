package main

import (
	"strings"
	"bufio"
	. "fmt"
	"log"
	"os"
	"os/exec"
	"time"
)

func main() {
	for {
		c := exec.Command("clear")
		c.Stdout = os.Stdout
		c.Run()
		Println("Front")

		reader := bufio.NewReader(os.Stdin)
		front, _ := reader.ReadString('\n')
		front = strings.TrimSuffix(front, "\n")

		Printf("\nBack\n")

		reader = bufio.NewReader(os.Stdin)
		back, _ := reader.ReadString('\n')
		back = strings.TrimSuffix(back, "\n")

		epoch := time.Now().Unix()

		towrite := Sprintf("%v,%s,%s\n", epoch, front, back)

		Println(towrite)

		f, err := os.OpenFile("flashcards.csv",
			os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)

		if err != nil {
			os.Exit(1)
		}

		defer f.Close()
		if _, err := f.WriteString(towrite); err != nil {
			log.Println(err)
		}
	}
}
