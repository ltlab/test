# Android Build for iMX

## Repo Init and Sync

```
repo init -u https://source.codeaurora.org/external/imx/imx-manifest.git -b imx-android-pie -m imx-p9.0.0_2.3.0.xml --no-clone-bundle 
repo sync --no-clone-bundle -j$(nproc --all)
```

## Build command

```
source build/envsetup.sh
lunch evk_8mm-userdebug

make -j$(nproc) 2>&1 | tee ./build-log.txt
```

### Build History

1. 1st time
```
make -j8 2>&1 | tee ~/build-log.txt
```
- 3.5 hours

2. 2nd: CCACHE 1st buildd
```
export USE_CCACHE=1
make -j12 2>&1 | tee ~/build-log.txt

```

> /tmp as tmpfs

- 4H 17Min
- CCACHE stats
```
cache directory                     /home/jay/.ccache
primary config                      /home/jay/.ccache/ccache.conf
secondary config      (readonly)    /etc/ccache.conf
stats zero time                     Sat Feb 15 10:45:36 2020
cache hit (direct)                  1276
cache hit (preprocessed)            1958
cache miss                         48305
cache hit rate                      6.27 %
called for link                     9230
called for preprocessing            1988
multiple source files                  9
unsupported source language         1316
unsupported compiler option            9
no input file                       2677
cleanups performed                     1
files in cache                    140833
cache size                          22.9 GB
max cache size                      30.0 GB
```

3. 3rd: CCACHE
```
export USE_CCACHE=1
make -j12 2>&1 | tee ~/build-log.txt

```

- 1H 7Min
- CCACHE stats
```
cache directory                     /home/jay/.ccache
primary config                      /home/jay/.ccache/ccache.conf
secondary config      (readonly)    /etc/ccache.conf
stats zero time                     Sat Feb 15 20:13:36 2020
cache hit (direct)                 45890
cache hit (preprocessed)            5576
cache miss                            73
cache hit rate                     99.86 %
called for link                     9230
called for preprocessing            1994
multiple source files                  9
unsupported source language         1316
unsupported compiler option            9
no input file                       2902
cleanups performed                     0
files in cache                    146686
cache size                          23.3 GB
max cache size                      30.0 GB
```

4. CCACHE + zRAM

- 1H 7Min

### Temporary

```
ckati

header-abi-dumper
header-abi-linker
clang-tidy.real
clang++.real
aapt2
cc1
javac
ninja

genksyms
llvm-ar
hldl-gen
secilc
soong_zip

versioner
C2 compilerThread

ld
ld.gold

dex2oatd
```
