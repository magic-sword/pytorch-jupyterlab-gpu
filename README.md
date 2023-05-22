# pytorch-jupyterlab-gpu
Build the Docker environment required for AI development


# Reference

* [[1]](https://blog.shikoan.com/wsl2-ndivid-docker-pytorch/) Windows11でWSL2＋nvidia-dockerでPyTorchを動かすのがすごすぎた
* [[2]](https://qiita.com/radiol/items/48909d69ba8114edcbf2) Pytorch+JupyterLab+GPUをDockerで作成
* [[3]](https://amaya382.hatenablog.jp/entry/2017/04/03/034002)Docker Composeでビルド時に任意のイメージ名を指定する方法
* [[4]](https://qiita.com/suin/items/19d65e191b96a0079417)《滅びの呪文》Docker Composeで作ったコンテナ、イメージ、ボリューム、ネットワークを一括完全消去する便利コマンド

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

## 滅びの呪文
Docker Composeで作ったコンテナ、イメージ、ボリューム、ネットワークを一括完全消去する便利コマンド
.devcontainer フォルダ直下でコマンドを実行する
<pre>
docker-compose down --rmi all --volumes --remove-orphans
</pre>
