
# **gpu-operator-validation-k8s**

A comprehensive validation toolkit for Kubernetes clusters running the **NVIDIA GPU Operator**.
This suite provides automated tests, health diagnostics, cluster-wide inspection, and runtime validation for GPU-enabled Kubernetes environments using **RKE2**, **K3s**, or **upstream Kubernetes**.

The script works on clusters running **DGX OS**, **Ubuntu**, or **RHEL/Rocky**, and supports both single-node and multi-node GPU configurations.

---

## **Features**

### **GPU Scheduling Test**

Deploys a one-shot CUDA container that executes `nvidia-smi` to validate:

* GPU visibility
* Device plugin registration
* Scheduler GPU placement
* Node GPU allocatable capacity

This is the fastest and most reliable way to validate end-to-end GPU availability.

---

### **Automatic GPU Operator Health Report**

Collects detailed diagnostics from:

* NVIDIA Device Plugin
* GPU Feature Discovery (GFD)
* DCGM / DCGM Exporter
* NVIDIA Toolkit DaemonSet
* Node labels, allocatable resources, and taints
* MIG configuration and partitioning state

---

### **Node-Level GPU Hardware Checks**

Uses `kubectl debug` to run `nvidia-smi` directly on each Kubernetes node, validating:

* Driver loading
* NVML availability
* GPU enumeration
* GPU health and power state

Useful for detecting mismatched drivers or OS-level issues.

---

### **MIG Validation**

Ensures:

* MIG mode is enabled when expected
* MIG profiles match operator labels
* Kubernetes recognizes MIG partitions correctly

---

### **Container Runtime + Toolkit Integration Test**

Verifies:

* Correct containerd socket path (critical for RKE2/K3s)
* RuntimeClass configuration
* Toolkit readiness inside a live container

---

## **Usage**

### **Clone the repository**

```bash
git clone git@github.com:amihai4by/gpu-operator-validation-k8s.git
cd gpu-operator-validation-k8s
```

### **Run the validation suite**

```bash
chmod +x gpu-validation-suite.sh
./gpu-validation-suite.sh
```

### **Interactive menu options**

```
1) Deploy and run GPU test pod
2) Generate full GPU Operator health report
3) Run node-level GPU hardware checks
4) Validate MIG configuration
5) Validate container runtime + NVIDIA toolkit
6) Run ALL tests
0) Exit
```

---

## **Expected Results**

A healthy GPU deployment should show:

* Test pod completes and prints `nvidia-smi`
* `nvidia.com/gpu` allocatable count is correct (e.g., 8 for DGX)
* All GPU Operator DaemonSets show READY on GPU nodes
* GFD and DCGM logs show successful GPU detection
* No taints blocking scheduling on GPU nodes
* MIG profiles visible when MIG is enabled

---

## **Requirements**

* Kubernetes cluster running **RKE2**, **K3s**, or **Kubernetes upstream**
* NVIDIA GPU Operator installed
* NVIDIA drivers and container toolkit present on GPU nodes
* `kubectl` and `jq` installed on the admin host
* At least one CUDA-capable GPU node

---

## **Troubleshooting**

If GPU test pods remain **Pending**:

* Ensure GPU nodes are untainted and schedulable

* Check device plugin logs for NVML or driver issues

* Validate correct RKE2 containerd socket:

  ```
  /run/k3s/containerd/containerd.sock
  ```

* Verify GPU Feature Discovery (GFD) is running

* Ensure the GPU node has the label:

  ```
  nvidia.com/gpu.present=true
  ```

---

## **License**

**MIT License**


