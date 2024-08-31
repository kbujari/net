# `xnet`

Purely declarative infrastructure for my personal testing lab and computers!
Rather than individually managing a collection of computers,
this project defines a central network that hosts hook into to join the lab.
Each node shares the same code,
tuned by several parameters to match its hardware,
alongside extra configuration for services specific to that node.

## Goals

The entire lab should be **reproducible** given the instructions in this repo.
That is, all services and infrastructure must be completely defined here,
and able to be fully rebuilt from scratch in minutes.
The only exceptions are a couple hard drives in a ZFS pool that I maintain by hand,
for backups and data that cannot be recomputed.

Clouds and other outside services are strictly evaluated to keep external dependencies minimal.
Open protocols are favoured over vendor lock-in.
That said, I try to keep the all configurations flexible to support potentially running on a VPS in the future.

Performance is key! Of course, I don't require huge throughput from my personal workloads,
but creating lean, performant systems on regular hardware leads to understanding how to design architectures that run real workloads.

### NixOS

Nix is fundamentally the heart of the lab,
managing state and any applications that don't need to be clustered.
I prefer not to use containers when possible,
to simplify configuration and to better share resources between projects on a single machine.
For now, only servers are configured with Nix,
but in the near future I hope to extend the lab network with my personal computers as well,
to experiment with GPU computing.

### Kubernetes

As part of research and performance testing,
I maintain a personal K8s cluster.
Initially this ran on the popular [k3s](https://k3s.io/),
but I have since moved to [Talos](https://www.talos.dev/),
running on a mix of virtual machines and bare-metal to experiment with PXE booting and stateless computing.

FluxCD reads this git repository as a source of truth for reconciling cluster resources.
Cilium CNI was chosen for its performance and to experiment with eBPF networking rather than traditional `iptables`.
Cilium also natively supports BGP for load balancing services,
which I prefer for true network load balancing compared to L2 ARP services.
