# pytorch-jupyterlab-gpu
Build the Docker environment required for AI development


# Reference

* [[1]](https://blog.shikoan.com/wsl2-ndivid-docker-pytorch/) Windows11でWSL2＋nvidia-dockerでPyTorchを動かすのがすごすぎた
* [[2]](https://qiita.com/radiol/items/48909d69ba8114edcbf2) Pytorch+JupyterLab+GPUをDockerで作成
* [[3]](https://amaya382.hatenablog.jp/entry/2017/04/03/034002)Docker Composeでビルド時に任意のイメージ名を指定する方法
* [[4]](https://qiita.com/suin/items/19d65e191b96a0079417)《滅びの呪文》Docker Composeで作ったコンテナ、イメージ、ボリューム、ネットワークを一括完全消去する便利コマンド
* [[5]](https://take-tech-engineer.com/python-tqdm-progressbar-pyprind/#toc2)【Python】プログレスバーで進捗を確認するtqdm、progressbar2、PyPrindの使い方
* [[6]](https://www.kagoya.jp/howto/cloud/container/dockerhub/) 【入門】Docker Hubとは？概要と仕組み、基本的な使い方を解説
* [[7]](https://qiita.com/simonritchie/items/49e0813508cad4876b5a) [Python]可読性を上げるための、docstringの書き方を学ぶ（NumPyスタイル）
* [[8]](https://jupyter-contrib-nbextensions.readthedocs.io/en/latest/install.html) Installing jupyter_contrib_nbextensions
* [[9]](https://qiita.com/gorogoroyasu/items/e71dd3c076af145c9b44) Docker 上で Pytorch を実行している際に DataLoader worker (pid xxx) is killed by signal: Bus error. というエラーが出る

## 目標
Windows11に標準装備されたWSL2を使って、Linux環境からGPU利用ありのPyTorchを動かす

# Protocol

## Install

### WSL2
スタートメニューから、「Windows PowerShell」もしくは「コマンドプロンプト」を開き、
<pre>
wsl.exe --install
wsl.exe --update
wsl.exe
</pre>

以後は、Windowsのコマンドプロンプトで操作するものと、
WLS上のコマンドプロンプトで操作するもの($)がある

[Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701?hl=ja-jp&gl=jp&rtc=1)は、コマンドプロンプトの端末をタブ切り替えなどできるので、インストールして使うのがオススメ

### nvidia-docker2

Dockerをインストールする

Windowsなら　Docker Descktopが使える
WLSの端末で、以下のコマンドを入力して、Dokcerがインストールされていることを確認する

<pre>
docker version
......
</pre>

また、以下のコマンドでnvidia-docker2をインストールする
<pre>
sudo apt-get update
sudo apt-get install -y nvidia-docker2
</pre>

インストール後、別のWSLの端末で、Dockerデーモンを再起動する
<pre>
sudo service docker stop
sudo service docker start
</pre>


### PyTorch Image
PyTorchのDokcerイメージをインストールする

[NVIDIA PyTorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch)
ページの「Latest Tag」を参考に、最新のバージョンを確認する

以下のコマンドを実行すると、インストールから起動までが自動で行われる
「pytorch:XX.XX-py3」は、確認した最新バージョンに置き換える
<pre>
docker run --gpus all -it --rm --shm-size=8g nvcr.io/nvidia/pytorch:XX.XX-py3
</pre>

インストール完了後、実行されているpytorch環境上で以下を入力すると、GPUが認識されているのがわかる
<pre>
nvidia-smi
</pre>


### VS Code
素晴らしいエディタなのでインストールしておく

以下のプラグインをインストールして使うと、Docker上のコンテナにVS Codeから接続できる
[Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

Remote Developmentのプラグインにより、このディレクトリを開いているVScodeから、Dockerコンテナを構築して起動できる
ディレクトリトップにある「.devcontainer」フォルダを認識し、その中の`devcontainer.json`に記載された情報に接続する


# Build

WSL上のターミナルで.devcontainerフォルダ直下にアクセスし、以下のコマンドを実行する
<pre>
docker-compose up
</pre>

このコマンドにより、Docker Composeの機能でdocker-compose.ymlに記載されている情報を読み取り、Dockerイメージのビルドとコンテナの実行を自動的に行う

以下のコマンドを実行して、イメージをビルドしなおす
<pre>
docker-compose build --no-cache app
</pre>

## 滅びの呪文
Docker Composeで作ったコンテナ、イメージ、ボリューム、ネットワークを一括完全消去する便利コマンド
.devcontainer フォルダ直下でコマンドを実行する
<pre>
docker-compose down --rmi all --volumes --remove-orphans
</pre>


# Jupyter
Dockerコンテナを起動したら、コンテナ内の端末にアクセスする

以下のコマンドを実行して、Jupyterを起動する
<pre>
jupyter notebook
</pre>

以下のURLへアクセスして、起動したjupyter notebookへアクセスする
http://localhost:8888 

## nbextentions
nbextentionsは、jupyterでコード補完をしてくれる拡張機能
コードの入力途中でTABキーを押下すると、入力候補を表示してくれる。

さらに、nbextentionsにある「hinterland」機能を有効化すると、[Shift+TAB]でdocstringも表示してくれる。
[Shift+TAB]キーを何度も繰り返し押下すると、docstringを表示するレイアウトが変化してさらに見やすくなる。
開発する際に非常に便利。

# Tips

## 共有メモリ

Dockerコンテナ上でAIの学習を実行していると、以下のようなエラーが発生することがある
<pre>
ERROR: Unexpected bus error encountered in worker. This might be caused by insufficient shared memory (shm).
</pre>

原因は、共有メモリの容量不足エラーである。
環境上の共有メモリの容量は、以下のコマンドを実行して確認できる
<pre>
df -h
</pre>
|Filesystem | Size  | Used  | Avail | Use%  | Mounted on |
| :---:     | :---: | :---: | :---: | :---: | :---:      |
|  shm      |  64M  | 0     | 64M   |	0%  | /dev/shm   |

Filesystem名が「shm」のものが共有メモリのとなる。
デフォルトのDockerでは、64MBしか確保されていない。
そのため、AIの学習実行時にメモリ不足エラーが発生することがある。

docker-compose.ymlのサービスに、「shm_size」を指定することで、
docker-compose run実行時の共有メモリ容量を指定することができる。
