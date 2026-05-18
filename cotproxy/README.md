# 🧠 cotproxy Docker Container

This container provides a lightweight and production-ready deployment of **cotproxy**, acting as a central CoT message broker.

---

## 🎯 Overview

**cotproxy** receives CoT messages from multiple sources and forwards them to a destination.

```text
CoT (UDP input)
        ↓
     cotproxy
        ↓
   CoT (TCP output)
```

Typical use case:

* Input: UDP port `8087` (adsbcot, aiscot, etc.)
* Output: TCP `127.0.0.1:9090` (multitarget service)

---

## ⚙️ Features

* 📦 Official `.deb` installation (no pip)
* 🧠 Central CoT aggregation point
* 🔁 UDP → TCP bridge
* 🔧 Dynamic configuration via environment variables
* 🌍 Multi-architecture ready (amd64 / arm64)
* 🔌 Seamless integration with TAK ecosystem

---

## 🚀 Quick Start

### 🔨 Build

```bash
docker build -t cotproxy .
```

---

### ▶️ Run

```bash
docker run --rm -it \
  --network host \
  cotproxy
```

---

## ⚙️ Configuration

The container generates its configuration dynamically at startup.

### Environment Variables

| Variable          | Default                | Description                        |
| ----------------- | ---------------------- | ---------------------------------- |
| `COT_LISTEN_URL`  | `udp://0.0.0.0:8087`   | Input CoT stream                   |
| `COT_FORWARD_URL` | `tcp://127.0.0.1:9090` | Output CoT destination             |
| `PASS_ALL`        | `True`                 | Forward all messages               |
| `AUTO_ADD`        | `True`                 | Automatically register new senders |
| `SEED_FAA_REG`    | `True`                 | Enrich aircraft data               |

---

### Example

```bash
docker run --rm -it \
  --network host \
  -e COT_FORWARD_URL=tcp://192.168.1.100:9000 \
  cotproxy
```

---

## 🧾 Generated Configuration

At startup, the container generates:

```ini
[cotproxy]

LISTEN_URL=<COT_LISTEN_URL>

COT_URL=<COT_FORWARD_URL>

PASS_ALL=<PASS_ALL>
AUTO_ADD=<AUTO_ADD>
SEED_FAA_REG=<SEED_FAA_REG>
```

---

## 🌐 Networking Notes

* **Host networking is strongly recommended**

  * Required for UDP ingestion
  * Simplifies integration with other services

Alternative (bridge mode):

```bash
-p 8087:8087/udp
```

---

## ⚠️ Behavior Notes

* UDP input is **connectionless**
* TCP output is **persistent**
* Acts as a **bridge**, not a storage system
* No filtering by default (forwards all CoT messages)

---

## 🧩 Integration Example

```text
adsbcot → UDP 8087 → cotproxy → TCP 9090 → multitarget → ATAK
aiscot  → UDP 8087 ┘
```

---

## 🙏 Credits

This container packages and automates deployment of:

* **cotproxy** by AmpleData
  👉 https://github.com/ampledata/cotproxy

* Related component:

  * https://github.com/ampledata/pytak

All credit goes to the original authors for their work on CoT tooling.

---

## 📜 License

This container only wraps upstream software.
Refer to original licenses:

* https://github.com/ampledata/cotproxy
* https://github.com/ampledata/pytak

---

## 💡 Future Improvements

* TLS support (secure CoT)
* Filtering / routing rules
* Metrics and observability
* High-availability setup

---

## 🛰️ Use Case

This container is designed for:

* Tactical CoT aggregation
* Edge deployments
* Multi-source CoT ingestion pipelines
* TAK ecosystem integration

---

**The central nervous system of your CoT pipeline.**
