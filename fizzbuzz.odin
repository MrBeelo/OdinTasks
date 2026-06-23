#+feature dynamic-literals
package main
import "core:fmt"
import "core:strings"
import "core:slice"

// We do this because hash maps in odin are UNORDERED
get_word_map_order :: proc(word_map: map[int]string) -> []int {
	order: [dynamic]int
	for num in word_map do append(&order, num)
	slice.sort(order[:])
	return order[:]
} 

main :: proc() {
	NUMS :: 100
	word_map := map[int]string { 3 = "Fizz", 5 = "Buzz", 7 = "Bazz" }
	for i in 1..=NUMS {
		result: string
		for num in get_word_map_order(word_map) do if i % num == 0 do result = strings.concatenate({result, word_map[num]})
		if result == "" do result = string(fmt.ctprintf("%d", i))
		fmt.println(result)
	}
}