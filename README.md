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
  <p>Deploys a one shot CUDA container that runs <code>nvidia-smi</code> to confirm:</p>
  <ul>
    <li>GPU visibility</li>
    <li>Device plugin registration</li>
    <li>Scheduler GPU placement</li>
    <li>Node GPU allocat
