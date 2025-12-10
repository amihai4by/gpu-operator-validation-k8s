#!/bin/bash

set -e

NS="gpu-operator"

print_header() {
    echo
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

menu() {
cat <<MENU

GPU Validation Suite
---------------------

Choose an option:

1) Deploy and run GPU test pod (nvidia-smi)
2) Generate full GPU Operator health report
3) Run node-level GPU hardware checks (nvidia-smi on all nodes)
4) Validate MIG configuration on all GPU nodes
5) Validate container runtime + NVIDIA toolkit integration
6) Run ALL tests

0) Exit

MENU
}

run_test_pod() {
    print_header "Deploying GPU Test Pod"

    cat <<'POD' > gpu-test-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-test
spec:
  restartPolicy: Never
  containers:
  - name: gpu-test
    image: nvcr.io/nvidia/cuda:12.4.1-base-ubuntu22.04
    command: ["bash", "-c", "nvidia-smi && sleep 3"]
    resources:
      limits:
        nvidia.com/gpu: 1
POD

    kubectl apply -f gpu-test-pod.yaml
    kubectl wait --for=condition=Ready pod/gpu-test --timeout=60s || true
    echo
    echo "--- Test Pod Output ---"
    kubectl logs gpu-test || echo "Test pod logs unavailable."
    echo "--- End ---"
}

health_report() {
    print_header "GPU OPERATOR HEALTH REPORT"

    echo "[1] DaemonSets"
    kubectl get ds -n $NS
    echo

    echo "[2] Pods"
    kubectl get pods -n $NS -o wide
    echo

    echo "[3] Node GPU Allocatable"
    kubectl get nodes -o json | jq -r '
      .items[] |
      .metadata.name as $name |
      .status.allocatable["nvidia.com/gpu"] as $gpu |
      "\($name): GPUs = \($gpu)"
    '
    echo

    echo "[4] Device Plugin Logs"
    for pod in $(kubectl get pods -n $NS -l app=nvidia-device-plugin-daemonset -o jsonpath='{.items[*].metadata.name}'); do
        echo "--- Logs from $pod ---"
        kubectl logs -n $NS $pod --tail=40 || true
        echo
    done

    echo "[5] GPU Feature Discovery Logs"
    for pod in $(kubectl get pods -n $NS -l app=gpu-feature-discovery -o jsonpath='{.items[*].metadata.name}'); do
        echo "--- Logs from $pod ---"
        kubectl logs -n $NS $pod --tail=30 || true
        echo
    done

    echo "[6] DCGM Exporter Logs"
    for pod in $(kubectl get pods -n $NS -l app=nvidia-dcgm-exporter -o jsonpath='{.items[*].metadata.name}'); do
        echo "--- Logs from $pod ---"
        kubectl logs -n $NS $pod --tail=20 || true
        echo
    done

    echo "[7] MIG State per Node"
    kubectl get nodes -o json | jq -r '
      .items[] |
      .metadata.name as $name |
      (.status.capacity | to_entries[] | select(.key | contains("mig"))) as $mig |
      "\($name): \($mig.key)=\($mig.value)"
    '
}

node_gpu_checks() {
    print_header "NODE-LEVEL GPU HARDWARE CHECKS"

    NODES=$(kubectl get nodes -o jsonpath='{.items[*].metadata.name}')

    for node in $NODES; do
        echo "--- Checking Node: $node ---"
        kubectl debug node/$node -it --image=nvcr.io/nvidia/cuda:12.4.1-base-ubuntu22.04 -- bash -c "nvidia-smi" || echo "Failed on $node"
        echo
    done
}

mig_checks() {
    print_header "MIG CONFIGURATION VALIDATION"

    for node in $(kubectl get nodes -o jsonpath='{.items[*].metadata.name}'); do
        echo "--- $node ---"
        kubectl describe node $node | grep -i mig || echo "No MIG info found"
        echo
    done
}

runtime_validation() {
    print_header "CONTAINER RUNTIME + NVIDIA TOOLKIT CHECK"

    echo "[1] Runtime info (kubelet)"
    systemctl status rke2-agent.service rke2-server.service 2>/dev/null | grep -i containerd || true
    echo

    echo "[2] Check containerd socket path"
    ls -l /run/k3s/containerd/containerd.sock || echo "Containerd socket missing"
    echo

    echo "[3] GPU toolkit inside container"
    kubectl run runtime-check \
        --rm -it \
        --image=nvcr.io/nvidia/cuda:12.4.1-base-ubuntu22.04 \
        --command -- nvidia-smi || echo "Runtime toolkit not working"
}

run_all() {
    run_test_pod
    health_report
    node_gpu_checks
    mig_checks
    runtime_validation
}

while true; do
    menu
    read -p "Enter selection: " sel

    case "$sel" in
        1) run_test_pod ;;
        2) health_report ;;
        3) node_gpu_checks ;;
        4) mig_checks ;;
        5) runtime_validation ;;
        6) run_all ;;
        0) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
