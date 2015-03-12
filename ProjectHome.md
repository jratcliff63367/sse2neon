This is an open source project that provides a single header file that translates a subset of the SSE intrinsics API to the corresponding equivalent versions for ARM NEON.

Some important notes.

**This header file does not convert the entire SSE API; only a subset of functions that I personally needed for a specific porting project I am working on.**

**If you want to add more support, please let me know, and I will add you as a contributor to this project.**

**This current (initial) version is not finished.  Some methods do not yet map from SSE to NEON; so instead a C implementation is stubbed in for those routines.  You can find the ones which do not map one to by by searching for 'TODO' in the header file.**

