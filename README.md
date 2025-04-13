# DoHA Containerized Environment

This repository provides a fully containerized environment equipped with all the necessary tools for the **Design of Hardware Accelerators (DoHA)** lab sessions. It includes support for **HDL development in Visual Studio Code** and an automated installation process for optional Electronic Design Automation (EDA) tools like **Vivado** and **Gowin**.

## Features
- **(Optional)** Automatic installation of **Gowin EDA** *(v1.9.11.01 tested)*
- **(Optional)** Automatic installation of **Vivado** *(v2018.3 tested)*
- **HDL Development in VS Code**, with Verilog/SystemVerilog/Bluespec SystemVerilog extensions
- **Pre-installed simulation and verification tools**:
  - Icarus Verilog
  - Verilator
  - Verible
  - GTKWave
  - Cocotb

## Building the Environment

### Pre-requisites (For Optional EDA Installation)
To install **Vivado** or **Gowin**, place the corresponding `.tar.gz` installation file for Linux (obtained from the official websites) in the repository root before proceeding. The build process will automatically handle installation within the container.

### Building in Visual Studio Code
1. Clone this repository:
   ```sh
   git clone https://github.com/Hardware-Forge/lab_DHWA
   cd lab_DHWA
   ```
2. Open the folder in **Visual Studio Code**
3. Open the **Command Palette** (`Ctrl+Shift+P`) and select:
   ```
   Dev Containers: Rebuild and Reopen in Container
   ```
4. Wait for the process to complete, then enter the container if prompted.
5. Once inside, all terminals in VS Code will automatically use the containerized environment.

## Using the Environment
Once inside the container, use the following commands in the terminal to launch the tools:

- **Vivado**
  ```sh
  vivado
  ```
- **Gowin EDA**
  ```sh
  gw_ide
  ```
- **Other tools**
  - Use the blog linked in the credits for further details on included additional tools and their usage.

## Credits
This environment has been inspired by publicly available projects:
- [A Productive VSCode Setup for SystemVerilog Development - Igor Freire](https://igorfreire.com.br/2023/06/18/vscode-setup-for-systemverilog-development/)
- [starwaredesign/vivado-docker](https://github.com/starwaredesign/vivado-docker)

## Disclaimer and Contributions
I tested this setup on my device only (Linux, VSCode). If you want to test support on other OSes and in case suggest changes to the configuration please open a pull request.

---
With this setup, you can start developing **hardware accelerators** effortlessly within a fully configured and containerized environment! 🚀

