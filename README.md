# montgomery-inversion-corrections
Reference implementation and correctness verification for "Comments on Montgomery Inversion" - Journal of Cryptographic Engineering

# Corrections to Constant-Time Montgomery Inversion Algorithms

This repository provides the reference implementation and 
correctness verification for the paper:

> **"Comments on Montgomery Inversion"**  
> Animesh Prasad Singh, Soham Adhikary, Ayan Palchaudhuri  
> Department of ECE, IIT Bhubaneswar  
> Submitted to: Journal of Cryptographic Engineering

---

## Background

This work identifies and corrects two bugs in the 
constant-time Montgomery inversion algorithms proposed by:

> Savaş, E., Koç, Ç.K.: Montgomery inversion.  
> J Cryptogr Eng 8, 201–210 (2018).  
> https://doi.org/10.1007/s13389-017-0161-x

---

## Bugs Identified

### Bug 1: Algorithm 6 of [1] (our Algorithm 1)
The dummy branch `[~pi1 and pi8]` performs `r <- r - s`
which corrupts the already-correct value of `r` after
the bEEA terminates (`v = 0`).

**Fix:** Freeze `r` in the dummy branch (do not modify it).

### Bug 2: Algorithm 7 of [1] (our Algorithm 2)
The post-loop condition `(r > 0)` is always true since
`r` remains non-negative throughout execution (proved in
Section 5 of our paper). This causes incorrect post-loop
adjustment in all cases.

**Fix:** Change condition from `(r > 0)` to `(r < p)`.

---
