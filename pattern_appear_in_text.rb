#ba1a

def count_appearence(text,pattern)
	return 0 if text.empty?
	count = text.start_with?(pattern) ? 1 : 0
	return count + count_appearence(text[1..-1],pattern)

end

puts count_appearence("GCCTCAATGGTTAAGGCCTCAACGCCTCAATTGCCTCAATCGCCTCAAAGCCTCAAAAGCCTCAAATGCCTCAAGCGGCCTCAAACGGCCTCAACGCCTCAAGACCGGGCCTCAAAGCCTCAAGCGCCTCAAGTGCGGACGGGGAAAATAAAGGCCTCAACCCGCTTGCCTCAAGCCTCAAGCCTCAACCCTGCCTCAATGTGAGGCCTCAAACCAAGTGCGTGGGCCTCAAAGGGCCTCAATGCCTCAAAGCCTCAACGCCTCAAGCCTCAAGCCTCAATGCCTCAAGAGGCCTCAAGCTGTGGATGATAGAGTCGTCCGCCTCAAGCCTCAACTGCAGCCTCAAAGCCTCAAGCCTCAAGCCTCAACGCCTCAAGCCTCAATGCCTCAACAGCCTCAAAGGCCTCAAGGGCCTCAACTTAGCCTCAAGCTCAAAGCCTCAAGCCTCAAAGCCTCAATACAGCCTCAAGCCTCAAGGCCTCAACCGTGCCTCAAGGCCTCAAGCCTCAAGAAGGAAAGAGCCTCAAGCCTCAAGCCTCAATGCCTCAAGCCTCAATCCGCCTCAATAGCCTCAAGATGATGCCTCAAGCTGGTTGAGCGTGGCCTCAAGGGCCTCAAACTCAGCCTCAACCCGCCTCAACTACGCCTCAAATTCGCCTCAAAGCCTCAAGCCTCAAGCCTCAACGCCTCAAGCCTCAAGCCTCAAGCACGCCTCAAACCTACGCCTCAACCGGGCCTCAAGCCTCAAGCTAAGCCTCAAGAGATGGCCTCAAGCCTCAAAAAGCCTCAAGGCCTCAAGCCTCAAATAGATGCCTCAAGCCTCAACGACTGCCTCAAGCCTCAAGGGCCTCAATTTGTACGCCTCAACGCCTCAAGCCTCAAGCCTCAAAGAAAGCCTCAAGCCTCAAAGGTCTTGCCTCAATGCGTGGACTCGCCTCAAGCCTCAA","GCCTCAAGC")