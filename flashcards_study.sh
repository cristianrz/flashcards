#!/bin/sh
while :; do
	sort -o flashcards flashcards

	line="$(head -n 1 flashcards)"

	epoch_fc="$(printf '%s' "$line" | cut -d',' -f 1)"
	epoch="$(date +%s)"
	question="$(printf '%s' "$line" | cut -d',' -f 2)"
	answer="$(printf '%s' "$line" | cut -d',' -f 3)"

	clear
	if [ -z "$epoch_fc" ] || [ "$epoch" -lt "$epoch_fc" ]; then
		date
		printf '\nCongratulations! You have finished for now.\n\n'
		echo Press ENTER to check again...
		read -r _
		continue
	fi

	printf '%s\n\n' "$question"

	echo Press ENTER to show answer && read -r _
	clear

	printf '%s\n\n' "$answer"

	echo '1) Again (<1m)'
	echo '2) Good (1d)'
	echo '3) Easy (4d)'

	read -r option

	case "$option" in
	1) epoch="$((epoch + 60))" ;;
	2) epoch="$((epoch + 3600 * 24))" ;;
	3) epoch="$((epoch + 4 * 3600 * 24))" ;;
	esac

	TMP="$(mktemp)"
	trap 'rm -f "$TMP"' EXIT

	cp flashcards "$TMP"

	{
		printf '%s,%s,%s\n' "$epoch" "$question" "$answer"
		tail -n +2 "$TMP"
	} >flashcards
done
