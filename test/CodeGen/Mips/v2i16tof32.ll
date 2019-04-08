; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple mipsel--linux-android -mattr=+dsp -verify-machineinstrs | FileCheck %s

; Function below generates a v2i16 to f32 bitcast.
; Test that we are able to match it.

define float @f(<8 x i16>* %a) {
; CHECK-LABEL: f:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addiu $sp, $sp, -32
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    sw $fp, 28($sp) # 4-byte Folded Spill
; CHECK-NEXT:    .cfi_offset 30, -4
; CHECK-NEXT:    move $fp, $sp
; CHECK-NEXT:    .cfi_def_cfa_register 30
; CHECK-NEXT:    addiu $1, $zero, -16
; CHECK-NEXT:    and $sp, $sp, $1
; CHECK-NEXT:    lw $1, 8($4)
; CHECK-NEXT:    lw $2, 4($4)
; CHECK-NEXT:    lw $3, 12($4)
; CHECK-NEXT:    sw $3, 12($sp)
; CHECK-NEXT:    sw $1, 8($sp)
; CHECK-NEXT:    sw $2, 4($sp)
; CHECK-NEXT:    lw $1, 0($4)
; CHECK-NEXT:    sw $1, 0($sp)
; CHECK-NEXT:    mtc1 $1, $f0
; CHECK-NEXT:    move $sp, $fp
; CHECK-NEXT:    lw $fp, 28($sp) # 4-byte Folded Reload
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    addiu $sp, $sp, 32
; CHECK-NEXT:    .set at
; CHECK-NEXT:    .set macro
; CHECK-NEXT:    .set reorder
; CHECK-NEXT:    .end f
entry:
  %m = alloca <8 x i16>
  %0 = load <8 x i16>, <8 x i16>* %a
  store <8 x i16> %0, <8 x i16>* %m
  %1 = bitcast <8 x i16> %0 to <4 x float>
  %2 = shufflevector <4 x float> %1, <4 x float> undef, <8 x i32> <i32 0, i32 3, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
  %3 = shufflevector <8 x float> zeroinitializer, <8 x float> %2, <8 x i32> <i32 8, i32 9, i32 10, i32 11, i32 4, i32 5, i32 6, i32 7>
  %4 = bitcast <8 x float> %3 to <8 x i32>
  %5 = extractelement <8 x i32> %4, i32 0
  %6 = bitcast i32 %5 to float
  ret float %6
}

