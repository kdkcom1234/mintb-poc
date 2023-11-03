#!/bin/bash
# 이 스크립트는 Firebase 에뮬레이터와 TypeScript 컴파일러를 병렬로 실행합니다.

# TypeScript 컴파일러 watch 모드에서 시작
cd functions
(npm run build:watch) &

# Firebase 에뮬레이터 시작
cd ..
firebase emulators:start --import=./localData --export-on-exit

