gpu-operator-validation-k8s

A comprehensive validation toolkit for Kubernetes clusters running the NVIDIA GPU Operator.
This suite provides automated tests, health diagnostics, cluster-wide inspection, and runtime validation for GPU-enabled Kubernetes environments using RKE2, K3s, or upstream Kubernetes.

The script is designed to run on clusters with DGX OS, Ubuntu, or RHEL/Rocky, and supports single-node and multi-node GPU configurations.

Features
1. GPU Scheduling Test

Deploys a one-shot CUDA container that runs nvidia-smi to confirm:

GPU visibility

Device plugin registration

Scheduler GPU placement

Node GPU allocatable capacity

This is the fastest and most reliable way to validate end-to-end GPU availability.

2. Automatic GPU Operator Health Report

Collects detailed diagnostics from:

NVIDIA Device Plugin

GPU Feature Discovery (GFD)

DCGM / DCGM Exporter

Toolkit Daemonset

Node-level labels, allocatable resources, and taints

MIG configuration and GPU partitioning state

Outputs readable, structured results for troubleshooting and cluster auditing.

3. Node-Level GPU Hardware Checks

Runs nvidia-smi directly on each Kubernetes node (via kubectl debug) to validate:

Driver loading

NVML availability

GPU enumeration

GPU health and power state

Useful for identifying mismatched drivers or OS-level faults.

4. MIG Validation

Inspects MIG capacities, profiles, and node reports to ensure:

MIG mode is active when expected

Operator labels reflect actual GPU partitioning

MIG profiles are exposed to Kubernetes correctly

5. Container Runtime + Toolkit Integration Test

Verifies the NVIDIA container runtime stack:

containerd socket path (critical for RKE2/K3s)

runtimeClass configuration

toolkit readiness inside a live container

Usage
Clone the repository
git clone git@github.com:amihai4by/gpu-operator-validation-k8s.git
cd gpu-operator-validation-k8s

Run the validation suite
chmod +x gpu-validation-suite.sh
./gpu-validation-suite.sh


The script opens an interactive menu with the following options:

1) Deploy and run GPU test pod
2) Generate full GPU Operator health report
3) Run node-level GPU hardware checks
4) Validate MIG configuration
5) Validate container runtime + NVIDIA toolkit
6) Run ALL tests
0) Exit

Expected Results
A healthy GPU deployment should show:

Test pod completes and prints nvidia-smi

nvidia.com/gpu allocatable is correct (e.g., 8 for DGX)

All GPU Operator DaemonSets show READY status for every GPU node

GFD and DCGM logs show device detection without errors

No unexpected taints preventing scheduling

MIG profiles visible when MIG is enabled

Requirements

Kubernetes cluster with RKE2, K3s, or upstream K8s

NVIDIA GPU Operator installed

NVIDIA drivers and container toolkit present on GPU nodes

kubectl and jq installed on the admin host

CUDA-capable GPUs on at least one node

Troubleshooting

If test pods remain Pending:

Ensure GPU nodes are untainted and schedulable

Check device plugin logs for NVML or driver errors

Validate correct containerd socket path for RKE2
(/run/k3s/containerd/containerd.sock)

Ensure GPU Feature Discovery is running and labeling nodes

Check that the node has nvidia.com/gpu.present=true

License

MIT License
# gpu-operator-validation-k8s
