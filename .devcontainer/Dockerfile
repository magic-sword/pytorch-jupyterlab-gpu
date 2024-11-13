# Python3.9以上で利用するため、nvidia/cudaから利用
FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

# sudoを利用できるようにする
RUN apt-get update
RUN apt-get install sudo

# root以外のユーザを追加し、sudoをパスワードなしで実行可能にする
ARG USERNAME=dev
ARG GROUPNAME=dev
ARG UID=1000
ARG GID=1000
ARG PASSWORD=user
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME

# software-properties-commonなどをインストール時にタイムゾーンを聞かれて停止するため、タイムゾーンをインストールしておく
# sudoでroot権限へ昇格するときに環境変数が引き継がれないので、sudoに-Eオプションを入れる
RUN DEBIAN_FRONTEND=noninteractive sudo -E apt install -y tzdata

# root権限となってしまっているフォルダとファイルの権限を、再帰的に全て変更するコマンド
# sudo chown -R dev:dev [filename/foldername]

# Python 3.12をインストール
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository -y ppa:deadsnakes/ppa
RUN sudo apt-get install -y python3.12 
RUN sudo apt-get install -y curl
RUN curl -sSL https://bootstrap.pypa.io/get-pip.py | python3.12
ENV PATH $PATH:/home/dev/.local/lib/python3.12/site-packages
RUN python3.12 -m pip install --upgrade pip

# # Pytorchインストール(CUDA 12.1)
RUN python3.12 -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# === JupyterLab ===
RUN python3.12 -m pip install \
    ipywidgets \
    jupyterlab \
    matplotlib \
    nodejs \
    opencv-python \
    pandas \
    scikit-learn \
    seaborn \
    sympy \
    tqdm

# jupyter_notebookの設定ファイルをコピー
# COPY .devcontainer/jupyter_notebook_config.py /root/.jupyter/

# 起動時のスクリプトをコピー
COPY --chmod=+x .devcontainer/start_up.sh /usr/local/bin/

# コンテナ起動時にjupyter_notebookを起動
CMD ["/usr/local/bin/start_up.sh"]