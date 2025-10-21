# w3_system 連携
まずはsystem連携の基本です．
'date|clip.exe'
って覚えてます？
これをpipeって言います．これ以外にもredirectがあります．
それの拡張です．振る舞いをoptionで調整する．

以下は来週のための準備です．
``` ruby
# send e-mail to nishitani@kwansei.ac.jp with your github id.
# you will receive the invitation
```
# w4_git clone
sshでremote loginが可能になるように設定します．
これは，system連携をhostをまたいで可能にすることを意味します．

``` ruby
# send e-mail to nishitani@kwansei.ac.jp with your github id.
# you will receive the invitation

ssh-keygen # return only!! no PassWord!!

cat ~/.ssh/id_ed25519.pub # then Copy&Paste

explorer.exe https://github.com/daddygongon # ssh key

# and copy multi_scale_25f path

git clone git@github.com:daddygongon/multi_scale_25f.git
```

# git pull and push

``` bash
ls tmp
ls multi_scale_25f/
cp -r tmp multi_scale_25f
cd multi_scale_25f/
mv tmp w2_mk_passwd
ls w2_mk_passwd/
auto_git
ls
git add -A
git config --global user.email "bob@surface_pro.com"
git config --global user.name "Shigeto R. Nishitani"
git commit
history
history -R
git config --global core.editor "code --wait"
git config pull.rebase true
code .
git pull origin main
```


ls
mkdir ~/bin
cp bin/auto_git ~/bin
printf '%s\n' $PATH
cat ~/.config/fish/config.fish
echo 'set PATH . ~/bin $PATH' >> ~/.config/fish/config.fish
fish
echo $PATH
which auto_git
```
