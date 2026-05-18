# 🌐 cotproxyweb Docker Container

This container provides a web interface for monitoring and interacting with CoT data via **cotproxyweb**.

---

## 🎯 Overview

**cotproxyweb** is a Django-based web application that allows you to:

* Visualize CoT data
* Monitor incoming events
* Debug CoT pipelines

```text
CoT Flow → cotproxy → cotproxyweb (UI)
```

---

## ⚙️ Features

* 🌐 Web-based interface for CoT monitoring
* 📊 Real-time event visualization
* 🧠 Built on Django (stable, mature framework)
* 📦 Installed via Debian packages (no pip)
* 🌍 Multi-architecture ready (amd64 / arm64)

---

## 🚀 Quick Start

### 🔨 Build

```bash
docker build -t cotproxyweb .
```

---

### ▶️ Run

```bash
docker run --rm -it \
  -p 8000:8000 \
  cotproxyweb
```

---

## 🌐 Access

Open your browser:

```
http://localhost:8000
```

---

## 🔐 Admin User

An admin account is created automatically on first startup.

### Environment Variables

| Variable | Default | Description |
|----------|--------|------------|
| `ADMIN_USER` | `admin` | Admin username |
| `ADMIN_EMAIL` | `admin@example.com` | Admin email |
| `ADMIN_PASSWORD` | `admin` | Admin password |

### Example

```bash
docker run --rm -it \
  -p 8000:8000 \
  -e ADMIN_PASSWORD=StrongPassword \
  cotproxyweb

---

## ⚙️ Configuration

### Environment Variables

| Variable | Default   | Description     |
| -------- | --------- | --------------- |
| `PORT`   | `10415`   | Web server port |
| `BIND`   | `0.0.0.0` | Bind address    |

---

### Example

```bash
docker run --rm -it \
  -p 10415:10415 \
  -e PORT=10415 \
  cotproxyweb
```

---

## 🗄️ Database

* Uses SQLite by default
* Automatically initialized at build time
* Stored inside container

💡 To persist data:

```bash
-v ./data:/opt/cotproxyweb/db.sqlite3
```

---

## 🌐 Networking Notes

* Runs over HTTP (no TLS by default)
* Intended for:

  * Internal networks
  * Debug environments
* Should be placed behind a reverse proxy for production

---

## ⚠️ Limitations

* Not hardened for public exposure
* No built-in authentication security (default admin)
* No HTTPS support out of the box

---

## 🧩 Integration Example

```text
adsbcot → cotproxy → cotproxyweb (monitoring)
aiscot  ┘
```

---

## 🙏 Credits

This container packages:

* **cotproxyweb** by AmpleData
  👉 https://github.com/ampledata/cotproxyweb

Built on:

* Django
* Django REST Framework

All credit goes to the original authors.

---

## 📜 License

Refer to upstream project:

* https://github.com/ampledata/cotproxyweb

---

## 💡 Future Improvements

* TLS / HTTPS support
* Reverse proxy integration (nginx)
* Authentication hardening
* Metrics and dashboards

---

## 🛰️ Use Case

This container is designed for:

* CoT pipeline monitoring
* Debugging data flows
* Development and testing environments

---

**Your window into the CoT stream.**
