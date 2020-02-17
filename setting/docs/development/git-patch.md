
```
git diff > test.patch
git diff --no-prefix > test.patch
git diff 291ef0 1b530d --no-prefix > test.patch
```
- `--no-prefix`로 생성된 patch file의 경우에는 `-p0` 옵션을, 그렇지 않은 경우에는 `-p1` 옵션을 준다.
```
patch -p0 --dry-run < test.patch
patch -p0 < test.patch
```
