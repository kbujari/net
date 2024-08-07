# net

Purely declarative infrastructure for my personal testing lab and computers!
Rather than individually managing a collection of computers,
this project defines a central network that hosts hook into to join the lab.
Each node shares the same code,
tuned by several parameters to match its hardware,
alongside extra configuration for services specific to that node.

The main goals are to keep everything simple and run as lean as possible.
To this point, outside dependencies are strictly evaluated before being included.
Here's an updated list:

- [nixpkgs](https://github.com/NixOS/nixpkgs)
- [Porkbun DNS](https://porkbun.com)
