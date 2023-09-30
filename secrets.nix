let
  #   machines = {
  #      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmveI8P/aqICzkZ+2nTxbV7RB5/ZEsgsxZmC3IajYxL root@ubuntu-s-1vcpu-1gb-nyc3-01"; # A normal SSH ed25519 key.
  #   };
  pth = "secrets";
  users = {
    sky = "age1yubikey1qd07mh0sznx06zvy3qrzfyajeaveerdg4awzp4t4s5dvc7285n4a23hk6j2"; # the public key
  };
in {
  "${pth}/nextcloudPassword".publicKeys = [
    users.sky
  ];
}
