#+feature dynamic-literals
package main

import "core:math"
import "core:fmt"
import "core:slice"
import "core:strings"

MAX_DIGITS :: 100
example_digits := [?]int{2, 17, -1, -7964, 63749}
neodigits := map[int]string {
	0 = "0",
	-109 = "S",
	22 = "ℤ",
	13 = "B",
	4 = "4",
	5 = "5",
	86 = "W",
	-3013 = "𝅘𝅥𝅱♪",
	88 = "C",
	-1 = "L"
}

main :: proc() {
	neo_keys, _ := slice.map_keys(neodigits)
	if is_plentiful(neo_keys) {
		fmt.printfln("Examples:")
		for digit in example_digits do fmt.printfln("%d -> %v", digit, normal_to_neostring(digit, neodigits))
	}
}

// General function for if a set is plentiful.
is_plentiful :: proc(digits: []int) -> bool {
	if len(digits) != 10 { fmt.printfln("Set is not plentiful, as it doesn't have exactly 10 digits.") 
		return false 
	}
	
	digit_array := slice_to_array(digits, 10)
 	if !one_digit_per_lumn(digit_array) { 
  		fmt.printfln("Set is not plentiful, as there are duplicate or no digits on some lumns.")
    	return false 
  	}
  
  	number_check := get_biggest_needed_number_check(digits)
   	for i in -number_check..=number_check do if slice.equal(normal_to_neonumber(i, digit_array), []int{}) { 
    	fmt.printfln("Set is not plentiful, as the number %d cannot be made.", i)
     	return false 
    }
    
    fmt.printfln("Set is plentiful!")
    return true
}

// Turns a neonumber to a normal number.
neonumber_to_normal :: proc(digits: []int) -> int {
	result: int
	#reverse for digit, i in digits { 
		index := uint(len(digits) - 1 - uint(i))
		result += digit * pow(10, index)
	}
	
	return result
}

// Gets the column that belongs to any number. (0 -> 9)
get_last_digit_lumn :: proc(x: int) -> int { return x % 10 + (10 if x < 0 else 0) }

// Given a "last" digit (0 -> 9), returns it's corresponding neodigit lumn. (e.g. 2 -> Z, 9 -> L)
get_neodigit_from_last_digit :: proc(last_digit: int, available_digits: [10]int) -> int {
	if !one_digit_per_lumn(available_digits) do return 0
	for digit in available_digits do if last_digit == get_last_digit_lumn(digit) do return digit
	return 0
}

// Gets the last neodigit of a normal number.
get_last_neodigit_from_digit :: proc(x: int, available_digits: [10]int) -> int {
	return get_neodigit_from_last_digit(get_last_digit_lumn(x), available_digits)
}

// Checks if there is exactly one digit per lumn.
one_digit_per_lumn :: proc(digits: [10]int) -> bool {
	result := make([]int, 10)
	for digit, index in digits do result[index] = get_last_digit_lumn(digit)
	slice.sort(result)
	if slice.equal(result, []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}) do return true
	return false
}

// Turns a normal number into a neonumber.
normal_to_neonumber :: proc(x: int, available_digits: [10]int) -> []int {
	if !one_digit_per_lumn(available_digits) do return {}
	
	if x == 0 {
		exists: bool
		for digit in available_digits do if digit == 0 do exists = true
		return []int{0} if exists else {}
	}
	
	result: [dynamic]int
	left_x := x
	count: int
	for left_x != 0 {
		last_neodigit := get_last_neodigit_from_digit(left_x, available_digits)
		append(&result, last_neodigit)
		left_x -= last_neodigit
		left_x /= 10
		
		count += 1
		if count > MAX_DIGITS do return {}
	}
	
	result_slice := result[:]
	slice.reverse(result_slice)
	return result_slice
}

// Gets the biggest integer needed to be checked so that a set is plentiful. (|e| / 9)
get_biggest_needed_number_check :: proc(available_digits: []int) -> int {
	abs_available_digits := make([]int, len(available_digits))
	for digit, index in available_digits do abs_available_digits[index] = math.abs(digit)
	biggest_abs_digit := slice.max(abs_available_digits)
	return int(math.floor(f32(biggest_abs_digit) / 9))
}

// Gets a neonumber (array of neodigits) and returns a string with the number's string form.
neonumber_to_neostring :: proc(number: []int, available_digits: map[int]string) -> string {
	str: string
	for digit in number do str = strings.concatenate({str, available_digits[digit]})
	return str
}

// Ditto, but takes a normal number instead of a neonumber.
normal_to_neostring :: proc(x: int, available_digits: map[int]string) -> string {
	neo_keys, _ := slice.map_keys(neodigits)
	if len(neo_keys) != 10 do return ""
	neo_key_arr := slice_to_array(neo_keys, 10)
	return neonumber_to_neostring(normal_to_neonumber(x, neo_key_arr), neodigits)
}

// HELPER FUNCTIONS

slice_to_array :: proc(slice: []int, $len: int) -> [len]int {
	array: [len]int
	for x, index in slice do array[index] = x
	return array
}

pow :: proc(x: int, power: uint) -> int {
	if x == 0 do return 1
	if x == 1 do return x
	result := x
	for i in 1..<power do result *= x
	return result
}