# 元にするnvidiaのpytorch  バージョンは最新のものを確認
FROM nvcr.io/nvidia/pytorch:23.04-py3

# sudoを利用できるようにする
RUN apt update
RUN apt install sudo

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
# RUN DEBIAN_FRONTEND=noninteractive sudo -E apt install -y tzdata

# root権限となってしまっているフォルダとファイルの権限を、再帰的に全て変更するコマンド
# sudo chown -R dev:dev [filename/foldername]


# === JupyterLab ===
RUN python -m pip install --upgrade pip
RUN python -m pip install \
    ipywidgets \
    jupyterlab \
    matplotlib \
    nodejs \
    opencv \
    pandas \
    scikit-learn \
    seaborn \
    sympy \
    tqdm

# Install jupyter extensions
# jupyterlabでtqdmでの進捗バー表示が行えるようになる(3年前)
# 今はpip install tqdmで使える？
# RUN sudo jupyter nbextension enable --py --sys-prefix widgetsnbextension
# RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# jupyter_notebookの設定ファイルをコピー
COPY .devcontainer/jupyter_notebook_config.py /root/.jupyter/

# 起動時のスクリプトをコピー
COPY --chmod=+x .devcontainer/start_up.sh /usr/local/bin/

# コンテナ起動時にjupyter_notebookを起動
CMD ["/usr/local/bin/start_up.sh"]