#!/usr/bin/env python3

import numpy as np
import time

def run_np_norm(size,dtype):

    sizes = {'huge': 40000, 'large': 20000, 'small': 10000, 'tiny': 5000, 'test': 100}
    
    n = sizes[size]
    A = np.array(np.random.rand(n,n),dtype=dtype)
    B = np.array(np.random.rand(n,n),dtype=dtype)   

    start_time = time.time()
    the_norm = np.linalg.norm(A@B)
    run_time = time.time() - start_time
    
    ops = 2E-9 * (n**3 + n**2)
    gflops = ops/run_time
    
    return the_norm, run_time, gflops

def main():
    
    repeats = 3
    prob_size = 'small'
    dtype = np.float64

    for i in range(repeats):
        print("running numpy norm test")
        result, run_time, gflops = run_np_norm(prob_size,dtype)
        print(f'norm: {result:.2f}\t Run time: {run_time:.5f} seconds\t GFLOPS: {gflops:.0f}')

# --------------------------------------------------
if __name__ == '__main__':
    main()
