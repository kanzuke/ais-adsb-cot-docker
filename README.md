# 🛰️ AIS + ADS-B to CoT Stack (Docker Compose)

This repository provides a complete, modular, and production-ready **Cursor on Target (CoT) pipeline**, integrating:

* ✈️ ADS-B data (air traffic)
* 🚢 AIS data (maritime traffic)
* 🧠 CoT aggregation and routing
* 🎯 Multi-destination distribution
* 🌐 Web monitoring interface

All components are containerized and orchestrated using Docker Compose.

---

## 🎯 Architecture Overview

```text
ultrafeeder (ADS-B JSON)         AIS Source
        ↓                            ↓
     adsbcot  ───────┬─────────── aiscot
                     ↓
                 (UDP 8087)
                     ↓
                 cotproxy ---→ cotproxyweb (monitoring UI)
                     ↓
                  TCP 9090
                     ↓
               cotmultitargets
                     ↓
     multiple destinations (ATAK, multicast, etc.)

```

---

## 🧩 Components

### ✈️ adsbcot

* Converts ADS-B JSON (tar1090 / ultrafeeder) → CoT
* Input: HTTP JSON feed
* Output: UDP CoT → `cotproxy`

---

### 🚢 aiscot

* Converts AIS UDP stream → CoT
* Input: UDP (default `5050`)
* Output: UDP CoT → `cotproxy`

---

### 🧠 cotproxy

* Central CoT broker
* Aggregates multiple CoT sources
* Forwards to TCP consumers

---

### 🎯 cot-multi-targets

* Receives CoT via TCP
* Forwards to multiple destinations (TCP / UDP / multicast)
* Configured via `config.json`

📄 Example config: 

---

### 🌐 cotproxyweb

* Django-based UI
* Allows monitoring of CoT events
* Includes admin interface

---

## 🚀 Quick Start

### 1. Clone repository

```bash
git clone <your-repo>
cd <your-repo>
```

---

### 2. Configure destinations

Edit:

```bash
config.json
```

Example:

```json
{
  "destinations": [
    {
      "ip": "192.168.1.10",
      "port": 9000,
      "proto": "tcp"
    }
  ]
}
```

---

### 3. Start the stack

```bash
docker compose up -d
```

---

### 4. Access Web UI

```text
http://<host-ip>:10415
```

---

## ⚙️ Configuration

### 🌍 Global

All services use:

```bash
TZ=Etc/UTC
```

---

### ✈️ ADS-B (adsbcot)

| Variable             | Description               | Default                   |
| -------------------- | ------------------------- | ------------------------- |
| `ADSB_FEED_URL`      | URL of aircraft JSON feed | required                  |
| `ADSB_POLL_INTERVAL` | Poll interval (seconds)   | `5`                       |
| `COT_URL`            | Destination CoT           | `udp+wo://127.0.0.1:8087` |

---

### 🚢 AIS (aiscot)

| Variable   | Description     | Default                   |
| ---------- | --------------- | ------------------------- |
| `AIS_PORT` | UDP listen port | `5050`                    |
| `COT_URL`  | Destination CoT | `udp+wo://127.0.0.1:8087` |

---

### 🧠 cotproxy

| Variable          | Description           | Default                |
| ----------------- | --------------------- | ---------------------- |
| `COT_LISTEN_URL`  | Input CoT             | `udp://0.0.0.0:8087`   |
| `COT_FORWARD_URL` | Output CoT            | `tcp://127.0.0.1:9090` |
| `PASS_ALL`        | Forward all events    | `True`                 |
| `AUTO_ADD`        | Auto register senders | `True`                 |
| `SEED_FAA_REG`    | Enrich aircraft data  | `True`                 |

---

### 🎯 cot-multi-targets

| Variable         | Description     | Default |
| ---------------- | --------------- | ------- |
| `COT_MULTI_PORT` | TCP listen port | `9090`  |

---

### 🌐 cotproxyweb

| Variable               | Description         | Default   |
| ---------------------- | ------------------- | --------- |
| `ADMIN_USER`           | Admin username      | `admin`   |
| `ADMIN_PASSWORD`       | Admin password      | `admin`   |
| `DJANGO_ALLOWED_HOSTS` | Allowed hosts (CSV) | `0.0.0.0` |

⚠️ `localhost` and `127.0.0.1` are automatically added at runtime.

---

## 🌐 Networking

All services run in:

```yaml
network_mode: host
```

### ✅ Advantages

* Native UDP support
* Multicast compatibility
* No port mapping required
* Direct access to host services (ultrafeeder)

---

## ⚠️ Notes

* Ensure ports are free:

  * `5050` (AIS)
  * `10415` (web UI)

* `ultrafeeder` must be reachable from:

  ```
  ADSB_FEED_URL
  ```

---

## 🔐 Security

⚠️ Default credentials:

```text
admin / admin
```

👉 Change in production:

```yaml
- ADMIN_PASSWORD=StrongPassword
```

---

## 📦 Volumes

| Path            | Description                     |
| --------------- | ------------------------------- |
| `./config.json` | cot-multi-targets configuration |

---

## 🧪 Debugging

### Check logs

```bash
docker compose logs -f
```

---

### Access container

```bash
docker exec -it <container> bash
```

---

### Test CoT flow

* Verify UDP input on `8087`
* Verify TCP output on `9090`
* Check multitarget forwarding

---

## 🧠 Data Flow Summary

| Source          | Protocol | Destination      |
| --------------- | -------- | ---------------- |
| ADS-B           | HTTP     | adsbcot          |
| AIS             | UDP      | aiscot           |
| adsbcot         | UDP      | cotproxy         |
| aiscot          | UDP      | cotproxy         |
| cotproxy        | TCP      | cotmultitargets  |
| cotmultitargets | TCP/UDP  | external systems |

---

## 🛰️ Use Cases

* Tactical situational awareness
* Maritime + air traffic fusion
* ATAK ecosystem integration
* Edge deployments (Raspberry Pi, field nodes)

---

## 🙏 Credits

This project integrates:

* https://github.com/snstac/adsbcot
* https://github.com/snstac/aiscot
* https://github.com/ampledata/cotproxy
* https://github.com/ampledata/cotproxyweb

All credit goes to the original authors.

---

## 📜 License

This repository provides orchestration only.
Refer to upstream projects for licensing.

---

## 🚀 Future Improvements

* TLS support (cotproxy / multitarget)
* Reverse proxy (nginx)
* Metrics & observability
* Authentication hardening
* Kubernetes deployment

---

## 🎯 Final Note

This stack is designed to be:

> 🧠 modular
> 🐳 container-native
> 🛰️ field-ready

---

**Plug it. Run it. Observe the world.**
