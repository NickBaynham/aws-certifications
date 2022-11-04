package main

import "testing"

func Test_listEC2Instances(t *testing.T) {
	type args struct {
		ec2 *EC2
	}
	var tests []struct {
		name string
		args args
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			listEC2Instances(tt.args.ec2)
		})
	}
}
