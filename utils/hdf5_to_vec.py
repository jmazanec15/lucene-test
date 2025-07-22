#!/usr/bin/env python
import h5py
import struct
import sys

def write_vec_file(filename, vectors):
    """Write vectors to .vec file format (raw float32 binary)"""
    with open(filename, 'wb') as f:
        for vector in vectors:
            for value in vector:
                f.write(struct.pack('<f', float(value)))  # little-endian float32

def write_nn_file(filename, neighbors):
    """Write neighbors to .nn file format (assuming int32)"""
    with open(filename, 'wb') as f:
        for neighbor_list in neighbors:
            for neighbor in neighbor_list:
                f.write(struct.pack('<i', int(neighbor)))  # little-endian int32

def convert_hdf5_to_vec(hdf5_file, output_prefix):
    """Convert HDF5 file with train/test/neighbors datasets to .vec/.nn files"""
    with h5py.File(hdf5_file, 'r') as f:
        # Convert train dataset
        if 'train' in f:
            train_data = f['train'][:]
            write_vec_file(f"{output_prefix}_train.vec", train_data)
            print(f"Created {output_prefix}_train.vec with {len(train_data)} vectors")
        
        # Convert test dataset
        if 'test' in f:
            test_data = f['test'][:]
            write_vec_file(f"{output_prefix}_test.vec", test_data)
            print(f"Created {output_prefix}_test.vec with {len(test_data)} vectors")
        
        # Convert neighbors dataset
        if 'neighbors' in f:
            neighbors_data = f['neighbors'][:]
            write_nn_file(f"{output_prefix}_neighbors.nn", neighbors_data)
            print(f"Created {output_prefix}_neighbors.nn with {len(neighbors_data)} neighbor lists")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python hdf5_to_vec.py <hdf5_file> <output_prefix>")
        print("Example: python hdf5_to_vec.py dataset.hdf5 output")
        print("This will create output_train.vec, output_test.vec, and output_neighbors.nn")
        sys.exit(1)
    
    hdf5_file = sys.argv[1]
    output_prefix = sys.argv[2]
    
    convert_hdf5_to_vec(hdf5_file, output_prefix)