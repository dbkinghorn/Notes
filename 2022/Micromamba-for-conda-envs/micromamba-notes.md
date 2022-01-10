[mamba GitHub](https://github.com/mamba-org/mamba)

micromamba is a tiny version of the mamba package manager. It is a pure C++ package with a separate command line interface. It can be used to bootstrap environments (as an alternative to miniconda), but it's currently experimental. The benefit is that it's very tiny and does not come with a default version of Python.

micromamba works in the bash, zsh, and fish shells on Linux & OS X. It's completely statically linked, which allows you to drop it in some place and just execute it.

Note: it's advised to use micromamba in containers & CI only.

Download and unzip the executable (from the official conda-forge package):

```
wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
```

We can use ./micromamba shell init ... to initialize a shell (.bashrc) and a new root environment in ~/micromamba:

```
./bin/micromamba shell init -s bash -p ~/micromamba
source ~/.bashrc
```

Now you can activate the base environment and install new packages, or create other environments.

Note: currently the -c arguments have to come at the end of the command line.

```
micromamba activate
micromamba install python=3.6 jupyter -c conda-forge
# or
micromamba create -p /some/new/prefix xtensor -c conda-forge
micromamba activate /some/new/prefix
```

For more instructions (including OS X) check out https://gist.github.com/wolfv/fe1ea521979973ab1d016d95a589dcde

[Link to the gist that has info for OS X and Windows](https://gist.github.com/wolfv/fe1ea521979973ab1d016d95a589dcde)

## Linux

micromamba works in the bash & zsh shell on Linux & OS X. It's completely statically linked, which allows you to drop it in a compatible Linux or OS X and just execute it.

Download and unzip the executable (from the official conda-forge package):

```
wget -qO- https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba --strip-components=1
```

We can use ./micromamba shell init ... to initialize a shell (.bashrc) and a new root environment:

```
./micromamba shell init -s bash -p ~/micromamba
source ~/.bashrc
```

Now you can activate the base environment and install new packages, or create other environments.

```
micromamba activate
micromamba install python=3.6 jupyter -c conda-forge
micromamba create -p /some/new/prefix xtensor -c conda-forge
```

## OS X

Micromamba has OS X support as well. Instructions are largely the same:

```
curl -Ls https://micromamba.snakepit.net/api/micromamba/osx-64/latest | tar -xvj bin/micromamba
mv bin/micromamba ./micromamba
./micromamba shell init -s zsh -p ~/micromamba
source ~/.zshrc
micromamba activate
micromamba install python=3.6 jupyter -c conda-forge
```

## Windows

Micromamba also has Windows support! For Windows, we recommend powershell. Below are the commands to get micromamba installed.

```
Invoke-Webrequest -URI https://micromamba.snakepit.net/api/micromamba/win-64/latest -OutFile micromamba.tar.bz2
C:\PROGRA~1\7-Zip\7z.exe x micromamba.tar.bz2 -aoa
C:\PROGRA~1\7-Zip\7z.exe x micromamba.tar -ttar -aoa -r Library\bin\micromamba.exe
$Env:MAMBA_ROOT_PREFIX=(Join-Path -Path $HOME -ChildPath micromamba)
$Env:MAMBA_EXE=(Join-Path -Path (Get-Location) -ChildPath micromamba.exe)
.\micromamba.exe create -f ./test/env_win.yaml -y
```

## My use in pugetbench-numeric.py

```
MAMBA_DIR = Path("resources") / "mm"
MAMBA_EXE = MAMBA_DIR / f'{"micromamba" if os_in_use == "Linux" else "micromamba.exe"}'
MAMBA_ENVS = MAMBA_DIR / "envs"
```

```
def set_py_environment(py_env_dir):
    """A hack to workaround lame windows conda setup
    The main run_cmd function has this as an optional arg with default None"""
    if os_in_use == "Windows":
        sys_env = os.environ.copy()
        sys_env["PATH"] = str(py_env_dir) + "\\Library\\bin" + ";" + sys_env["PATH"]
        sys_env["PATH"] = (
            str(py_env_dir) + "\\Library\\usr\\bin" + ";" + sys_env["PATH"]
        )
        sys_env["PATH"] = (
            str(py_env_dir) + "\\Library\\mingw-w64\\bin" + ";" + sys_env["PATH"]
        )
        sys_env["PATH"] = str(py_env_dir) + "\\Scripts" + ";" + sys_env["PATH"]
        sys_env["PATH"] = str(py_env_dir) + ";" + sys_env["PATH"]
    else:
        sys_env = os.environ.copy()
    return sys_env


def run_cmd(cmd, sys_env=None):
    """Run the command cmd in a subprocess with output polling
    capturing stdout and stderr without waiting for the output buffer to flush
    so the user knows something is happening for longer running commands"""

    process = subprocess.Popen(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, env=sys_env
    )

    while True:
        output = process.stdout.readline()
        if output == "" and process.poll() is not None:
            break
        if output:
            print(output.strip())
    return process.poll()


def mk_mamba_cmd(env_name, env_args, channel):
    mamba_cmd = f"""{MAMBA_EXE }
                create -p {MAMBA_ENVS / env_name}
                -r {MAMBA_DIR} --yes {env_args} -c {channel} """
    return mamba_cmd.split()
```

...

```
    env_dir = MAMBA_ENVS / "np_mkl"
    if not env_dir.exists():
        run_cmd(mk_np_mkl)

    sys_env = set_py_environment(env_dir)
    run_cmd(np_mkl_benchmarks, sys_env)
```
