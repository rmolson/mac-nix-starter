# Templates to get development environments started using NIX
[Nix main site](https://nixos.org/)

[Nix packages](https://search.nixos.org/)

This readme assume you are starting on a new computer, and is currently mac focused.

# Mac

## Adding Nix

- go to https://nixos.org/download and download the installer for the Nix package manager for your system.

Example:
```sh
sh <(curl -L https://nixos.org/nix/install)
```

If you are starting on a new mac, and you don't have git and/or xcode-select installed, you can let the nix package manager manage that. I'm going to run in a nix shell that will supply git.

```sh
nix-shell -p git
```

At this point we can go into the `sample-node18` directory and run the following command, and be in a development environment with nodejs 18
```sh
nix develop --extra-experimental-features nix-command --extra-experimental-features  flakes
```

## Nix flakes
We are using nix flakes.  While nix flakes are common to use, they are still considered experimental to nix.  In order to use them, and not have to add options to each command, we are going to add a config file to tell nix it's okay.

- Create a new directory and config file
```sh
mkdir -p ~/.config/nix
touch ~/.config/nix/nix.conf
```
open the nix.conf file with your editor and add the following line to it
```nix
experimental-features = nix-command flakes
```

Now you should be able to go into the `sample-node18` directory and type
```sh
nix develop
```
and end up in a nix development shell with nodejs and typescript

I've done all of this running in a nix-shell to provide me `git`.  In the next section, I'm going to setup home manager so I can install git via nix, as well as `direnv` so when I go into the `sample-node18` directory it will put me in a nix dev shell automatically

## Home manager
Home manager documentation: https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone

I'm going it install home-manager using nix flakes. This will do the following
- Install home-manager
- Create a directory `~/.config/home-manager`
- add some base nix files
  - flake.nix
  - home.nix
  - flake.lock

```sh
nix run home-manager/master -- init --switch
```

You can now add packages by adding them to the `~/.config/home-manager/home.nix` file and apply/install with the following command.

I want to be able to go into a directory and automatically be in a nix development shell.  In order to do that, I need some additional packages and config.  I'm going to add the following to the `~/.config/home-manager/home.nix` file

> [!WARNING]
> If you have custom `.bashrc` or `.zshrc` file, copy them somewhere to back them up.  the `bash.enable` and `zsh.enable` directives below will tell home-manager to start managing those files.

```nix
  programs = {
    bash.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    git.enable = true;
    zsh = {
      enable = true;
    };
  };
```
[example](https://github.com/rmolson/nix-developer-envs/blob/docs/sample-home-manager/home.nix#L73)

run `home-manager switch` to apply this config
```sh
home-manager switch
```

Since this is going to update bashrc/zshrc, you will need to open a new shell.

Now if you go into the sample-node18 directory, it will provide an error.

```sh
direnv: error /Users/me/git/nix-developer-envs/sample-node18/.envrc is blocked. Run `direnv allow` to approve its content
```

When using direnv, you have to tell your system it is okay to run what it is the .envrc file when you go to this directory.

```sh
direnv allow
```

Once you do that, you will be in a nix develop shell.  When you leave the directory the shell will go away, when you come back in the shell will start