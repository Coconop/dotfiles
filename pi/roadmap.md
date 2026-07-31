# Raspberry Pi 4 Homelab — Rebuild Roadmap

Fresh install after wiping the previous "vibe-coded" setup. Scope: LAN-only media
server (Jellyfin + arr stack) with secure, minimal remote access via WireGuard.
No UFW/SSH-hardening theater beyond what's listed — NAT + WireGuard + key-only
SSH is the actual security boundary here.

**Hardware:** Pi 4, boot SSD via StarTech SATA-to-USB adapter, media SSD via
powered USB 3.0 hub (avoids the undervoltage issue from before).

---

## 0. Before anything else

- [ ] Flash Raspberry Pi OS Lite (64-bit) to the boot SSD
- [ ] Boot with **only** the boot SSD attached, confirm stable boot across 3+
      reboots
- [ ] `vcgencmd get_throttled` → should read `0x0` (no undervoltage)
- [ ] Only then attach the media SSD + powered hub and re-check
      `get_throttled`

```bash
sudo apt update && sudo apt full-upgrade -y
sudo rpi-eeprom-update -a   # latest bootloader/firmware
sudo reboot
```

---

## 1. Base tools + dependencies

Build tooling first (everything else depends on it):

```bash
sudo apt install -y build-essential clang ninja-build cmake pkg-config \
  libssl-dev curl git unzip
```

Rust (rustup, not apt — keeps it current):

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

Rust-ecosystem CLI tools (via cargo, or apt where packaged and current enough):

```bash
cargo install ripgrep fd-find bat
# tree-sitter CLI (needed for nvim-treesitter compiled parsers)
cargo install tree-sitter-cli
```

Rest of the toolbox:

```bash
sudo apt install -y fzf btop pass gnupg2
```

Neovim — apt's version is often stale; grab the latest release for ARM64
from the Neovim GitHub releases instead of `apt install neovim` if you want
a current version. Confirm architecture (`aarch64`) before downloading.

Docker:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

`pass` needs a GPG key if you don't already have one synced from elsewhere:

```bash
gpg --full-generate-key
```

---

## 2. Pi access & lockdown

**Ethernet only, disable Wi-Fi:**

```bash
sudo rfkill block wifi
# make it persistent:
echo "install cfg80211 /bin/false" | sudo tee /etc/modprobe.d/no-wifi.conf
```

**SSH key-only auth:**

1. Generate a keypair on your main machine (not the Pi):
   ```bash
   ssh-keygen -t ed25519 -C "pi-homelab"
   ```
2. Copy the public key to the Pi:
   ```bash
   ssh-copy-id pi@<pi-ip>
   ```
3. Store the **private key passphrase** in Bitwarden now, before you forget
   it again.
4. Disable password auth in `/etc/ssh/sshd_config`:
   ```
   PasswordAuthentication no
   KbdInteractiveAuthentication no
   PermitRootLogin no
   ```
5. `sudo systemctl restart ssh`
6. **Test the key login in a second terminal before closing your current
   session** — don't lock yourself out.

---

## 3. Media SSD — automount after boot

Use `/etc/fstab` with `nofail` so a missing/slow-to-init USB drive never
blocks boot (this was likely part of the original boot flakiness):

```bash
lsblk -f                     # find the partition + UUID
sudo mkdir -p /mnt/media
sudo blkid                   # copy the UUID
```

Add to `/etc/fstab`:
```
UUID=<your-uuid>  /mnt/media  ext4  defaults,nofail,x-systemd.device-timeout=10  0  2
```

`nofail` + `x-systemd.device-timeout` means the Pi boots fine even if the
drive is slow to enumerate — it mounts once ready instead of hanging boot.

---

## 4. Jellyfin (Docker, LAN only)

```yaml
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    network_mode: host   # simplest for LAN-only DLNA/discovery
    volumes:
      - /mnt/media:/media
      - ./jellyfin-config:/config
    restart: unless-stopped
```

No reverse proxy, no port forwarding — access via `http://<pi-ip>:8096` on
the LAN. Add remote access later, only through WireGuard (step 8), never by
forwarding this port directly.

---

## 5. Pi-hole vs AdGuard Home (LAN only)

