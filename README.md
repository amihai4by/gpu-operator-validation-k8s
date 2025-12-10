<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>gpu-operator-validation-k8s</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body {
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      margin: 0;
      padding: 2rem;
      line-height: 1.6;
      max-width: 960px;
    }
    h1, h2, h3 {
      font-weight: 600;
    }
    h1 {
      margin-bottom: 0.25rem;
    }
    code {
      font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
      background: #f4f4f4;
      padding: 0.15rem 0.35rem;
      border-radius: 4px;
      font-size: 0.95em;
    }
    pre {
      background: #111;
      color: #f5f5f5;
      padding: 1rem;
      border-radius: 6px;
      overflow-x: auto;
      font-size: 0.95em;
    }
    pre code {
      background: transparent;
      padding: 0;
    }
    ul {
      margin-left: 1.25rem;
    }
    .menu-list li {
      margin: 0.15rem 0;
      font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
    }
    .badge {
      display: inline-block;
      padding: 0.2rem 0.6rem;
      border-radius: 999px;
      font-size: 0.8rem;
      background: #eef2ff;
      color: #3730a3;
      margin-left: 0.5rem;
    }
    hr {
      margin: 2rem 0;
      border: 0;
      border-top: 1px solid #e5e5e5;
    }
  </style>
</head>
<body>
  <h1>gpu-operator-validation-k8s</h1>
  <p>
    A comprehensive validation toolkit for Kubernetes clusters running the NVIDIA GPU Operator.
    This suite provides automated tests, health diagnostics, cluster wide inspection, and runtime
    validation for GPU enabled Kubernetes environments using RKE2, K3s, or upstream Kubernetes.
  </p>
  <p>
    The script is designed to run on clusters with DGX OS, Ubuntu, or RHEL/Rocky, and supports
    single node and multi node GPU configurations.
  </p>

  <hr>

  <h2>Features</h2>

  <h3>GPU Scheduling Test</h3>
  <p>
    Deploys a one shot CUDA container that runs <code>nvidia-smi</code> to confirm:
  </p>
  <ul>
    <li>GPU visibility</li>
    <li>Device plugin registration</li>
    <li>Scheduler GPU placement</li>
    <li>Node GPU allocatable capacity</li>
  </ul>
  <p>
    This is the fastest and most reliable way to validate end to end GPU availability.
  </p>

  <h3>Automatic GPU Operator Health Report</h3>
  <p>Collects detailed diagnostics from:</p>
  <ul>
    <li>NVIDIA Device Plugin</li>
    <li>GPU Feature Discovery (GFD)</li>
    <li>DCGM / DCGM Exporter</li>
    <li>Toolkit DaemonSet</li>
    <li>Node level labels, allocatable resources, and taints</li>
    <li>MIG configuration and GPU partitioning state</li>
  </ul>
  <p>
    Outputs readable, structured results for troubleshooting and cluster auditing.
  </p>

  <h3>Node Level GPU Hardware Checks</h3>
  <p>
    Runs <code>nvidia-smi</code> directly on each Kubernetes node (via <code>kubectl debug</code>) to validate:
  </p>
  <ul>
    <li>Driver loading</li>
    <li>NVML availability</li>
    <li>GPU enumeration</li>
    <li>GPU health and power state</li>
  </ul>
  <p>
    Useful for identifying mismatched drivers or OS level faults.
  </p>

  <h3>MIG Validation</h3>
  <p>Inspects MIG capacities, profiles, and node reports to ensure:</p>
  <ul>
    <li>MIG mode is active when expected</li>
    <li>Operator labels reflect actual GPU partitioning</li>
    <li>MIG profiles are exposed to Kubernetes correctly</li>
  </ul>

  <h3>Container Runtime and Toolkit Integration Test</h3>
  <p>Verifies the NVIDIA container runtime stack:</p>
  <ul>
    <li><code>containerd</code> socket path (critical for RKE2 and K3s)</li>
    <li><code>runtimeClass</code> configuration</li>
    <li>Toolkit readiness inside a live container</li>
  </ul>

  <hr>

  <h2>Usage</h2>

  <h3>Clone the repository</h3>
  <pre><code>git clone git@github.com:amihai4by/gpu-operator-validation-k8s.git
cd gpu-operator-validation-k8s
</code></pre>

  <h3>Run the validation suite</h3>
  <pre><code>chmod +x gpu-validation-suite.sh
./gpu-validation-suite.sh
</code></pre>

  <p>The script opens an interactive menu with the following options:</p>
  <ul class="menu-list">
    <li>1) Deploy and run GPU test pod</li>
    <li>2) Generate full GPU Operator health report</li>
    <li>3) Run node level GPU hardware checks</li>
    <li>4) Validate MIG configuration</li>
    <li>5) Validate container runtime and NVIDIA toolkit</li>
    <li>6) Run ALL tests</li>
    <li>0) Exit</li>
  </ul>

  <hr>

  <h2>Expected Results</h2>
  <p>A healthy GPU deployment should show:</p>
  <ul>
    <li>Test pod completes and prints <code>nvidia-smi</code></li>
    <li><code>nvidia.com/gpu</code> allocatable is correct (for example 8 for DGX)</li>
    <li>All GPU Operator DaemonSets show READY status for every GPU node</li>
    <li>GFD and DCGM logs show device detection without errors</li>
    <li>No unexpected taints preventing scheduling</li>
    <li>MIG profiles visible when MIG is enabled</li>
  </ul>

  <hr>

  <h2>Requirements</h2>
  <ul>
    <li>Kubernetes cluster with RKE2, K3s, or upstream Kubernetes</li>
    <li>NVIDIA GPU Operator installed</li>
    <li>NVIDIA drivers and container toolkit present on GPU nodes</li>
    <li><code>kubectl</code> and <code>jq</code> installed on the admin host</li>
    <li>CUDA capable GPUs on at least one node</li>
  </ul>

  <hr>

  <h2>Troubleshooting</h2>
  <p>If test pods remain Pending:</p>
  <ul>
    <li>Ensure GPU nodes are untainted and schedulable</li>
    <li>Check device plugin logs for NVML or driver errors</li>
    <li>Validate correct <code>containerd</code> socket path for RKE2 (<code>/run/k3s/containerd/containerd.sock</code>)</li>
    <li>Ensure GPU Feature Discovery is running and labeling nodes</li>
    <li>Check that the node has <code>nvidia.com/gpu.present=true</code></li>
  </ul>

  <hr>

  <h2>License<span class="badge">MIT</span></h2>
  <p>MIT License</p>

</body>
</html>
