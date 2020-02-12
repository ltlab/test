# UIM in ubuntu

http://progtrend.blogspot.com/2018/06/ubuntu-1804-uim.html

``
sudo apt install uim

sudo apt remove uim
sudo apt autoremove
```

## UIM Settings
```
// 오른쪽 Alt키의 기본 키 맵핑을 제거하고 'Hangul'키로 맵핑
xmodmap -e 'remove mod1 = Alt_R'
xmodmap -e 'keycode 108 = Hangul'

// 오른쪽 Ctrl키의 기본 키 맵핑을 제거하고 'Hangul_Hanja'키로 맵핑
xmodmap -e 'remove control = Control_R'
xmodmap -e 'keycode 105 = Hangul_Hanja'

// 키 맵핑 저장
xmodmap -pke > ~/.Xmodmap
```
1. Input Method 실행( UIM )
2. Global settings => default input ==> `Byeoru`
3. `Byeoru key bindings`

4. `Region and Language` => `한글 키보드` 추가
