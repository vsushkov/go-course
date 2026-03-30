# Basic Go Web Services Observability Stack

##  Quick Start

### Prerequisites
- Docker and Docker Compose
- Go

### 1. Setup Observability Stack
```bash
# Start all observability services
./setup.sh
```

### 2. Run Go Application Locally (expecting metrics on port 5123)

### 3. Access the Services
- **Grafana**: http://localhost:3000 (admin/admin)
- **Victoria Metrics**: http://localhost:8428"
- **Go Application**: http://localhost:8080"

### 4. Stop Everything
```bash
# Stop the Go application (Ctrl+C)
# Stop observability services
docker-compose down
```

## 📊 Observability Stack Components

### 📈 Metrics & Storage
- **Victoria Metrics** - High-performance metrics storage (faster than Prometheus)
  - URL: http://localhost:8428
  - Web UI available at the above URL

### 🎨 Visualization
- **Grafana** - Data visualization and dashboarding
  - URL: http://localhost:3000
  - Username: `admin`
  - Password: `admin`

## 🔧 Configuration

### Victoria Metrics Agent Configuration

The agent is configured in `vmagent-config.yml` with **Scraping**: Direct scraping from Go application and other services

## 🔍 Troubleshooting

### Common Issues

1. **Services not starting**
   ```bash
   # Check Docker logs
   docker-compose logs [service-name]
   
   # Check port conflicts
   netstat -tulpn | grep [port]
   ```

2. **No metrics in Grafana**
   - Verify vmagent is running and scraping metrics
   - Verify data source configuration

## 📚 Additional Resources

- [Victoria Metrics Documentation](https://docs.victoriametrics.com/)
- [Grafana Documentation](https://grafana.com/docs/)
