def get_all_k_meres(sample, k_mere_length)
	k_meres = Hash.new { |hash, key| hash[key] = 0 }
	(0..sample.length-k_mere_length).each do |sub_sample|
		k_meres[sample[sub_sample,k_mere_length]] = 1
	end
	return k_meres.keys
end

def get_k_mere_prob_score(k_mere, probs)
	score = 1.0
	k_mere.chars.each_with_index do |char, index|
		score *= probs[char][index]
	end
	return score
end

def get_k_mere_with_max_prob(dna, probs, k)
	best_k_mere = ""
	best_score = -9999999
	k_meres = get_all_k_meres(dna, k)
	k_meres.each do |k_mere|
		k_mere_score = get_k_mere_prob_score(k_mere, probs)
		if k_mere_score > best_score
			best_k_mere = k_mere
			best_score = k_mere_score
		end
	end
	return best_k_mere
end

def get_profile(motifs)
	motif_length = motifs[0].length
	profile = Hash.new { |hash, key| hash[key] = []}

	motif_length.times do |position|
		profile_hash = {"A" => 0.0, "C"=>0.0, "G"=>0.0, "T" => 0.0}
		motifs.each { |current_motif| profile_hash[current_motif[position]] += 1.0 }
		profile_hash.keys.each do |key|
			profile[key] << profile_hash[key]/motifs.length
		end
	end
	return profile
end

def get_score(motifs)
	score = 0
	motifs[0].length.times do |position|
		str = ""
		motifs.each do |motif|
			str += motif[position]
		end
		max_column_score = str.chars.group_by(&:chr).map { |_, v| v.size }.max
		score += max_column_score
	end
	return (motifs[0].length * motifs.length - score)
end

def greedy_motif_search(dnas, k)

	best_score = 999999999
	best_motifs = []

	first_dna_k_meres = get_all_k_meres(dnas[0],k)
	first_dna_k_meres.each do |first_dna_k_mere|
		motifs = [first_dna_k_mere]
		dnas[1..-1].each do |other_dna|
			profile = get_profile(motifs)
			motifs << get_k_mere_with_max_prob(other_dna, profile, k)
		end
		score = get_score(motifs)
		if score < best_score
			best_score = score
			best_motifs = motifs
		end
	end

	return best_motifs
end

