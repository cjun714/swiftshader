# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -timeline -timeline-max-iterations=3 -iterations=1500 < %s | FileCheck %s

# perf stat reports a throughput of 1.51 IPC for this block of code.

# The SBB does not depend on the value of register EAX. That means, it doesn't
# have to wait for the IMUL to write-back on EAX. However, it still depends on
# the ADD for EFLAGS.

imul %edx, %eax
add %edx, %edx
sbb %eax, %eax

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      4500
# CHECK-NEXT: Total Cycles:      3007
# CHECK-NEXT: Dispatch Width:    2
# CHECK-NEXT: IPC:               1.50
# CHECK-NEXT: Block RThroughput: 2.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      3     1.00                        imull	%edx, %eax
# CHECK-NEXT:  1      1     0.50                        addl	%edx, %edx
# CHECK-NEXT:  1      1     1.00                        sbbl	%eax, %eax

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 2.00   2.00    -      -      -      -      -      -     1.00    -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     1.00    -      -      -      -      -     imull	%edx, %eax
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -      -      -      -      -      -      -     addl	%edx, %edx
# CHECK-NEXT: 2.00    -      -      -      -      -      -      -      -      -      -      -      -      -     sbbl	%eax, %eax

# CHECK:      Timeline view:
# CHECK-NEXT:                     01
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeER    ..   imull	%edx, %eax
# CHECK-NEXT: [0,1]     .DeE-R    ..   addl	%edx, %edx
# CHECK-NEXT: [0,2]     .D=eE-R   ..   sbbl	%eax, %eax
# CHECK-NEXT: [1,0]     . D==eeeER..   imull	%edx, %eax
# CHECK-NEXT: [1,1]     .  DeE---R..   addl	%edx, %edx
# CHECK-NEXT: [1,2]     .  D=eE---R.   sbbl	%eax, %eax
# CHECK-NEXT: [2,0]     .   D=eeeER.   imull	%edx, %eax
# CHECK-NEXT: [2,1]     .    D=eE--R   addl	%edx, %edx
# CHECK-NEXT: [2,2]     .    D==eE-R   sbbl	%eax, %eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     2.0    0.7    0.0       imull	%edx, %eax
# CHECK-NEXT: 1.     3     1.3    1.3    2.0       addl	%edx, %edx
# CHECK-NEXT: 2.     3     2.3    0.0    1.7       sbbl	%eax, %eax