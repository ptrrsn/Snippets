/*
 * Multiple Zeta Value Library - Function(s) related to Multiple Zeta Value.
 * Written in 2022 by Risan ptrrsn.1@gmail.com
 * To the extent possible under law, the author(s) have dedicated all copyright and related
 * and neighboring rights to this software to the public domain worldwide. This software is
 * distributed without any warranty.
 * You should have received a copy of the CC0 Public Domain Dedication along with this
 * software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

\\ Loop through all possible indices with certain weight, sorted by depth.
\\ For example, to print the bitmasks in binary notations:
\\ weight = 5;
\\ for (depth = 1, weight, for_each(weight, depth, (bitmask)->print(binary(bitmask))))
\\ As another example, to count the number of bitmasks generated (for sanity
\\ check):
\\ weight = 15; count = 0;
\\ for (depth = 1, weight, for_each(weight, depth, (bitmask)->count++));
\\ print(count)
    
{
    for_each(weight, depth, func) =
        number_of_ones = depth;
        \\ The variable bitmask is initialized with the smallest possible number
        \\ that has number_of_ones bits of 1s in the binary representation.
        bitmask = (1 << (weight - 1)) + (1 << (number_of_ones - 1)) - 1;

        \\ Loop until bitmask is greater than the biggest possible number that has
        \\ number_of_ones bits of 1s in the binary representation.
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
            \\ shift the left most 1 of the last_group_of_ones one bit to the
            \\ left and shift the rest to the right most bits: 10100111.
            \\ Another example, 101100011100. Then, we will split the group
            \\ of 111 to be: 101100100011.

            \\ First, replace the last_group_of_ones with bit 1 right to
            \\ the left of the group.
            \\ For example, 101100011100 becomes 101100100000.
            bitmask = bitmask + last_one;

            \\ Finally, we add the remaining of the last_group_of_ones to
            \\ right-most bits. Notes that the trick below will also work
            \\ even when last_group_of_ones contains only one bit of 1.
            \\ For example, the previous line will change 101100011100
            \\ to 101100100000. This line now will add the remaining bits
            \\ to be 101100100011.
            \\ Here, bitmask is now the next bitmask of the original one.
            bitmask = bitmask + ((last_group_of_ones / last_one) >> 1)
        )
}

\\ MZV basis calculation based on Prof. Tasaka's implementation in the slide
\\ http://www.ist.aichi-pu.ac.jp/~tasaka/CoMZ_beamer_tasaka.pdf
{
    MZV_basis(weight) =
        basis_in_real_with_sentinel = [Pi];
        basis = [];
        for (depth = 1, weight, for_each(weight, depth,
            (bitmask)->
                remaining_bits = weight;
                previous = -1;
                index = [];
                for (i = 0, weight,
                    if (bitand(bitmask, 1 << i) > 0,
                        index = concat(index, i - previous);
                        remaining_bits -= (i - previous);
                        previous = i
                    )
                );
                if (index[1] >= 2,
                    concattenated_basis_in_real_with_sentinel = concat(basis_in_real_with_sentinel, zetamult(index));
                    if (lindep(concattenated_basis_in_real_with_sentinel)[1] != 0,
                        basis_in_real_with_sentinel = concattenated_basis_in_real_with_sentinel;
                        basis = concat(basis, [index]))
                )
        ));
        basis;
}
MZV_basis(5)
