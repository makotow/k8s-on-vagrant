# One line title

* 他の言語で読む: [English](README.md)

## これはなに

Vagrant上で 2node(masterx1, workerx1) kubernetesクラスタを立ち上げるものです。

## 前提条件

現在は以下の環境をサポートしています。

* VM: Ubuntu 18.04 Bionic Beaver
* Kubernetes 1.15

## 使い方

```bash
vagrant up
```

## 中身

作りは至ってシンプルでkubeadmを使ったプロビジョニングを自動化したものです。

VagrantfileにVMのプロビジョニングが記載されています。
Vagrantfileから呼び出されるshellスクリプトはshellディレクトリに配置されており、
その内容は普通の環境でも適応可能なものです。

## Authors

* [@makotow](https://github.com/makotow)

## ライセンス

MIT