# 🛫 adsbcot Docker Container

This container provides a lightweight and configurable deployment of **adsbcot**, converting ADS-B data (from sources like ultrafeeder/tar1090) into Cursor on Target (CoT) messages.

---

## 🎯 Overview

**adsbcot** acts as an adapter:

```
ADS-B JSON (tar1090 / ultrafeeder)
            ↓
         adsbcot
            ↓
     CoT (UDP output)
```

Typical use case:

* Input: `http://localhost:8080/data/aircraft.json`
* Output: `udp://cotproxy:8087`

---

## ⚙️ Features

* 📦 Official `.deb` installation (no pip hacks)
* 🔧 Dynamic configuration via environment variables
* 🐳 Minimal Debian-based container
* 🌍 Multi-architecture ready (amd64 / arm64)
* 🔌 Plug & play with TAK ecosystem (cotproxy, ATAK, etc.)

---

## 🚀 Quick Start

### 🔨 Build

```bash
docker build -t adsbcot .
```

---

### ▶️ Run (recommended: host networking)

```bash
docker run --rm -it \
  --network host \
  adsbcot
```

---

## ⚙️ Configuration

Configuration is generated dynamically at container startup.

### Environment Variables

| Variable             | Default                                    | Description                          |
| -------------------- | ------------------------------------------ | ------------------------------------ |
| `ADSB_FEED_URL`      | `http://127.0.0.1:8080/data/aircraft.json` | ADS-B source (tar1090 / ultrafeeder) |
| `ADSB_POLL_INTERVAL` | `5`                                        | Polling interval (seconds)           |
| `COT_URL`            | `udp+wo://127.0.0.1:8087`                  | CoT destination                      |

---

### Example

```bash
docker run --rm -it \
  --network host \
  -e ADSB_FEED_URL=http://192.168.1.50/data/aircraft.json \
  -e ADSB_POLL_INTERVAL=2 \
  -e COT_URL=udp+wo://127.0.0.1:8087 \
  adsbcot
```

---

## 🧾 Generated Configuration

At startup, the container generates:

```ini
[adsbcot]

FEED_URL=<ADSB_FEED_URL>
COT_URL=<COT_URL>
POLL_INTERVAL=<ADSB_POLL_INTERVAL>
```

---

## 🌐 Networking Notes

* **Host networking is strongly recommended**

  * Required for accessing `localhost` services (ultrafeeder)
  * Simplifies UDP communication
* If not using host mode:

  * Use container names or explicit IPs
  * Ensure proper port exposure

---

## ⚠️ Limitations

* UDP output is **fire-and-forget** (no delivery guarantee)
* No built-in buffering or retry mechanism
* Depends on availability of ADS-B JSON feed

---

## 🧩 Integration Example

```text
ultrafeeder → adsbcot → cotproxy → multitarget → ATAK
```

---

## 🙏 Credits

This container packages and automates deployment of:

* **adsbcot** by the SANS Technology Institute / SNSTAC project
  👉 https://github.com/snstac/adsbcot

* Related components:

  * https://github.com/snstac/pytak
  * https://github.com/snstac/aircot

All credit goes to the original authors for their work on the TAK ecosystem.

---

## 📜 License

This container only wraps upstream software.
Please refer to the original project licenses:

* https://github.com/snstac/adsbcot
* https://github.com/snstac/pytak

---

## 💡 Future Improvements

* Healthcheck endpoint
* Metrics (Prometheus)
* Optional buffering layer
* Secure CoT (TLS)

---

## 🛰️ Use Case

This container is designed for:

* Tactical deployments
* Edge nodes (Raspberry Pi, embedded systems)
* Integration into modular CoT pipelines

---

**Ready to plug into your COT stack.**
