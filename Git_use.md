- git remote -v  查看远程库
- git push origin master 向远程库提交master分支
- git add [文件]  添加文件
- git rm  -r [文件]  删除远程库的文件
- git commit -m "修改信息"  提交修改内容
- git remote -v  查看远程仓库地址
-  修改远程仓库地址
- git remote add origin  远程仓库地址
- git branch -d newBranch 删除本地分支
  git push origin --delete newBranch 删除远程分支
- git branch dev_name 创建分支
- git checkout dev_name 切换分支
-  git branch -a 查看远程分支(remotes开头的代表是远程分支)

查看历史提交版本：

1.git log 查看历史所有版本信息

2.git log -x 查看最新的x个版本信息

3.git log -x filename查看某个文件filename最新的x个版本信息（需要进入该文件所在目录）

4.git log --pretty=oneline查看历史所有版本信息，只包含版本号和记录描述

 

回滚版本：

1.git reset --hard HEAD^，回滚到上个版本

2.git reset --hard HEAD^~2，回滚到前两个版本

3.git reset --hard xxx(版本号或版本号前几位)，回滚到指定版本号，如果是版本号前几位，git会自动寻找匹配的版本号

4.git reset --hard xxx(版本号或版本号前几位) filename，回滚某个文件到指定版本号（需要进入该文件所在目录）



### 拉取分支代码时失败` fatal: refusing to merge unrelated histories`

git pull origin dongyy --allow-unrelated-histories

## 查看提交记录的版本号

git reflog

git reset --hard 版本号



## git拉取项目报错

OpenSSL SSL_read: Connection was reset, errno 10054

`git config --global http.sslVerify "false"`





## git拉取项目时排除拉取特定文件夹

要拉取远程仓库代码时不重写`.idea`文件夹的文件，可以使用`git sparse-checkout`功能来实现。`git sparse-checkout`允许你选择性地拉取仓库中的文件或文件夹。

以下是具体的步骤：

1. 首先，创建一个新的空白文件夹作为本地仓库目录。

2. 在命令行中进入该目录，并执行以下命令来初始化一个新的git仓库：

    ```
    git init
    ```

3. 然后，将远程仓库添加为远程源：

    ```
    git remote add origin <远程仓库URL>
    ```

4. 启用`sparse-checkout`功能：

    ```
    git config core.sparsecheckout true
    ```

5. 创建一个名为`.git/info/sparse-checkout`的文件，并在其中指定要拉取的文件或文件夹的路径。例如，如果你想拉取除了`.idea`文件夹之外的所有内容，可以在`.git/info/sparse-checkout`文件中添加以下内容：

    ```
    /*
    !.idea/
    ```

    这将拉取所有内容，但排除`.idea`文件夹。

6. 最后，执行拉取命令来获取远程仓库的代码：

    ```
    git pull origin master
    ```

    请确保将`origin`和`master`替换为你实际使用的远程源和分支名称。
