# dotfiles.nix

Cross-platform Linux and macOS development environments for the [TheAltF4Stream](https://www.twitch.tv/thealtf4stream).

![Test flake](https://github.com/ALT-F4-LLC/dotfiles-nixos/actions/workflows/flake.yaml/badge.svg)

## Goals

Maintain declarative configurations for environments that are reproducible on each operating system.

![Preview](https://github.com/ALT-F4-LLC/dotfiles-nixos/blob/main/config/preview.webp)

### Why move from Ansible?

I started out using `Ansible` to automate and maintain my development environment ([see more here](http://github.com/ALT-F4-LLC/dotfiles)). This was a solid solution and is my recommended way of getting started with development environment automation if you "don't" have any interest in jumping the boat to Nix yet.

I switched because I began to deal with issues from imperative (step-by-step) automation. Things like making sure one step works so another can, having proper dependencies at the right time and other challenges that required more automation steps.

I wanted declarative configurations that defined my development environments.

### Why NixOS?

I chose NixOS because of its unique approach to system configuration and package management. NixOS uses the Nix package manager, which provides reproducible, declarative, and reliable environments. This means that my development environment is consistent and predictable, eliminating the "works on my machine" problem.

NixOS's atomic upgrades and rollbacks ensure that system updates are safer and easier to manage. The ability to describe the entire system configuration in a single declarative file simplifies maintenance and enhances portability across different machines.

### Why macOS + nix-darwin?

Using macOS with nix-darwin offers the best of both worlds:

- the robustness and familiarity of macOS
- the power of Nix package management

Nix-darwin allows me to manage macOS configuration in a declarative manner, similar to how NixOS operates. This way, I can leverage the Nix ecosystem to manage software packages and system configurations while still enjoying the benefits of macOS, such as hardware support, user-friendly interface, and wide range of software.

It's an ideal setup for a cross-platform development environment that requires both stability and flexibility.
