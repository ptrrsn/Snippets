/*
 * Copyright 2022 Google LLC.
 * SPDX-License-Identifier: Apache-2.0
 */

{
    \\ Loop through all possible indices with certain weight, sorted by depth.
    \\ For example, to print the bitmasks in binary notations:
    \\ brute_force_by_depth(5, (bitmask)->print(binary(bitmask)))
    \\ As another example, to count the number of bitmasks generated (for sanity
    \\ check):
    \\ count = 0; brute_force_by_depth(15, (bitmask)->count++); print(count)
    brute_force_by_depth(weight, func) =
        for (number_of_ones = 1, weight,
            bitmask = (1 << (weight - 1)) + (1 << (number_of_ones - 1)) - 1;
            until (bitmask > ((1 << number_of_ones) - 1) << (weight - number_of_ones),
                func(bitmask);
 
                \\ We will find the smallest number whose binary representation
                \\ contains exactly number_of_ones 1 bits and greater than
                \\ bitmask. We will call it the "next bitmask".

                \\ Get the right-most bit 1 from bitmask. For example, if the
                \\ original bitmask is 100111100, last_one will be 000000100.
                last_one = bitand(bitmask, bitneg(bitmask - 1));

                \\ Get the last group of 1s from bitmask. For example, if the
                \\ original bitmask is 100111100 (as above), last_group_of_ones
                \\ will be 000111100.
                last_group_of_ones = bitand(bitmask, bitneg(bitmask + last_one));

                \\ Consider the case 100111100 above. The next bitmask can be
                \\ constructed by splitting the last_group_of_ones so that we
                \\ shift the left most 1 of the last_group_of_ones and shift
                \\ the rest to the right most bits: 10100111.
                \\ Another example, 101100011100. Then, we will split the group
                \\ of 111 to be: 101100100011.

                \\ First, replace the last_group_of_ones with bit 1 right to
                \\ the left of the group.
                \\ For example, 101100011100 becomes 101100100000.
                bitmask = bitmask + last_one;

                \\ Then we add the remaining of the last_group_of_ones to the
                \\ right-most bits. Notes that this trick below will also work
                \\ even if last_group_of_ones contains only one bit of 1.
                bitmask = bitmask + ((last_group_of_ones / last_one) >> 1);
                
                \\ Here, bitmask is the next bitmask.
            )
        )
}