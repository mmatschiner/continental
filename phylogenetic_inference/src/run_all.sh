# m_matschiner Fri Nov 16 10:36:49 CET 2018

# Copy the alignments from the the ortholog_identification directory.
bash get_alignments.sh

# Copy the trees from the the ortholog_identification directory.
bash get_trees.sh

# Make simple newick versions of all sets of gene trees and mcc tree sets.
bash simplify_trees.sh

# Run astral for both the strict and permissive set of gene trees.
bash run_astral.sh

# Group gene alignments according to rate, base frequencies, substitution model, and alpha parameter of the gamma model, using partitionfinder.
bash run_partitionfinder.sh

# Generate maximum-likelihood phylogenies for each partition.
bash run_iqtree.sh

# Prepare unconstrained beast analyses.
bash prepare_unconstrained_beast_analyses.sh

# Run unconstrained beast analyses.
bash run_unconstrained_beast_analyses.sh

# Combine the posterior distriutions of the unconstrained beast analyses.
bash combine_unconstrained_beast_analyses.sh

# Prepare constrained beast analyses.
bash prepare_constrained_beast_analyses.sh

# Run constrained beast analyses.
bash run_constrained_beast_analyses.sh

# Combine the posterior distriutions of the constrained beast analyses.
bash combine_constrained_beast_analyses.sh
