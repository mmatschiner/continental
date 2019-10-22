# m_matschiner Mon Nov 12 10:06:55 CET 2018

# Get the command-line arguments.
infasta_file_name = ARGV[0]
problematic_ids_list_file_name = ARGV[1]
outfasta_file_name = ARGV[2]

# Read the list of problematic sequence ids.
problematic_ids_list_file = File.open(problematic_ids_list_file_name)
problematic_ids_lines = problematic_ids_list_file.readlines
problematic_ids = []
problematic_ids_lines.each {|l| problematic_ids << l.strip}

# Read the input fasta file.
infasta_file = File.open(infasta_file_name)
infasta_lines = infasta_file.readlines
ids = []
seqs = []
infasta_lines.each do |l|
	if l[0] == ">"
		ids << l[1..-1].strip
		seqs << ""
	elsif l.strip != ""
		seqs.last << l.strip
	end
end

# Prepare the output fasta string.
outfasta_string = ""
ids.size.times do |x|
	seq_problematic = false
	problematic_ids.each do |i|
		seq_problematic = true if ids[x].match(/#{i}/)
	end
	unless seq_problematic
		outfasta_string << ">#{ids[x]}\n#{seqs[x]}\n"
	end
end

# Write the output fasta file.
outfasta_file = File.open(outfasta_file_name, "w")
outfasta_file.write(outfasta_string)