### /!\ Please Read the following before running scripts /!\ :

1) Open clonetorch.sh file using nano.
```bash
sudo apt update && sudo apt install -y nano git curl
nano clonetorch.sh
```

2) Modify the following line `export PYTORCH_ROCM_ARCH=gfx1100` with the value associated to your own hardware.

You can check your gfx version using `rocminfo | grep gfx` or see it on this link below (for remote usage).
[https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html#supported-gpus]

