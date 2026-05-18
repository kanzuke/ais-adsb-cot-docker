# 🚢 aiscot Docker Container

This container provides a lightweight and configurable deployment of **aiscot**, converting AIS (Automatic Identification System) data into Cursor on Target (CoT) messages.

---

## 🎯 Overview

**aiscot** acts as an adapter:

```
AIS (UDP / NMEA)
        ↓
      aiscot
        ↓
   CoT (UDP output)
```

Typical use case:

* Input: UDP AIS stream on port `5050`
* Output: `udp://cotproxy:8087`

---

## ⚙️ Features

* 📦 Official `.deb` installation (no pip or manual builds)
* 🔧 Dynamic configuration via environment variables
* 🐳 Minimal Debian-based container
* 🌍 Multi-architecture ready (amd64 / arm64)
* 🔌 Seamless integration with TAK ecosystem (cotproxy, ATAK, etc.)
* 📄 Automatic generation of `aiscot.ini` at startup

---

## 🚀 Quick Start

### 🔨 Build

```bash
docker build -t aiscot .
```

---

### ▶️ Run (recommended: host networking)

```bash
docker run --rm -it \
  --network host \
  aiscot
```

---

## ⚙️ Configuration

Configuration is generated dynamically at container startup.

### Environment Variables

| Variable   | Default                   | Description                     |
| ---------- | ------------------------- | ------------------------------- |
| `AIS_PORT` | `5050`                    | UDP port to listen for AIS data |
| `COT_URL`  | `udp+wo://127.0.0.1:8087` | CoT destination                 |

---

### Example

```bash
docker run --rm -it \
  --network host \
  -e AIS_PORT=6000 \
  -e COT_URL=udp+wo://127.0.0.1:8087 \
  aiscot
```

---

## 🧾 Generated Configuration

At startup, the container generates:

```ini
ENABLED=1

COT_URL=<COT_URL>

AIS_PORT=<AIS_PORT>

COT_STALE=3600

COT_TYPE=a-u-S-X-M

KNOWN_CRAFT=/app/ais-known-craft.csv

INCLUDE_ALL_CRAFT=True
```

---

## 📄 Known Craft File

The container expects an optional file:

```
/app/ais-known-craft.csv
```

* Used to provide vessel metadata (callsigns, hints)
* If not provided, an empty file is created automatically
* You can mount your own file:

```bash
-v ./ais-known-craft.csv:/app/ais-known-craft.csv
```

---

## 🌐 Networking Notes

* **Host networking is strongly recommended**

  * Required for receiving UDP AIS streams
  * Simplifies integration with RF receivers or gateways

Alternative (bridge mode):

```bash
-p 5050:5050/udp
```

---

## ⚠️ Limitations

* UDP input is **connectionless** (no delivery guarantee)
* No built-in buffering or retry
* Requires external AIS data source (RF receiver, gateway, etc.)

---

## 🧩 Integration Example

```text
AIS receiver → aiscot → cotproxy → multitarget → ATAK
```

---

## 🙏 Credits

This container packages and automates deployment of:

* **aiscot** by the SANS Technology Institute / SNSTAC project
  👉 https://github.com/snstac/aiscot

* Related components:

  * https://github.com/snstac/pytak

All credit goes to the original authors for their work on the TAK ecosystem.

---

## 📜 License

This container only wraps upstream software.
Please refer to the original project licenses:

* https://github.com/snstac/aiscot
* https://github.com/snstac/pytak

---

## 💡 Future Improvements

* Healthcheck support
* Metrics (Prometheus)
* AIS filtering (MMSI, vessel type)
* Geofencing capabilities

---

## 🛰️ Use Case

This container is designed for:

* Maritime situational awareness
* Tactical deployments
* Edge nodes (Raspberry Pi, embedded systems)
* Integration into modular CoT pipelines

---

**Ready to plug into your maritime COT stack.**
