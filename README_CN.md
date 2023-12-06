# rl_docker

[English README](README.md)

使用docker可以快速部署隔离的、虚拟的、完全相同的开发环境， 不会出现“我的电脑能跑，你的电脑跑不了”的情况。

## 如何使用

### 完善配置文件

将`requirement_template.txt`复制一份并命名为`requirement.txt`，在此添加所需要的python依赖项

将`setup_template.sh`复制一份并命名为`setup.sh`，在此配置所有需要配置的python包

### 构建镜像

```bash
bash build.sh
```

### 运行镜像

```bash
bash run.sh -g <gpus, should be num or all> -d <true/false>
# example: bash run.sh -g 0 -d true
```

git不会track这两个新建的文件，如有需要请自行修改。

使用`Ctrl+P+Q`可退出当前终端，使用`exit`结束容器；

## 查看资源使用情况

```bash
bash exec.sh
```

镜像中内置了`nvitop`，新建一个窗口，运行`docker exec -it isaacgym_container /bin/bash`进入容器，运行`nvitop`查看系统资源使用情况。使用`exit`或者`Ctrl+P+Q`均可退出当前终端而不结束容器；

## 问题解决

### 显卡问题

* 如果使用的是RTX4090显卡，请修改`docker/Dockerfile`文件中的第一句为：

  ```dockerfile
  nvcr.io/nvidia/pytorch:22.12-py3
  ```

* 如果使用的是RTX3070显卡，则无需修改

### 权限问题

执行`run.sh`脚本的时候若出现如下报错：

```
Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error running hook #0: error running hook: exit status 1, stdout: , stderr: Auto-detected mode as 'legacy'
nvidia-container-cli: initialization error: load library failed: libnvidia-ml.so.1: cannot open shared object file: no such file or directory: unknown
```

出现此问题大多是因为没有使用root权限运行容器，以下几种方案均可：

* 在bash前加root
* 切换至root用户
* 将当前用户加入root组

若无法找到构建好的isaacgym镜像，则需重新以root权限构建镜像。

### runtime问题

执行`run.sh`脚本的时候若出现如下报错：

```
docker: Error response from daemon: could not select device driver "" with capabilities:[[gpu]].
```

则需要安装`nvidia-container-runtime`和`nvidia-container-toolkit`两个包，并修改Docker daemon 的启动参数，将默认的 Runtime修改为 nvidia-container-runtime：

```bash
 vi /etc/docker/daemon.json 
```

修改内容为

```json
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```