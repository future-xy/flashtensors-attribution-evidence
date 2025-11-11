# Evidence: flashtensors Attribution Issue

## Overview

This repository contains automated analysis and evidence regarding code attribution between [flashtensors](https://github.com/leoheuler/flashtensors) and [ServerlessLLM](https://github.com/ServerlessLLM/ServerlessLLM).

**Issue opened:** https://github.com/leoheuler/flashtensors/issues/4

**Status:** Awaiting response (5-day timeline starts from issue opening date)


## Quick Summary

Automated diff analysis shows that flashtensors' `csrc/` directory contains code derived from ServerlessLLM's `sllm_store/csrc/`, with Apache 2.0 license headers removed.



## Evidence Structure

### 1. Automated Diff Analysis
- **Main Script:** `clone_and_compare.sh` - Clones both repos and runs comparisons
- **Comparison Script:** `compare_dirs.sh` - Performs file-by-file diff analysis
- **Results:** Generated `*_diff_ignore_formatting.txt` files for each directory pair
- **Analysis Date:** 2025-11-11

### 2. Key Findings
- **32 files analyzed** across three core directories (csrc/checkpoint, csrc/store, proto)
- **All files show identical code** after ignoring whitespace/formatting
- **Primary difference:** Systematic removal of Apache 2.0 license headers from ServerlessLLM source files
- **storage.proto:** 100% identical (0 lines of difference)

### 3. Example: License Header Removal

**File:** `csrc/checkpoint/aligned_buffer.cpp`

ServerlessLLM version includes this Apache 2.0 header:
```cpp
// ----------------------------------------------------------------------------
//  ServerlessLLM
//  Copyright (c) ServerlessLLM Team 2024
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   ...
//   limitations under the License.
// ----------------------------------------------------------------------------
#include "aligned_buffer.h"
```

flashtensors version has the header removed:
```cpp
#include "aligned_buffer.h"
```

**The rest of the code is identical.** This pattern repeats across all 31 C++ source files in `csrc/`.



## Methodology

All analysis was conducted using publicly available code:
- **flashtensors:** Commit `168d77568c89e302b077ab3357d7dd13d44fac92`
- **ServerlessLLM:** Commit `097f4591ed3b12dc07dd198602cb20eacc2e58b6`
- **Tools used:** `diff` with flags `-uwB` (unified format, ignore whitespace, ignore blank lines)
- **Comparison approach:**
  - Three directory pairs analyzed:
    1. `sllm_store/csrc/checkpoint` ↔ `csrc/checkpoint` (8 files)
    2. `sllm_store/csrc/sllm_store` ↔ `csrc/store` (23 files)
    3. `sllm_store/proto` ↔ `flashtensors/proto` (1 file)

All scripts are provided for independent verification. Run `./clone_and_compare.sh` to reproduce the analysis.


## Timeline

- **2025-11-10:** Issue discovered
- **2025-11-11:** Issue opened with flashtensors (see link above)
- **2025-11-11:** Evidence repository created with automated analysis
- **2025-11-16:** Response deadline (5 days from issue opening)


## Our Position

We welcome reuse of ServerlessLLM under Apache 2.0. We only request:
1. Preserve original copyright notices (§4(c))
2. Add modification notices (§4(b))
3. Include prominent attribution

Open source thrives on proper attribution. We hope to resolve this cooperatively.


## Contact

For questions: [y.fu@ed.ac.uk](mailto:y.fu@ed.ac.uk)

**Note:** Additional evidence may be added as the situation develops.