- **Pi-hole**: follow the [official install guide](https://pi-hole.net) —
  it failed before, so this time watch specifically for: correct static IP
  assignment before install, and not conflicting with `systemd-resolved` on
  port 53 (`sudo systemctl disable --now systemd-resolved` or reconfigure
  it, is a common gotcha).
- **AdGuard Home**: worth trying as the alternative if Pi-hole gives grief
  again — single static binary, own DNS + DHCP, generally fewer moving
  parts than Pi-hole's stack. Docker image available, easy to run side by
  side for comparison before committing.

Either way: set your router's DHCP to hand out the Pi's IP as the DNS
server, or set it manually per-device — don't change router DHCP itself
until you've confirmed the DNS service is actually stable.

---

## 6. *arr stack (media suggestion + acquisition tracking)

Typical stack: **Sonarr** (TV), **Radarr** (movies), **Prowlarr** (indexer
manager feeding both), **Bazarr** (subtitles, optional), all as Docker
containers pointing at `/mnt/media` and talking to the downloader in step 7.

Keep them on the same Docker network so they can reach qBittorrent's API
directly by container name.

---

## 7. Downloader — qBittorrent behind a VPN

Yes, this is doable on Pi 4. The common pattern is
**qBittorrent + a VPN client container (e.g. gluetun)** in the same Docker
network namespace, so all qBittorrent traffic is forced through the VPN —
if the VPN drops, qBittorrent loses network entirely (kill-switch behavior).

Check first: does ProtonVPN's config support WireGuard-based connection
export? If so, `gluetun` supports WireGuard as a provider, which is
lighter on the Pi's CPU than OpenVPN — worth confirming before setup since
it affects the container config.

```yaml
services:
  vpn:
    image: qmcgaw/gluetun
    cap_add: [NET_ADMIN]
    environment:
      - VPN_SERVICE_PROVIDER=protonvpn
      - VPN_TYPE=wireguard
      # ...proton-specific wireguard keys/config
    ports:
      - 8080:8080   # qbittorrent WebUI, exposed via the vpn container
  qbittorrent:
    image: linuxserver/qbittorrent
    network_mode: "service:vpn"
    volumes:
      - /mnt/media/downloads:/downloads
```

Verify the kill-switch actually works before trusting it: stop the `vpn`
container and confirm qBittorrent immediately loses connectivity rather
than falling back to the Pi's normal network.

---

## 8. WireGuard — safe remote access, only you

This is the step to slow down on.

1. **Install WireGuard on the Pi**, generate a keypair, keep the private
   key on the Pi only.
2. **One peer = you.** Generate a client config for your phone/laptop with
   its own keypair — don't reuse keys across devices.
3. **Router/box config:** forward **only** the WireGuard UDP port (commonly
   51820, but pick something non-obvious) to the Pi's LAN IP. This is the
   *only* port that should ever be forwarded from your box to the Pi.
4. **Nothing else gets exposed.** Jellyfin, arr stack, Pi-hole/AdGuard all
   stay bound to LAN-only or `localhost` — you reach them by first
   connecting via WireGuard, which puts your remote device *on* the LAN
   virtually. No per-service port forwarding, no reverse proxy exposed to
   the internet.
5. **Give the Pi a stable local IP** (DHCP reservation on the router, or
   static config on the Pi) — WireGuard's internet-facing rule needs a
   fixed target.
6. **Verify from outside your network** (mobile data, not Wi-Fi) that:
   - WireGuard connects
   - Jellyfin/arr/Pi-hole are reachable *through* the tunnel
   - They are **not** reachable directly by IP:port without the tunnel up
     (double-check by disabling WireGuard on your phone and confirming the
     services time out from outside)

If this failed before, the most common cause is either wrong endpoint IP
(dynamic DNS needed if your ISP doesn't give a static IP) or a firewall
rule on the router blocking the forwarded UDP port — worth checking your
box's port-forward actually applied and isn't shadowed by a second
firewall layer (some ISP boxes have both a router UI and a separate modem
bridge that need to agree).

---

## Suggested order of operations

1 → 0 → 2 → 3 → 4 (validate Jellyfin works LAN-only) → 5 → 6 → 7 → 8

Get Jellyfin solid and stable on its own before adding Pi-hole/arr/VPN —
that's the one thing that worked last time, so it's the foundation to
protect while layering the rest on top, one piece at a time with
verification at each step.
