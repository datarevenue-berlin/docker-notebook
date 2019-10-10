# Data Revenue Notebooks

This repository includes helm charts and resources to build docker images for a Jupyter deployment that automatically spawns a remote kernel in a new kubernetes pod.

Remote kernels runs in a separated pod and namespace. This allows notebook usage to scale to many employees and notebooks using a kubernetes cluster. This is achieved using Enterprise Gateway.

Notebook instances are manged for each user separately using Jupyter Hub allowing fully customizable notebook environments. See `notebook-container` for more information on the rich default configuration.

## Structure
```
.
├── gateway                         Helm configuration for Enterprise Gateway chart
├── hub                             Helm configuration for Jupyter Hub
├── kernel-containers               All kernel containers are built in here
│   └── standard                    Build instructions for standard kernel
├── kernelspecs                     Kernelspec data container
│   └── kernels                     Contains all standard kernels
├── kubernetes                      Additional kubernetes resources
├── nfs                             ReadWriteMany volumes to mirror working dirs
└── notebook-container              Notebook deployment
```

## Deployment instruction

1. Make sure you are connected to your k8s cluster and have helm installed
2. Execute `bootstrap.sh` this will build all images, push them and start the k8s resources

## Add custom kernels
1. Duplicate the standard kernel directory in `kernelspecs/kernels/standard`
2. Edit the `kernelspec.json` to suite your needs
3. *Advanced:* Edit startup script and pod template if necessary
4. Make sure the required dockeri mage either is manged by a different respository or add it to `kernel-containers` (preferred)
5. Copy `kernelspecs/kernels/NEWKERNEL` to your enterprise gateway pod 
    `kubectl cp kernelspecs/kernels/NEWKERNEL PODNAME:/usr/local/share/jupyter/kernels/`
6. Build new image in `bootstrap.sh`
