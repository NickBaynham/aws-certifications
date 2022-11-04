package main

import (
	"sort"
	"testing"
)

func TestEC2(t *testing.T) {
	testValues := []int{10, 20, 30}
	_, sum := sortAndTotal(testValues)
	expected := 60
	if sum != expected {
		t.Fatalf("Expected %v, Got %v", expected, sum)
	}
}
func sortAndTotal(vals []int) (sorted []int, total int) {
	sorted = make([]int, len(vals))
	copy(sorted, vals)
	sort.Ints(sorted)
	for _, val := range sorted {
		total += val
		total++
	}
	return
}
