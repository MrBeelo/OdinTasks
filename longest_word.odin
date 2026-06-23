package main

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
	data, err := os.read_entire_file("words.txt", context.allocator)
	if err != nil { fmt.printfln("Error!"); return }
	str := string(data)
	words := strings.split(str, "\n")
	filter_str := "gkmqvwxzio"
	
	// TASK 1: Finding a single longest word
	longest_word: string
	for word in words {
		if len(word) <= len(longest_word) do continue
		if strings.contains_any(word, filter_str) do continue
		longest_word = word
	}
	fmt.printfln("TASK 1: %s", longest_word)
	
	// TASK 2: Finding an array of the longest words
	longest_word_length: int
	longest_words: [dynamic]string
	for word in words {
		if len(word) < longest_word_length do continue
		if strings.contains_any(word, filter_str) do continue
		if len(word) > longest_word_length { clear(&longest_words); longest_word_length = len(word) }
		append(&longest_words, word)
	}
	fmt.printfln("TASK 2: %v", longest_words[:])
}