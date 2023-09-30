let
  machines = {
    linode = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExj3H8k2iLriwR/Ui9RzIaox+qmy8H1kvKZjNAn9ddZ"; # A normal SSH ed25519 key.
  };
  pth = "secrets";
  users = {
    sky = "age1yubikey1qd07mh0sznx06zvy3qrzfyajeaveerdg4awzp4t4s5dvc7285n4a23hk6j2"; # the public key
  };
in {
  "${pth}/nextcloudPassword".publicKeys = [
    users.sky
    machines.linode
  ];
}
