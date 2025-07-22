#!/usr/bin/env python
import struct
import random
import sys

"""
A simple utility that allows us to generate random datasets for the luceneutil.

Usage:
python random_luceneutil_vec_dataset.py /Users/jmazane/workspace/Opensearch/data/random_10k_768d_fp32.vec 10000 768

"""
def create_vec_file(filename, num_vectors, dimension):
    with open(filename, 'wb') as f:
        for i in range(num_vectors):
            # Generate random float32 values for each vector
            vector = [random.uniform(-1.0, 1.0) for _ in range(dimension)]

            # Write each float as 4 bytes (float32)
            for value in vector:
                f.write(struct.pack('<f', value))  # little-endian float32


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python create_vec.py <filename> <num_vectors> <dimension>")
        sys.exit(1)

    filename = sys.argv[1]
    num_vectors = int(sys.argv[2])
    dimension = int(sys.argv[3])

    create_vec_file(filename, num_vectors, dimension)
    print(f"Created {filename} with {num_vectors} vectors of dimension {dimension}")