dnas= [
"CCTTAGACATTTTGGGTTATTTCTCGTGTGTACTTAGCGCCTGGACTAAGAGCCGATTCTATGCACCCAATAATTAAACCCGGGAAGGACCCAGTCAGTTCAAACGCAAGTGTGTAAGTCCTTTGTATTCCGGCTGTAAGTGCCGTGTACGGCCTC",
"ATTTCAATCGCAACGTTTGTCGGTGAGATGTTGTTCGATCAGTTCCGGACATAAGGTACAATATGTATAGGGTTAAATTAAGCGTAAGTTCCTTCATCCACGTGGCGCATTGTGCCCAATGCCGACTTCCTGCGCAGACCGGTCGCTCTCTCGACG",
"CGACTCTACGACCCCGGCTCTGTAGCCCTGGACTGACCGGCTCGCGTTTGAGCCTAACATGATACGGGTCGAATCCAGCGACGCATCCCGTAGGAAGGTCCTCTGGCGGCTGCTGCGGAGAACTCCAGCGCAGAACGATGGAATCGCACTACTGTT",
"TCATCTTAGACGGTGTTTAATGTATTTAGGTCTAGGAGCTGTCCAGGAACATCCATCGCATTTAGGGTGGCGCATATCGATATAGCATTCGATAGGGAGACCACTGTACTCACCCACGGAACACCTCGCTGTTCCAACAGTATCTTGGCTCACGGC",
"TAGGGGAACTGCCCCACACGACGCCAAATGCGGAACTGCGTCTCTTCCGGATAAGGCTCTCTAAGACGTAAAAACCTGACACATATGTTATAAGCCACGTCCACCGCAGCGGCTCTCCTCTGGGGGCTCCAAACAGTATTTTGCTAGGGTCGCTTC",
"GACCTCACCGTAACTCATGGATCCGAGGAAGGGTCCTACTAGTTAGTTATTACTACGCGTGCGTGTGTCGCATGTAATCGACCCTTCATCTTTCGGTGGGAAGTGTACAAGTCGAGCGCACCCTGTGGGGCTCGATGCAGGGAGAGGCATCGCAGG",
"GGAACTATTACTCACTGTTTGGCCCCTAATCTAAGTTCTGGACTTGCGATGTTTATACCCTCGAGACGCATCAGCTCTACCGCACGCATTACAGCTGACGTGGAGTAACCGTGCCCAATCCCCTCCGAAGTTGGTATAACATCCTTCTGCTCCGAC",
"AGGCGACTGGTAGGCATACACTTACGTCAGTCCTTTCGTTTGGTCTGTAACTCCATCGCATCCGGATATCTGAACTCATTCTCCAGTCATCAGGGTAGCAGTGGCAGCCCGTCACAGGTTGCGTCGTATTTTATGCGGTCAGCTACCGCAAGTTGG",
"GAGGGCACGTGTACATTGAAGCCTCGGAACGTCCATATGGTCTTTCGATAGCGGACTACTCACCTCTGGTTAAGGTCCAGCGCACGATAGACGTCGTGGCACGAGTTCAATACATGAGCGCCTCGAACGACTAGGCCGAGGGCAGATCGGGGACCG",
"CGCGTGACGATTATAGCCATGAAGCTTCGTCGTGGCCTAGCCAGAGAAAGTTCTAACGCATGACGTCTCATTCAACGGAAGCACATGACCTTTCACCGGCAGTCTGCAATGCTAAGGTACCAGAACAACATCGCTGACTCTCCACCCTTGCCTACG",
"TCTACACATCGGAAGAAAGAAGTAAGCATGACGCATATGGGTGCTTCCTACAAACGGTGTCGGTTATAACGATGATTTCATAGGACATTACCTAGCCGTTCCCTTTCTGCGTAGAGGAACACGTCGACCGCAAAGTCTCTCTGGAAAGGTGAACAC",
"TATCCGAGGTAACGGGCCCAGCGACGCTTAAAAACCACGAAGAATCCAGAACAGGGATACATGTCGAACGCAATTGTGCGGCAATAATGGGGCTTCTACAGGATATTAGATGACGGATCACGAGCAGACCGGGCACTAGCTGGTAGTTCAGCGACG",
"TTGATTGCAGCGAACTCAAGCGCAGTCTAGTTGCGATGCCTGGGGTCCCCAGCGCTTATAACGCTAAGAGAAGTGAAGAACGTGTTGCGGCAATGCTCCGGTCTGGGAGTCAACGTACACGACCAGATTCAAGTCAATGGGGCTATAGTCTATACC",
"ATCTCAACCGCATTTTATTCACATTTTCAGGTCATCGGGTTCTCTCCTGACATCTACCCGACCGTATTGGTCTGTTATCCCCTGTTGCCAGACTTGAGTGGAATCGACATTTAAGGTACATGCTCGTAGAAGTTATACTTACAGGTTTTGTTAGCA",
"GTTGCCGCTGAAGGAACGGAGGGTTGGAGGAACGTGACACATGACCAATCAGGATGCAGAGGGAGTCCGGCATCGAATTTGCGCGTCTCCAAGCCTTCAGTTGAGTCTTACGACGTAAAAATATCGATCGCATGCTATCTACAGTAGAGGAAAATC",
"ATGTCTAGCGCAGGGTCAAGCTTCGAATCCGTGGGCGGGTGCGAAGTACTTAATCTACGATGGTAAAGGGATCTCTAATGTGGTCATTAGACGTCACCTTTGCGTTCCTAGGACTTATAGAACAGTTAACTGAGGGCACCAAGCCCACCCGGTTTG",
"ATTGTGAAGATATATTTATCTTGATATCTTCTTTAGGGCTCGACGATCCTGGAATCAAGGCTTGAACCATGGGTCTGGCGCTCGGATGCTGCACCTTCTGGCCTAGTACCCCTATAACCATACGCAATGATAATCTCCATCGCATTACTGCCGGAA",
"GCGAGCTGTAGTCGTAGTATCGGACATACACACACTACTCCCCGGGTGGGCGAATGCGAATATGGGGTGGTGTGACGTTTTCCCACCTCAAGCGCAAGTGTAAAAGCGATTTAAGAATCTCTCTCGTTGACAGCGCGCCTTCATTTAGAACTGCGG",
"GGTCTAAGAAGCGGCTATTTATCGGCCTCCTCTGAGTTGGGCGGTTCCTTCCGAACCATTGGTAATTAGCGAACCTAGTCTAAGCGGATGGCATTACGGCAATGTCGCTGGTGTAGGCGAAGCTCGAACGCATGCTTGAGAATCTGCGCCTGAGCT",
"CTGAGAAACATTTCGTGGTAAAAGCAGAAACTTAAGAACAGGTATGGTTATGCCGAGCTCACATCTAACGCATTATGAGTTATTGGCGCTATTGGACCGTGGAAAAGGCGAGCCAGTACGCGCATGCGTGTCTGTGCATGAACGCTGGAGCTCCCG",
"ATGGTGGCCCGATCCTTGGTTACGGTCAAGAGTACGGCACTGGGCTTTTCTGGCTCCTGTATATCAAGCGCACGGACCTGATATACGTCGACGCTGAACCGGCTCTACCACCACTGCGGCAAACCTCGTTAATTGGCTCCAACCGGTTAATAGGGC",
"GGTAAGGGCGGGTGCCCCATCGATTGAAGAGAATCGCGACCGGGGACATTGGGTGCCGAGGGCGCCTTCGGGTATCACCTTCTAAGATCAAGCGCAGACTAACTCGAGAAGGGAAATACCGAGTCCGGTGCTAGTATCCAAGGATGACACCAGGCG",
"CCCACGGTGTCTTAAGGCTACCGCCCATTACAACGATTATCAGGTAGAAAGTTCCCTAATGCTTGCGGTCCGATAAACCCCCCATAGCGGGTATAACAAACGGACCAACATCTAGTGTGTGAGTACGTATAGATATCTATCGCACTTCCCAGTGGC",
"ATATCAACCGCATGGGACCGACCATTTTTGTAAATGGCCAGGTCATAAAACATGATCGTAACACTGCGTGGCGTTCCGGAGTGAGTCATTGATGGGTCTAGCACGGAGCACGGTATGGTGGCAATGACCCAATCCAACGTTTAGGCCAATTTCGGG",
"CACTCGGTATAGCCGGATCACCTACCCCACATCCTCCCACTTGTCTATGGAAACTCCGCTTACCGCAAATCATCACGTGCTGACTCGTGCGCGCCCCGTTGGTAGGCGCCTGAGACTGCGGACACACGGGCAGCATTAAATCTAACATCAACCGCA"
]

puts greedy_motif_search(dnas,12)
