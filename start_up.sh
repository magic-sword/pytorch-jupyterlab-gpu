#!/bin/sh

# jupyter notebookをバックアップで起動し、永続化 (ログイン不要)
nohup jupyter notebook --ip='*' --NotebookApp.token='' --NotebookApp.password='' &