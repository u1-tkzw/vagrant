# vagrant
LAMP 環境構築用の vagrantfile。

### 使い方
1. config.vm.synced_folder をコメントアウト
2. config.vm.provision のコメントアウトを解除
3. vagrant up
4. config.vm.provision をコメントアウト
5. config.vm.synced_folder のコメントアウトを解除
6. vagrant reload

### Todo:
- php.ini の mbstring のコメントアウトを外すように provision をいじるか検討。
